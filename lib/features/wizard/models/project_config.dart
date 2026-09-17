import 'package:equatable/equatable.dart';
import 'feature_node.dart';

class PostmanCollection extends Equatable {
  final String name;
  final String version;
  final List<PostmanFolder> folders;

  const PostmanCollection({
    required this.name,
    required this.version,
    required this.folders,
  });

  factory PostmanCollection.fromJson(Map<String, dynamic> json) {
    final info = json['info'] as Map<String, dynamic>? ?? {};
    final items = json['item'] as List<dynamic>? ?? [];
    return PostmanCollection(
      name: info['name']?.toString() ?? 'Unnamed Collection',
      version: info['schema']?.toString().contains('2.1') == true ? '2.1' : '2.0',
      folders: items.map((i) => PostmanFolder.fromJson(i as Map<String, dynamic>)).toList(),
    );
  }

  @override
  List<Object?> get props => [name, version, folders];
}

class PostmanFolder extends Equatable {
  final String name;
  final List<PostmanEndpoint> endpoints;
  final List<PostmanFolder> subfolders;

  const PostmanFolder({
    required this.name,
    required this.endpoints,
    required this.subfolders,
  });

  factory PostmanFolder.fromJson(Map<String, dynamic> json) {
    final items = json['item'] as List<dynamic>? ?? [];
    final endpoints = <PostmanEndpoint>[];
    final subfolders = <PostmanFolder>[];

    for (final item in items) {
      final m = item as Map<String, dynamic>;
      if (m.containsKey('item')) {
        subfolders.add(PostmanFolder.fromJson(m));
      } else if (m.containsKey('request')) {
        endpoints.add(PostmanEndpoint.fromJson(m));
      }
    }

    return PostmanFolder(
      name: json['name']?.toString() ?? 'Unnamed',
      endpoints: endpoints,
      subfolders: subfolders,
    );
  }

  @override
  List<Object?> get props => [name, endpoints, subfolders];
}

class PostmanEndpoint extends Equatable {
  final String name;
  final String method;
  final String path;
  final List<String> detectedSchemas;

  const PostmanEndpoint({
    required this.name,
    required this.method,
    required this.path,
    required this.detectedSchemas,
  });

  factory PostmanEndpoint.fromJson(Map<String, dynamic> json) {
    final request = json['request'] as Map<String, dynamic>? ?? {};
    final url = request['url'];
    String path = '';
    if (url is String) {
      path = url;
    } else if (url is Map) {
      final raw = url['raw'] as String? ?? '';
      path = raw;
    }

    final body = request['body'] as Map<String, dynamic>? ?? {};
    final schemas = <String>[];
    if (body['raw'] != null) schemas.add('JSON Body');
    if (body['formdata'] != null) schemas.add('Form Data');

    return PostmanEndpoint(
      name: json['name']?.toString() ?? 'Unnamed',
      method: request['method']?.toString().toUpperCase() ?? 'GET',
      path: path,
      detectedSchemas: schemas,
    );
  }

  @override
  List<Object?> get props => [name, method, path];
}

class ArchitectureConfig extends Equatable {
  final String pattern;
  final String stateManagement;
  final String di;
  final String network;
  final String localStorage;
  final String navigation;

  const ArchitectureConfig({
    required this.pattern,
    required this.stateManagement,
    required this.di,
    required this.network,
    required this.localStorage,
    required this.navigation,
  });

  Map<String, dynamic> toJson() => {
        'pattern': pattern,
        'stateManagement': stateManagement,
        'di': di,
        'network': network,
        'localStorage': localStorage,
        'navigation': navigation,
      };

  @override
  List<Object?> get props =>
      [pattern, stateManagement, di, network, localStorage, navigation];
}

class ProjectConfig extends Equatable {
  final String? projectId;
  final String projectName;
  final String description;
  final String team;
  final List<String> platforms;
  final String? figmaFileUrl;
  final String? figmaAccessToken;
  final PostmanCollection? postmanCollection;
  final ArchitectureConfig? architecture;
  final List<FeatureNode> features;

  const ProjectConfig({
    this.projectId,
    this.projectName = '',
    this.description = '',
    this.team = '',
    this.platforms = const [],
    this.figmaFileUrl,
    this.figmaAccessToken,
    this.postmanCollection,
    this.architecture,
    this.features = const [],
  });

  ProjectConfig copyWith({
    String? projectId,
    String? projectName,
    String? description,
    String? team,
    List<String>? platforms,
    String? figmaFileUrl,
    String? figmaAccessToken,
    PostmanCollection? postmanCollection,
    ArchitectureConfig? architecture,
    List<FeatureNode>? features,
  }) {
    return ProjectConfig(
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      description: description ?? this.description,
      team: team ?? this.team,
      platforms: platforms ?? this.platforms,
      figmaFileUrl: figmaFileUrl ?? this.figmaFileUrl,
      figmaAccessToken: figmaAccessToken ?? this.figmaAccessToken,
      postmanCollection: postmanCollection ?? this.postmanCollection,
      architecture: architecture ?? this.architecture,
      features: features ?? this.features,
    );
  }

  Map<String, dynamic> toJson() => {
        'projectId': projectId,
        'projectName': projectName,
        'description': description,
        'team': team,
        'platforms': platforms,
        'figma': {
          'fileUrl': figmaFileUrl,
          'accessToken': figmaAccessToken,
        },
        'postman': postmanCollection != null
            ? {
                'collectionVersion': postmanCollection!.version,
                'name': postmanCollection!.name,
                'folderCount': postmanCollection!.folders.length,
              }
            : null,
        'architecture': architecture?.toJson(),
        'features': features.map((f) => f.toJson()).toList(),
      };

  String get slug => projectName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');

  @override
  List<Object?> get props => [
        projectId, projectName, description, team, platforms,
        figmaFileUrl, architecture, features
      ];
}
