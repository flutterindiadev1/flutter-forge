import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../app/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import '../cubit/pipeline_state.dart';

class PostGenerationPanel extends StatefulWidget {
  final PipelineState state;

  const PostGenerationPanel({super.key, required this.state});

  @override
  State<PostGenerationPanel> createState() => _PostGenerationPanelState();
}

class _PostGenerationPanelState extends State<PostGenerationPanel> {
  bool _ciRunTests = true;
  bool _ciFirebase = true;
  bool _ciStores = true;
  bool _ciSlack = false;
  String _ciPlatform = 'GitHub Actions';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Next Steps', style: AppTextStyles.h2),
                      const Gap(8),
                      Text(
                        'Your Flutter app has been successfully generated. What would you like to do next?',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.state.projectId != null)
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.go('/workspace/${widget.state.projectId}'),
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Open Workspace'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
              ],
            ),
            const Gap(32),

            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    _buildPushPanel(),
                    const Gap(24),
                    _buildCiCdPanel(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPushPanel() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.download, color: AppColors.primary),
              const Gap(12),
              Text('Download Project', style: AppTextStyles.h3),
            ],
          ),
          const Gap(16),
          Text(
            'Your Flutter project has been generated successfully. You can now download the complete source code.',
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const Gap(24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Downloading ZIP...')),
                );
              },
              icon: const Icon(Icons.download, size: 18),
              label: const Text('Download Source Code'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCiCdPanel() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.rocket_launch_outlined,
                color: AppColors.success,
              ),
              const Gap(12),
              Text('CI/CD Configuration', style: AppTextStyles.h3),
            ],
          ),
          const Gap(24),
          DropdownButtonFormField<String>(
            initialValue: _ciPlatform,
            dropdownColor: AppColors.surfaceElevated,
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              labelText: 'Platform',
              labelStyle: AppTextStyles.label.copyWith(
                color: AppColors.textMuted,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              filled: true,
              fillColor: AppColors.surfaceElevated,
            ),
            items: ['GitHub Actions', 'GitLab CI', 'Bitbucket Pipelines'].map((
              p,
            ) {
              return DropdownMenuItem(value: p, child: Text(p));
            }).toList(),
            onChanged: (v) {
              if (v != null) setState(() => _ciPlatform = v);
            },
          ),
          const Gap(16),
          _buildCheckbox(
            'Run tests on every PR',
            _ciRunTests,
            (v) => setState(() => _ciRunTests = v!),
          ),
          _buildCheckbox(
            'Build + upload to Firebase App Distribution (staging)',
            _ciFirebase,
            (v) => setState(() => _ciFirebase = v!),
          ),
          _buildCheckbox(
            'Submit to TestFlight / Play Store (production)',
            _ciStores,
            (v) => setState(() => _ciStores = v!),
          ),
          _buildCheckbox(
            'Notify Slack on deploy',
            _ciSlack,
            (v) => setState(() => _ciSlack = v!),
          ),
          const Gap(24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.textMuted,
                  size: 16,
                ),
                const Gap(8),
                Expanded(
                  child: Text(
                    'Generates: .github/workflows/ci.yml and Fastfile',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Generating CI/CD files...')),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Generate CI/CD Files'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Theme(
      data: Theme.of(
        context,
      ).copyWith(unselectedWidgetColor: AppColors.textMuted),
      child: CheckboxListTile(
        title: Text(title, style: AppTextStyles.body),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        checkColor: Colors.white,
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}
