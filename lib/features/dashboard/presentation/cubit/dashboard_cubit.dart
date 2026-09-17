import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/project_summary.dart';
import 'dashboard_state.dart';
import 'dart:convert';
import '../../../../core/network/api_client.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardLoading()) {
    _loadProjects();
  }

  Future<void> _loadProjects({String? currentKey}) async {
    try {
      final settings = await client.user.getSettings();
      currentKey = settings.geminiApiKey ?? currentKey;
    } catch (e) {
      debugPrint('Could not load user settings: $e');
    }

    List<ProjectSummary> summaries = [];
    try {
      final records = await client.project.listProjects();
      summaries = records.map((record) {
        final configMap = jsonDecode(record.configJson) as Map<String, dynamic>;
        
        final name = configMap['projectName'] as String? ?? 'Unknown';
        final description = configMap['description'] as String? ?? '';
        final team = configMap['team'] as String? ?? '';
        final platforms = (configMap['platforms'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
        final arch = (configMap['architecture'] as Map<String, dynamic>?)?['pattern'] as String? ?? '';
        final featuresCount = (configMap['features'] as List<dynamic>?)?.length ?? 0;
        
        ProjectStatus status;
        switch (record.status) {
          case 'pending':
          case 'generating':
            status = ProjectStatus.generating;
            break;
          case 'ready':
          case 'done':
            status = ProjectStatus.ready;
            break;
          default:
            status = ProjectStatus.failed;
        }
        
        return ProjectSummary(
          id: record.projectId,
          name: name,
          description: description,
          team: team,
          status: status,
          platforms: platforms,
          architecture: arch,
          featureCount: featuresCount,
          lastUpdated: record.createdAt,
        );
      }).toList();
    } catch (e) {
      debugPrint('Failed to load projects: $e');
    }

    emit(DashboardLoaded(summaries, globalApiKey: currentKey));
  }

  Future<void> refresh() async {
    final currentKey = state is DashboardLoaded ? (state as DashboardLoaded).globalApiKey : null;
    emit(const DashboardLoading());
    await _loadProjects(currentKey: currentKey);
  }

  void updateApiKey(String apiKey) {
    if (state is DashboardLoaded) {
      final loadedState = state as DashboardLoaded;
      emit(loadedState.copyWith(globalApiKey: apiKey));
    }
  }
}
