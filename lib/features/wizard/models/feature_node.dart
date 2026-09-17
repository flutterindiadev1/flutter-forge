import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

enum FeatureLayer { ui, domain, data, shared }

class FeatureNode extends Equatable {
  final String id;
  final String name;
  final String description;
  final FeatureLayer layer;
  final List<String> dependencyIds;
  // Layout position for the graph
  final double? x;
  final double? y;

  const FeatureNode({
    required this.id,
    required this.name,
    this.description = '',
    this.layer = FeatureLayer.domain,
    this.dependencyIds = const [],
    this.x,
    this.y,
  });

  factory FeatureNode.create({
    required String name,
    String description = '',
    FeatureLayer layer = FeatureLayer.domain,
  }) {
    return FeatureNode(
      id: 'feat_${const Uuid().v4().substring(0, 8)}',
      name: name,
      description: description,
      layer: layer,
    );
  }

  FeatureNode copyWith({
    String? name,
    String? description,
    FeatureLayer? layer,
    List<String>? dependencyIds,
    double? x,
    double? y,
  }) {
    return FeatureNode(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      layer: layer ?? this.layer,
      dependencyIds: dependencyIds ?? this.dependencyIds,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'layer': layer.name,
        'dependencies': dependencyIds,
      };

  @override
  List<Object?> get props => [id, name, layer, dependencyIds];
}

/// Detects circular dependencies in the feature graph using DFS
class DependencyGraphValidator {
  static List<String> detectCycles(List<FeatureNode> nodes) {
    final nodeMap = {for (final n in nodes) n.id: n};
    final visited = <String>{};
    final inStack = <String>{};
    final cycles = <String>[];

    void dfs(String id, List<String> path) {
      if (inStack.contains(id)) {
        cycles.add(path.join(' → ') + ' → $id');
        return;
      }
      if (visited.contains(id)) return;
      visited.add(id);
      inStack.add(id);
      final node = nodeMap[id];
      if (node != null) {
        for (final dep in node.dependencyIds) {
          dfs(dep, [...path, id]);
        }
      }
      inStack.remove(id);
    }

    for (final node in nodes) {
      dfs(node.id, []);
    }
    return cycles;
  }
}
