import 'package:equatable/equatable.dart';
import '../../wizard/models/project_config.dart';

enum ProjectStatus { draft, generating, ready, failed }

class ProjectSummary extends Equatable {
  final String id;
  final String name;
  final String description;
  final String team;
  final ProjectStatus status;
  final List<String> platforms;
  final String architecture;
  final int featureCount;
  final DateTime lastUpdated;
  final ProjectConfig config;

  const ProjectSummary({
    required this.id,
    required this.name,
    required this.description,
    required this.team,
    required this.status,
    required this.platforms,
    required this.architecture,
    required this.featureCount,
    required this.lastUpdated,
    required this.config,
  });

  @override
  List<Object?> get props => [id, name, status];
}
