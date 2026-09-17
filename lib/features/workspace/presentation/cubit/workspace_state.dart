import 'package:equatable/equatable.dart';
import 'package:flutterforge_backend_client/flutterforge_backend_client.dart';

abstract class WorkspaceState extends Equatable {
  const WorkspaceState();

  @override
  List<Object?> get props => [];
}

class WorkspaceLoading extends WorkspaceState {
  const WorkspaceLoading();
}

class WorkspaceLoaded extends WorkspaceState {
  final ProjectRecord project;
  final List<String> files;
  final String? activeFile;
  final String? activeFileContent;
  final bool isLoadingFile;
  final bool isSavingFile;
  final bool hasUnsavedChanges;

  const WorkspaceLoaded({
    required this.project,
    required this.files,
    this.activeFile,
    this.activeFileContent,
    this.isLoadingFile = false,
    this.isSavingFile = false,
    this.hasUnsavedChanges = false,
  });

  WorkspaceLoaded copyWith({
    ProjectRecord? project,
    List<String>? files,
    String? activeFile,
    String? activeFileContent,
    bool? isLoadingFile,
    bool? isSavingFile,
    bool? hasUnsavedChanges,
  }) {
    return WorkspaceLoaded(
      project: project ?? this.project,
      files: files ?? this.files,
      activeFile: activeFile ?? this.activeFile,
      activeFileContent: activeFileContent ?? this.activeFileContent,
      isLoadingFile: isLoadingFile ?? this.isLoadingFile,
      isSavingFile: isSavingFile ?? this.isSavingFile,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
    );
  }

  @override
  List<Object?> get props => [
    project,
    files,
    activeFile,
    activeFileContent,
    isLoadingFile,
    isSavingFile,
    hasUnsavedChanges,
  ];
}

class WorkspaceError extends WorkspaceState {
  final String message;

  const WorkspaceError(this.message);

  @override
  List<Object?> get props => [message];
}
