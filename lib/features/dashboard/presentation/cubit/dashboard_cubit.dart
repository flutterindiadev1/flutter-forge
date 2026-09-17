import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/project_summary.dart';
import 'dashboard_state.dart';


class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardLoading()) {
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Mock projects for demo
    emit(DashboardLoaded([
      ProjectSummary(
        id: 'proj_001',
        name: 'EcommerceApp',
        description: 'Full-featured e-commerce platform with cart and payments',
        team: 'Acme Corp',
        status: ProjectStatus.ready,
        platforms: ['iOS', 'Android', 'Web'],
        architecture: 'Clean Architecture + BLoC',
        featureCount: 8,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ProjectSummary(
        id: 'proj_002',
        name: 'HealthTracker',
        description: 'IoT-connected health monitoring with real-time dashboards',
        team: 'MedTech Team',
        status: ProjectStatus.generating,
        platforms: ['iOS', 'Android'],
        architecture: 'Hexagonal + Riverpod',
        featureCount: 5,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      ProjectSummary(
        id: 'proj_003',
        name: 'AdminPortal',
        description: 'Internal backoffice with role-based access control',
        team: 'Platform Team',
        status: ProjectStatus.draft,
        platforms: ['Web'],
        architecture: 'Clean Architecture + GetX',
        featureCount: 3,
        lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ]));
  }

  Future<void> refresh() async {
    emit(const DashboardLoading());
    await _loadProjects();
  }
}
