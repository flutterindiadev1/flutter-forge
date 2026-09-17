import 'package:equatable/equatable.dart';
import '../../models/project_summary.dart';


abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final List<ProjectSummary> projects;
  final String? globalApiKey;

  const DashboardLoaded(this.projects, {this.globalApiKey});

  DashboardLoaded copyWith({
    List<ProjectSummary>? projects,
    String? globalApiKey,
  }) {
    return DashboardLoaded(
      projects ?? this.projects,
      globalApiKey: globalApiKey ?? this.globalApiKey,
    );
  }

  @override
  List<Object?> get props => [projects, globalApiKey];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override
  List<Object?> get props => [message];
}
