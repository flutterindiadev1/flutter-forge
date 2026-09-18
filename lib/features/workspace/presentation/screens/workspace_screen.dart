import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../../../app/theme/app_theme.dart';
import '../cubit/workspace_cubit.dart';
import '../cubit/workspace_state.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/json.dart';
import 'package:highlight/languages/yaml.dart';

class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  CodeController? _codeController;
  String? _currentFilePath;

  @override
  void dispose() {
    _codeController?.dispose();
    super.dispose();
  }

  void _initCodeController(String content, String filePath) {
    if (_codeController != null &&
        _currentFilePath == filePath &&
        _codeController!.text == content) {
      return; // Already initialized for this content
    }

    _currentFilePath = filePath;
    _codeController?.dispose();

    var language = dart;
    if (filePath.endsWith('.yaml')) language = yaml;
    if (filePath.endsWith('.json')) language = json;

    _codeController = CodeController(text: content, language: language);

    _codeController!.addListener(() {
      context.read<WorkspaceCubit>().updateActiveFileContent(
        _codeController!.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<WorkspaceCubit, WorkspaceState>(
        builder: (context, state) {
          if (state is WorkspaceLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WorkspaceError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: AppTextStyles.body.copyWith(color: AppColors.error),
                  ),
                  const Gap(16),
                  ElevatedButton(
                    onPressed: () => context.go('/dashboard'),
                    child: const Text('Back to Dashboard'),
                  ),
                ],
              ),
            );
          }
          if (state is WorkspaceLoaded) {
            return Row(
              children: [
                _buildSidebar(context, state),
                Expanded(child: _buildMainContent(context, state)),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, WorkspaceLoaded state) {
    return Container(
      width: 260,
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context, state),
          const Divider(height: 1),
          Expanded(child: _buildFileExplorer(context, state)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WorkspaceLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => context.go('/dashboard'),
          ),
          const Gap(8),
          Expanded(
            child: Text(
              'Workspace',
              style: AppTextStyles.h4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  _FileNode _buildFileTree(List<String> paths) {
    final root = _FileNode('root');
    for (final path in paths) {
      final parts = path.split('/');
      _FileNode current = root;
      for (int i = 0; i < parts.length; i++) {
        final part = parts[i];
        if (i == parts.length - 1) {
          current.children[part] ??= _FileNode(part, path);
        } else {
          current.children[part] ??= _FileNode(part);
          current = current.children[part]!;
        }
      }
    }
    return root;
  }

  Widget _buildTreeNode(
    BuildContext context,
    _FileNode node,
    int depth,
    WorkspaceLoaded state,
  ) {
    if (node.name == 'root') {
      final sortedChildren = node.children.values.toList()
        ..sort((a, b) {
          if (a.isFolder && !b.isFolder) return -1;
          if (!a.isFolder && b.isFolder) return 1;
          return a.name.compareTo(b.name);
        });

      return ListView(
        children: sortedChildren
            .map((child) => _buildTreeNode(context, child, 0, state))
            .toList(),
      );
    }

    if (node.isFolder) {
      final sortedChildren = node.children.values.toList()
        ..sort((a, b) {
          if (a.isFolder && !b.isFolder) return -1;
          if (!a.isFolder && b.isFolder) return 1;
          return a.name.compareTo(b.name);
        });

      return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: depth < 2,
          dense: true,
          visualDensity: const VisualDensity(vertical: -4),
          tilePadding: EdgeInsets.only(left: depth * 16.0 + 16.0, right: 16.0),
          title: Row(
            children: [
              const Icon(
                Icons.folder_outlined,
                size: 16,
                color: AppColors.primary,
              ),
              const Gap(8),
              Expanded(
                child: Text(
                  node.name,
                  style: AppTextStyles.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          children: sortedChildren
              .map((child) => _buildTreeNode(context, child, depth + 1, state))
              .toList(),
        ),
      );
    }

    final isSelected = node.fullPath == state.activeFile;
    return InkWell(
      onTap: () => context.read<WorkspaceCubit>().openFile(node.fullPath!),
      child: Container(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        padding: EdgeInsets.only(
          left: depth * 16.0 + 32.0,
          right: 16.0,
          top: 4.0,
          bottom: 4.0,
        ),
        child: Row(
          children: [
            Icon(
              _getFileIcon(node.name),
              size: 16,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
            ),
            const Gap(8),
            Expanded(
              child: Text(
                node.name,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileExplorer(BuildContext context, WorkspaceLoaded state) {
    if (state.files.isEmpty) {
      return Center(
        child: Text('No files found', style: AppTextStyles.bodySmall),
      );
    }

    final root = _buildFileTree(state.files);
    return _buildTreeNode(context, root, 0, state);
  }

  IconData _getFileIcon(String path) {
    if (path.endsWith('.dart')) return Icons.code;
    if (path.endsWith('.yaml') || path.endsWith('.json')) return Icons.settings;
    if (path.endsWith('.md')) return Icons.description;
    return Icons.insert_drive_file;
  }

  Widget _buildMainContent(BuildContext context, WorkspaceLoaded state) {
    if (state.activeFile == null) {
      return Center(
        child: Text('Select a file to view', style: AppTextStyles.body),
      );
    }

    if (state.isLoadingFile) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.activeFileContent != null) {
      _initCodeController(state.activeFileContent!, state.activeFile!);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Tab bar
        Container(
          height: 48,
          color: AppColors.surfaceElevated,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(
                _getFileIcon(state.activeFile!),
                size: 16,
                color: AppColors.primary,
              ),
              const Gap(8),
              Text(
                state.activeFile! + (state.hasUnsavedChanges ? ' •' : ''),
                style: AppTextStyles.label.copyWith(
                  color: state.hasUnsavedChanges
                      ? AppColors.warning
                      : AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (state.isSavingFile)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              if (!state.isSavingFile)
                ElevatedButton.icon(
                  onPressed: state.hasUnsavedChanges
                      ? () => context.read<WorkspaceCubit>().saveFile()
                      : null,
                  icon: const Icon(Icons.save, size: 16),
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primary.withValues(
                      alpha: 0.3,
                    ),
                    disabledForegroundColor: Colors.white.withValues(
                      alpha: 0.5,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    elevation: 0,
                  ),
                ),
            ],
          ),
        ),
        // Code Viewer
        Expanded(
          child: _codeController == null
              ? const SizedBox.shrink()
              : CodeTheme(
                  data: CodeThemeData(styles: monokaiSublimeTheme),
                  child: SingleChildScrollView(
                    child: CodeField(
                      controller: _codeController!,
                      textStyle: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _FileNode {
  final String name;
  final String? fullPath;
  final Map<String, _FileNode> children = {};

  _FileNode(this.name, [this.fullPath]);

  bool get isFolder => fullPath == null;
}
