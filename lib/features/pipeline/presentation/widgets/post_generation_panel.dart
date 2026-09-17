import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../app/theme/app_theme.dart';
import '../cubit/pipeline_state.dart';

class PostGenerationPanel extends StatefulWidget {
  final PipelineState state;

  const PostGenerationPanel({super.key, required this.state});

  @override
  State<PostGenerationPanel> createState() => _PostGenerationPanelState();
}

class _PostGenerationPanelState extends State<PostGenerationPanel> {
  final _chatController = TextEditingController();
  String _repoPlatform = 'GitHub';
  String _repoVisibility = 'Private';
  bool _ciRunTests = true;
  bool _ciFirebase = true;
  bool _ciStores = true;
  bool _ciSlack = false;
  String _ciPlatform = 'GitHub Actions';

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Next Steps', style: AppTextStyles.h2),
            const Gap(8),
            Text('Your Flutter app has been successfully generated. What would you like to do next?',
                style: AppTextStyles.body.copyWith(color: AppColors.textMuted)),
            const Gap(32),
            
            // Layout: Row with Push & CI/CD on left, AI Chat on right
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildPushPanel(),
                      const Gap(24),
                      _buildCiCdPanel(),
                    ],
                  ),
                ),
                const Gap(24),
                Expanded(
                  flex: 4,
                  child: _buildChatPanel(),
                ),
              ],
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
              const Icon(Icons.cloud_upload_outlined, color: AppColors.primary),
              const Gap(12),
              Text('Push to Repository', style: AppTextStyles.h3),
            ],
          ),
          const Gap(24),
          Row(
            children: [
              _buildChoiceChip('GitHub', _repoPlatform, (v) => setState(() => _repoPlatform = v)),
              const Gap(12),
              _buildChoiceChip('GitLab', _repoPlatform, (v) => setState(() => _repoPlatform = v)),
              const Gap(12),
              _buildChoiceChip('Bitbucket', _repoPlatform, (v) => setState(() => _repoPlatform = v)),
              const Gap(12),
              _buildChoiceChip('Download ZIP', _repoPlatform, (v) => setState(() => _repoPlatform = v)),
            ],
          ),
          const Gap(24),
          if (_repoPlatform != 'Download ZIP') ...[
            TextFormField(
              initialValue: 'flutter-forge-app',
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Repository Name',
                labelStyle: AppTextStyles.label.copyWith(color: AppColors.textMuted),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                filled: true,
                fillColor: AppColors.surfaceElevated,
              ),
            ),
            const Gap(16),
            Row(
              children: [
                _buildChoiceChip('Public', _repoVisibility, (v) => setState(() => _repoVisibility = v)),
                const Gap(12),
                _buildChoiceChip('Private', _repoVisibility, (v) => setState(() => _repoVisibility = v)),
              ],
            ),
            const Gap(24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('OAuth flow will open here...')),
                  );
                },
                icon: const Icon(Icons.link, size: 18),
                label: Text('Connect $_repoPlatform Account'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ] else ...[
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ]
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
              const Icon(Icons.rocket_launch_outlined, color: AppColors.success),
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
              labelStyle: AppTextStyles.label.copyWith(color: AppColors.textMuted),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              filled: true,
              fillColor: AppColors.surfaceElevated,
            ),
            items: ['GitHub Actions', 'GitLab CI', 'Bitbucket Pipelines'].map((p) {
              return DropdownMenuItem(value: p, child: Text(p));
            }).toList(),
            onChanged: (v) {
              if (v != null) setState(() => _ciPlatform = v);
            },
          ),
          const Gap(16),
          _buildCheckbox('Run tests on every PR', _ciRunTests, (v) => setState(() => _ciRunTests = v!)),
          _buildCheckbox('Build + upload to Firebase App Distribution (staging)', _ciFirebase, (v) => setState(() => _ciFirebase = v!)),
          _buildCheckbox('Submit to TestFlight / Play Store (production)', _ciStores, (v) => setState(() => _ciStores = v!)),
          _buildCheckbox('Notify Slack on deploy', _ciSlack, (v) => setState(() => _ciSlack = v!)),
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
                const Icon(Icons.info_outline, color: AppColors.textMuted, size: 16),
                const Gap(8),
                Expanded(
                  child: Text(
                    'Generates: .github/workflows/ci.yml and Fastfile',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Generate CI/CD Files'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatPanel() {
    return Container(
      height: 700,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                ),
                const Gap(12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FlutterForge Assistant', style: AppTextStyles.h3),
                    Text('Ask for changes to the generated code', 
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildChatBubble(
                  'Hi! Your app has been generated. Would you like me to make any adjustments to the code before you export it?',
                  isAi: true,
                ),
                const Gap(16),
                _buildChatBubble(
                  'Change auth to Google Sign-In only',
                  isAi: false,
                ),
                const Gap(16),
                _buildChatBubble(
                  'I\'ll update `login_screen.dart`, `auth_cubit.dart`, and add `google_sign_in` to your `pubspec.yaml`.',
                  isAi: true,
                ),
                const Gap(8),
                Container(
                  margin: const EdgeInsets.only(left: 48, right: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.code, size: 16, color: AppColors.textMuted),
                          const Gap(8),
                          Text('Diff preview available', style: AppTextStyles.label),
                        ],
                      ),
                      const Gap(12),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            child: const Text('Apply Changes'),
                          ),
                          const Gap(8),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
                            child: const Text('Discard'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Type a change request...',
                      hintStyle: AppTextStyles.body.copyWith(color: AppColors.textMuted),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                      filled: true,
                      fillColor: AppColors.surfaceElevated,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ),
                const Gap(12),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      _chatController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Chat processing...')),
                      );
                    },
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String text, {required bool isAi}) {
    return Row(
      mainAxisAlignment: isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isAi) ...[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, color: AppColors.primary, size: 16),
          ),
          const Gap(12),
        ],
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isAi ? AppColors.surfaceElevated : AppColors.primary,
              borderRadius: BorderRadius.circular(16).copyWith(
                topLeft: isAi ? const Radius.circular(4) : const Radius.circular(16),
                topRight: isAi ? const Radius.circular(16) : const Radius.circular(4),
              ),
              border: isAi ? Border.all(color: AppColors.border) : null,
            ),
            child: Text(
              text,
              style: AppTextStyles.body.copyWith(
                color: isAi ? AppColors.textPrimary : Colors.white,
              ),
            ),
          ),
        ),
        if (!isAi) const Gap(36), // padding to match avatar width on left
      ],
    );
  }

  Widget _buildChoiceChip(String label, String groupValue, ValueChanged<String> onSelected) {
    final isSelected = label == groupValue;
    return InkWell(
      onTap: () => onSelected(label),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(String title, bool value, ValueChanged<bool?> onChanged) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: AppColors.textMuted,
      ),
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
