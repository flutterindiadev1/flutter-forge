import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ProjectEndpoint extends Endpoint {
  Future<String> submitConfig(Session session, ProjectConfig config) async {
    final generatedId = Uuid().v4();
    session.log('Received project config for: ${config.projectName}');
    session.log('Platforms: ${config.platforms.join(', ')}');
    session.log('Architecture: ${config.architecture?.pattern}');
    
    // Store in DB for pipeline processor to load
    final patchedJson = {
      ...config.toJson(),
      'projectId': generatedId,
    };
    
    final record = ProjectRecord(
      projectId: generatedId,
      userId: session.authenticated?.userIdentifier?.toString(),
      configJson: jsonEncode(patchedJson),
      status: 'pending',
      createdAt: DateTime.now(),
    );
    await ProjectRecord.db.insertRow(session, record);
    
    return generatedId;
  }

  Future<List<ProjectRecord>> listProjects(Session session) async {
    final userId = session.authenticated?.userIdentifier?.toString();
    if (userId == null) {
      return []; // Return empty if not authenticated
    }
    
    final records = await ProjectRecord.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
    
    return records;
  }

  Future<ProjectRecord?> getProject(Session session, String projectId) async {
    final userId = session.authenticated?.userIdentifier?.toString();
    if (userId == null) return null;

    return await ProjectRecord.db.findFirstRow(
      session,
      where: (t) => t.projectId.equals(projectId) & t.userId.equals(userId),
    );
  }

  Future<List<String>> listProjectFiles(Session session, String projectId) async {
    final userId = session.authenticated?.userIdentifier?.toString();
    if (userId == null) return [];

    final project = await getProject(session, projectId);
    if (project == null) return [];

    final dir = Directory('/tmp/flutterforge/$projectId');
    if (!await dir.exists()) return [];

    final files = <String>[];
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        // Skip .git and build directories
        if (entity.path.contains('/.git/') || entity.path.contains('/build/')) continue;
        files.add(entity.path.substring(dir.path.length + 1));
      }
    }
    
    files.sort();
    return files;
  }

  Future<String?> getFileContent(Session session, String projectId, String filePath) async {
    final userId = session.authenticated?.userIdentifier?.toString();
    if (userId == null) return null;

    final project = await getProject(session, projectId);
    if (project == null) return null;

    // Simple path traversal protection
    if (filePath.contains('..')) return null;

    final file = File('/tmp/flutterforge/$projectId/$filePath');
    if (!await file.exists()) return null;

    try {
      return await file.readAsString();
    } catch (e) {
      session.log('Failed to read file $filePath: $e', level: LogLevel.error);
      return null;
    }
  }

  Future<bool> saveFileContent(Session session, String projectId, String filePath, String content) async {
    final userId = session.authenticated?.userIdentifier?.toString();
    if (userId == null) return false;

    final project = await getProject(session, projectId);
    if (project == null) return false;

    if (filePath.contains('..')) return false;

    final file = File('/tmp/flutterforge/$projectId/$filePath');
    
    // Ensure parent directory exists if new file
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }

    try {
      await file.writeAsString(content);
      return true;
    } catch (e) {
      session.log('Failed to write file $filePath: $e', level: LogLevel.error);
      return false;
    }
  }

  Future<bool> commitAndPush(Session session, String projectId, String commitMessage) async {
    final userId = session.authenticated?.userIdentifier?.toString();
    if (userId == null) return false;

    final project = await getProject(session, projectId);
    if (project == null) return false;

    // Load github token
    var settings = await UserSettings.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(userId),
    );
    
    final token = settings?.githubToken;
    if (token == null || token.isEmpty) return false;
    
    final projectPath = '/tmp/flutterforge/$projectId';

    try {
      final addRes = await Process.run('git', ['add', '.'], workingDirectory: projectPath);
      if (addRes.exitCode != 0) return false;

      final commitRes = await Process.run('git', ['commit', '-m', commitMessage], workingDirectory: projectPath);
      // git commit returns 1 if there's nothing to commit. We can just ignore or pass through
      if (commitRes.exitCode != 0 && !commitRes.stdout.toString().contains('nothing to commit')) {
        return false;
      }

      final pushRes = await Process.run('git', ['push'], workingDirectory: projectPath);
      return pushRes.exitCode == 0;
    } catch (e) {
      session.log('Git operation failed: $e', level: LogLevel.error);
      return false;
    }
  }

  Future<PubDependency?> resolvePubDependency(Session session, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.host != 'pub.dev') {
      return null;
    }

    final pathSegments = uri.pathSegments;
    if (pathSegments.isEmpty || pathSegments[0] != 'packages') {
      return null;
    }

    final packageName = pathSegments[1];

    try {
      final response = await http.get(Uri.parse('https://pub.dev/api/packages/$packageName'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final latestVersion = data['latest']['version'] as String;
        return PubDependency(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          packageName: packageName,
          pubDevUrl: url,
          version: latestVersion,
        );
      }
    } catch (e) {
      session.log('Failed to fetch package data for $packageName: $e', level: LogLevel.error);
    }

    return null;
  }
}
