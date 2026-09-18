import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:path/path.dart' as p;
import '../generated/protocol.dart';

class ProjectEndpoint extends Endpoint {
  Future<String> submitConfig(Session session, ProjectConfig config) async {
    final generatedId = Uuid().v4();
    session.log('Received project config for: ${config.projectName}');
    session.log('Platforms: ${config.platforms.join(', ')}');
    session.log('Architecture: ${config.architecture?.pattern}');
    
    // Store in DB for pipeline processor to load, stripping secrets
    final patchedJson = config.toJson();
    patchedJson['projectId'] = generatedId;
    
    final record = ProjectRecord(
      projectId: generatedId,
      userId: session.authenticated?.userIdentifier.toString(),
      configJson: jsonEncode(patchedJson),
      status: 'pending',
      createdAt: DateTime.now(),
    );
    await ProjectRecord.db.insertRow(session, record);
    
    return generatedId;
  }

  Future<List<ProjectRecord>> listProjects(Session session) async {
    final userId = session.authenticated?.userIdentifier.toString();
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
    final userId = session.authenticated?.userIdentifier.toString();
    if (userId == null) return null;

    return await ProjectRecord.db.findFirstRow(
      session,
      where: (t) => t.projectId.equals(projectId) & t.userId.equals(userId),
    );
  }

  Future<void> updateProjectConfig(Session session, String projectId, ProjectConfig config) async {
    final record = await getProject(session, projectId);
    if (record == null) {
      throw Exception('Project not found or unauthorized');
    }

    final patchedJson = config.toJson();
    patchedJson['projectId'] = projectId;
    
    record.configJson = jsonEncode(patchedJson);
    record.status = 'pending';
    record.updatedAt = DateTime.now();

    await ProjectRecord.db.updateRow(session, record);
  }

  Future<void> deleteProject(Session session, String projectId) async {
    final record = await getProject(session, projectId);
    if (record == null) {
      throw Exception('Project not found or unauthorized');
    }

    await ProjectRecord.db.deleteRow(session, record);

    final projectDir = Directory('/tmp/flutterforge/$projectId');
    if (await projectDir.exists()) {
      await projectDir.delete(recursive: true);
    }
  }

  Future<List<String>> listProjectFiles(Session session, String projectId) async {
    final userId = session.authenticated?.userIdentifier.toString();
    if (userId == null) return [];

    final project = await getProject(session, projectId);
    if (project == null) return [];

    final dir = Directory('/tmp/flutterforge/$projectId');
    if (!await dir.exists()) return [];

    final files = <String>[];
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        final relPath = entity.path.substring(dir.path.length + 1);
        
        // Skip hidden directories like .git, .dart_tool, .idea, and build output
        if (relPath.startsWith('.git/') || 
            relPath.startsWith('.dart_tool/') || 
            relPath.startsWith('.idea/') || 
            relPath.startsWith('build/') ||
            relPath.contains('/.git/') || 
            relPath.contains('/.dart_tool/') || 
            relPath.contains('/.idea/') || 
            relPath.contains('/build/')) {
          continue;
        }

        files.add(relPath);
      }
    }
    
    files.sort();
    return files;
  }

  Future<bool> deleteFile(Session session, String projectId, String filePath) async {
    final userId = session.authenticated?.userIdentifier.toString();
    if (userId == null) return false;

    final project = await getProject(session, projectId);
    if (project == null) return false;

    final basePath = p.canonicalize('/tmp/flutterforge/$projectId');
    final requestedPath = p.canonicalize(p.join(basePath, filePath));

    if (!requestedPath.startsWith(basePath)) return false;

    final file = File(requestedPath);
    if (!await file.exists()) return false;

    try {
      await file.delete();
      return true;
    } catch (e) {
      session.log('Failed to delete file $filePath: $e', level: LogLevel.error);
      return false;
    }
  }

  Future<String?> getFileContent(Session session, String projectId, String filePath) async {
    final userId = session.authenticated?.userIdentifier.toString();
    if (userId == null) return null;

    final project = await getProject(session, projectId);
    if (project == null) return null;

    final basePath = p.canonicalize('/tmp/flutterforge/$projectId');
    final requestedPath = p.canonicalize(p.join(basePath, filePath));

    if (!requestedPath.startsWith(basePath)) return null;

    final file = File(requestedPath);
    if (!await file.exists()) return null;

    try {
      return await file.readAsString();
    } catch (e) {
      session.log('Failed to read file $filePath: $e', level: LogLevel.error);
      return null;
    }
  }

  Future<bool> saveFileContent(Session session, String projectId, String filePath, String content) async {
    final userId = session.authenticated?.userIdentifier.toString();
    if (userId == null) return false;

    final project = await getProject(session, projectId);
    if (project == null) return false;

    final basePath = p.canonicalize('/tmp/flutterforge/$projectId');
    final requestedPath = p.canonicalize(p.join(basePath, filePath));

    if (!requestedPath.startsWith(basePath)) return false;

    final file = File(requestedPath);
    
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
