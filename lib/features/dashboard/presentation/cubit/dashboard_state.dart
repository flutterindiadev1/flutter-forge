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
  const DashboardLoaded(this.projects);
  @override
  List<Object?> get props => [projects];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override
  List<Object?> get props => [message];
}
