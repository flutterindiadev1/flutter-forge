import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/project_summary.dart';
import 'dashboard_state.dart';
import 'dart:convert';
import '../../../../core/network/api_client.dart';

import '../../../wizard/models/project_config_parsers.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardLoading()) {
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    try {
      final settings = await client.user.getSettings();
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
        
        final config = parseProjectConfig(configMap);
        
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
          config: config,
        );
      }).toList();
    } catch (e) {
      debugPrint('Could not load projects: $e');
    }

    emit(DashboardLoaded(summaries));
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await client.project.deleteProject(projectId);
      if (state is DashboardLoaded) {
        final currentProjects = (state as DashboardLoaded).projects;
        final updatedProjects = currentProjects.where((p) => p.id != projectId).toList();
        emit(DashboardLoaded(updatedProjects));
      }
    } catch (e) {
      debugPrint('Failed to delete project: $e');
      // Could emit an error state here, but for now just reload
      _loadProjects();
    }
  }

  Future<void> refresh() async {
    emit(const DashboardLoading());
    await _loadProjects();
  }
}
