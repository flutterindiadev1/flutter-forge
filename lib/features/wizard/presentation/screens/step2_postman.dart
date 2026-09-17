import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:gap/gap.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../features/wizard/models/project_config.dart';
import '../cubit/wizard_cubit.dart';
import '../cubit/wizard_state.dart';
import 'wizard_widgets.dart';


class Step2Postman extends StatefulWidget {
  const Step2Postman({super.key});

  @override
  State<Step2Postman> createState() => _Step2PostmanState();
}

class _Step2PostmanState extends State<Step2Postman> {
  bool _isDragOver = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      final bytes = result.files.first.bytes;
      if (bytes != null) {
        final content = String.fromCharCodes(bytes);
        if (mounted) {
          context.read<WizardCubit>().loadPostmanCollection(content);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WizardCubit, WizardState>(
      builder: (context, state) {
        final collection = state.config.postmanCollection;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 780),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WizardSectionHeader(
                    icon: Icons.api_outlined,
                    title: 'Postman Collection',
                    subtitle:
                        'Upload your Postman JSON to auto-generate Dart DTOs and Dio clients.',
                  ),
                  const Gap(32),
                  if (collection == null) ...[
                    _buildUploadZone(),
                    const Gap(24),
                    _buildDemoHint(),
                  ] else ...[
                    _buildCollectionPreview(collection, context),
                  ],
                  if (state.errorMessage != null) ...[
                    const Gap(16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.error.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: AppColors.error, size: 18),
                          const Gap(10),
                          Expanded(
                            child: Text(
                              state.errorMessage!,
                              style: AppTextStyles.body.copyWith(
                                  color: AppColors.error),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUploadZone() {
    return GestureDetector(
      onTap: _pickFile,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isDragOver = true),
        onExit: (_) => setState(() => _isDragOver = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isDragOver
                ? AppColors.primary.withOpacity(0.06)
                : AppColors.surfaceElevated.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: DottedBorder(
            color: _isDragOver ? AppColors.primary : AppColors.border,
            strokeWidth: 1.5,
            dashPattern: const [8, 6],
            borderType: BorderType.RRect,
            radius: const Radius.circular(16),
            child: Container(
              height: 220,

              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _isDragOver
                          ? AppColors.primary.withOpacity(0.15)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.upload_file_outlined,
                      size: 28,
                      color: _isDragOver
                          ? AppColors.primary
                          : AppColors.textMuted,
                    ),
                  ),
                  const Gap(16),
                  Text(
                    'Drop your Postman Collection JSON here',
                    style: AppTextStyles.h4.copyWith(
                      color: _isDragOver
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    'or click to browse',
                    style: AppTextStyles.body,
                  ),
                  const Gap(12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      '.json',
                      style: AppTextStyles.code,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoHint() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: AppColors.info, size: 18),
          const Gap(12),
          Expanded(
            child: Text(
              'Export from Postman: File → Export → Collection v2.1',
              style: AppTextStyles.body.copyWith(color: AppColors.info),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionPreview(
      PostmanCollection collection, BuildContext context) {
    final totalEndpoints = _countEndpoints(collection.folders);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Success header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.success.withOpacity(0.25)),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline,
                  color: AppColors.success, size: 24),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(collection.name, style: AppTextStyles.h4),
                    Text(
                      'v${collection.version} · ${collection.folders.length} folders · $totalEndpoints endpoints detected',
                      style: AppTextStyles.body,
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  context.read<WizardCubit>().clearPostmanCollection();
                },
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Replace'),
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        const Gap(24),
        Text('Detected Endpoints', style: AppTextStyles.h4),
        const Gap(12),
        ...collection.folders.map((folder) => _FolderWidget(folder: folder)),
      ],
    );
  }

  int _countEndpoints(List<PostmanFolder> folders) {
    int count = 0;
    for (final f in folders) {
      count += f.endpoints.length;
      count += _countEndpoints(f.subfolders);
    }
    return count;
  }
}

class _FolderWidget extends StatefulWidget {
  final PostmanFolder folder;
  const _FolderWidget({required this.folder});

  @override
  State<_FolderWidget> createState() => _FolderWidgetState();
}

class _FolderWidgetState extends State<_FolderWidget> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Icon(
                    _expanded ? Icons.folder_open : Icons.folder,
                    color: AppColors.warning,
                    size: 18,
                  ),
                  const Gap(10),
                  Text(widget.folder.name, style: AppTextStyles.label),
                  const Gap(8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${widget.folder.endpoints.length}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textMuted,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1),
            ...widget.folder.endpoints.map((ep) => _EndpointRow(endpoint: ep)),
            ...widget.folder.subfolders
                .map((sf) => Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: _FolderWidget(folder: sf),
                    )),
          ],
        ],
      ),
    );
  }
}

class _EndpointRow extends StatelessWidget {
  final PostmanEndpoint endpoint;
  const _EndpointRow({required this.endpoint});

  Color get _methodColor {
    switch (endpoint.method) {
      case 'GET': return AppColors.methodGet;
      case 'POST': return AppColors.methodPost;
      case 'PUT': return AppColors.methodPut;
      case 'DELETE': return AppColors.methodDelete;
      case 'PATCH': return AppColors.methodPatch;
      default: return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 22,
            decoration: BoxDecoration(
              color: _methodColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: _methodColor.withOpacity(0.3)),
            ),
            child: Center(
              child: Text(
                endpoint.method,
                style: AppTextStyles.bodySmall.copyWith(
                  color: _methodColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Text(
              endpoint.name,
              style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (endpoint.detectedSchemas.isNotEmpty)
            ...endpoint.detectedSchemas.map((s) => Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      s,
                      style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.accent, fontSize: 9),
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
