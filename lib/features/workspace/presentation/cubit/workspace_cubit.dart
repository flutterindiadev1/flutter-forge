import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterforge_backend_client/flutterforge_backend_client.dart';
import 'workspace_state.dart';

class WorkspaceCubit extends Cubit<WorkspaceState> {
  final Client client;
  final String projectId;

  WorkspaceCubit({required this.client, required this.projectId}) : super(const WorkspaceLoading()) {
    loadWorkspace();
  }



  Future<void> loadWorkspace() async {
    try {
      emit(const WorkspaceLoading());
      final project = await client.project.getProject(projectId);
      if (project == null) {
        emit(const WorkspaceError('Project not found'));
        return;
      }
      final files = await client.project.listProjectFiles(projectId);
      emit(
        WorkspaceLoaded(
          project: project,
          files: files,
        ),
      );
    } catch (e) {
      emit(WorkspaceError('Failed to load workspace: $e'));
    }
  }

  Future<void> openFile(String filePath) async {
    if (state is WorkspaceLoaded) {
      final loadedState = state as WorkspaceLoaded;
      emit(loadedState.copyWith(isLoadingFile: true, activeFile: filePath));

      try {
        final content = await client.project.getFileContent(
          projectId,
          filePath,
        );
        emit(
          loadedState.copyWith(
            activeFile: filePath,
            activeFileContent: content ?? 'Error loading file',
            isLoadingFile: false,
          ),
        );
      } catch (e) {
        emit(
          loadedState.copyWith(
            activeFileContent: 'Failed to load: $e',
            isLoadingFile: false,
          ),
        );
      }
    }
  }

  Future<void> saveFile() async {
    if (state is WorkspaceLoaded) {
      final loadedState = state as WorkspaceLoaded;
      if (loadedState.activeFile == null ||
          loadedState.activeFileContent == null) {
        return;
      }

      emit(loadedState.copyWith(isSavingFile: true));
      try {
        final success = await client.project.saveFileContent(
          projectId,
          loadedState.activeFile!,
          loadedState.activeFileContent!,
        );

        if (success) {
          emit(
            loadedState.copyWith(isSavingFile: false, hasUnsavedChanges: false),
          );
        } else {
          emit(loadedState.copyWith(isSavingFile: false));
          // Could show a toast or error here
        }
      } catch (e) {
        emit(loadedState.copyWith(isSavingFile: false));
      }
    }
  }

  void updateActiveFileContent(String content) {
    if (state is WorkspaceLoaded) {
      final loadedState = state as WorkspaceLoaded;
      emit(
        loadedState.copyWith(
          activeFileContent: content,
          hasUnsavedChanges: true,
        ),
      );
    }
  }

}
