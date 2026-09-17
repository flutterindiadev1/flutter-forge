import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/project_config.dart';
import '../cubit/wizard_cubit.dart';
import '../cubit/wizard_state.dart';
import 'wizard_widgets.dart';
import '../../../../shared/widgets/app_button.dart';

class Step3Design extends StatefulWidget {
  const Step3Design({super.key});

  @override
  State<Step3Design> createState() => _Step3DesignState();
}

class _Step3DesignState extends State<Step3Design> {
  late TextEditingController _urlController;
  late TextEditingController _tokenController;
  late TextEditingController _briefPromptController;
  late TextEditingController _briefStyleController;

  bool _obscureToken = true;
  bool _isValidating = false;
  String? _validatedFileName;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    final config = context.read<WizardCubit>().state.config;
    _urlController = TextEditingController(text: config.figmaFileUrl ?? '');
    _tokenController = TextEditingController(text: config.figmaAccessToken ?? '');
    _briefPromptController = TextEditingController();
    _briefStyleController = TextEditingController();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _tokenController.dispose();
    _briefPromptController.dispose();
    _briefStyleController.dispose();
    super.dispose();
  }

  void _updateFigma() {
    context.read<WizardCubit>().updateFigma(
          figmaFileUrl: _urlController.text,
          figmaAccessToken: _tokenController.text,
        );
  }

  void _updateBrief() {
    context.read<WizardCubit>().updateAiDesignBrief(AiDesignBrief(
      prompt: _briefPromptController.text,
      stylePreference: _briefStyleController.text,
    ));
  }

  Future<void> _validateFigma() async {
    setState(() {
      _isValidating = true;
      _validationError = null;
      _validatedFileName = null;
    });
    // Mock validation — in production, call Figma REST API
    await Future.delayed(const Duration(milliseconds: 1200));
    final url = _urlController.text;
    if (url.contains('figma.com/file') || url.contains('figma.com/design')) {
      setState(() {
        _isValidating = false;
        _validatedFileName = 'Project Screens v2 — Main File';
      });
    } else {
      setState(() {
        _isValidating = false;
        _validationError = 'URL does not appear to be a valid Figma file link.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WizardCubit, WizardState>(
      builder: (context, state) {
        final config = state.config;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WizardSectionHeader(
                    icon: Icons.palette_outlined,
                    title: 'Design & Assets',
                    subtitle: 'Choose how your app\'s UI should be created and upload necessary assets.',
                  ),
                  const Gap(32),

                  // 3-Mode Selector
                  WizardFieldLabel('Design Source'),
                  const Gap(12),
                  Row(
                    children: [
                      Expanded(
                        child: _DesignSourceCard(
                          title: 'Figma',
                          icon: Icons.draw_outlined,
                          selected: config.designSource == DesignSource.figma,
                          onTap: () => context.read<WizardCubit>().updateDesignSource(DesignSource.figma),
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: _DesignSourceCard(
                          title: 'AI Generated',
                          icon: Icons.auto_awesome,
                          selected: config.designSource == DesignSource.aiGenerated,
                          onTap: () => context.read<WizardCubit>().updateDesignSource(DesignSource.aiGenerated),
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: _DesignSourceCard(
                          title: 'Code Only',
                          icon: Icons.code,
                          selected: config.designSource == DesignSource.skipped,
                          onTap: () => context.read<WizardCubit>().updateDesignSource(DesignSource.skipped),
                        ),
                      ),
                    ],
                  ),
                  const Gap(32),

                  // Content based on selection
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildSourceContent(config.designSource),
                  ),

                  const Gap(40),
                  const Divider(color: AppColors.border),
                  const Gap(32),

                  // Assets Panel
                  WizardSectionHeader(
                    icon: Icons.photo_library_outlined,
                    title: 'Project Assets',
                    subtitle: 'Upload logos, custom fonts, or other static assets.',
                  ),
                  const Gap(24),
                  
                  // App Icon
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border, strokeAlign: BorderSide.strokeAlignOutside),
                            image: config.appIcon != null
                                ? DecorationImage(image: NetworkImage(config.appIcon!.url), fit: BoxFit.cover)
                                : null,
                          ),
                          child: config.appIcon == null ? const Icon(Icons.apps, color: AppColors.textMuted) : null,
                        ),
                        const Gap(24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('App Icon', style: AppTextStyles.h4),
                              const Gap(4),
                              Text('Upload a 1024x1024 PNG for best results.', style: AppTextStyles.bodySmall),
                            ],
                          ),
                        ),
                        AppButton(
                          label: config.appIcon != null ? 'Change Icon' : 'Upload Icon',
                          isSecondary: true,
                          onPressed: () => context.read<WizardCubit>().uploadAppIcon(null), // Simulate upload
                        ),
                      ],
                    ),
                  ),
                  const Gap(24),

                  // Other Assets
                  WizardFieldLabel('Additional Assets'),
                  const Gap(12),
                  if (config.assets.isNotEmpty) ...[
                    ...config.assets.map((asset) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.insert_drive_file_outlined, color: AppColors.accent),
                          const Gap(12),
                          Expanded(
                            child: Text(asset.name, style: AppTextStyles.body),
                          ),
                          Text('${(asset.sizeBytes / 1024).round()} KB', style: AppTextStyles.bodySmall),
                          const Gap(12),
                          IconButton(
                            icon: const Icon(Icons.close, size: 18, color: AppColors.error),
                            onPressed: () => context.read<WizardCubit>().removeAsset(asset.id),
                          ),
                        ],
                      ),
                    )),
                    const Gap(12),
                  ],
                  AppButton(
                    label: 'Add Asset',
                    icon: Icons.upload_file,
                    isSecondary: true,
                    onPressed: () => context.read<WizardCubit>().uploadAsset(null), // Simulate upload
                  ),
                  const Gap(40),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildSourceContent(DesignSource source) {
    switch (source) {
      case DesignSource.figma:
        return KeyedSubtree(
          key: const ValueKey('figma'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WizardFieldLabel('Figma File URL'),
              const Gap(8),
              TextFormField(
                controller: _urlController,
                style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'https://www.figma.com/file/XYZ.../My-Design-File',
                  prefixIcon: const Icon(Icons.link, color: AppColors.textMuted),
                  suffixIcon: _validatedFileName != null
                      ? const Icon(Icons.check_circle, color: AppColors.success, size: 20)
                      : null,
                ),
                onChanged: (_) {
                  _updateFigma();
                  setState(() {
                    _validatedFileName = null;
                    _validationError = null;
                  });
                },
              ),
              const Gap(20),
              WizardFieldLabel('Personal Access Token'),
              const Gap(8),
              TextFormField(
                controller: _tokenController,
                obscureText: _obscureToken,
                style: AppTextStyles.body.copyWith(color: AppColors.textPrimary, fontFamily: 'monospace'),
                decoration: InputDecoration(
                  hintText: 'figd_XXXXXXXX...',
                  prefixIcon: const Icon(Icons.vpn_key_outlined, color: AppColors.textMuted),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureToken ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscureToken = !_obscureToken),
                  ),
                ),
                onChanged: (_) => _updateFigma(),
              ),
              const Gap(24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _urlController.text.isNotEmpty && !_isValidating ? _validateFigma : null,
                  icon: _isValidating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                        )
                      : const Icon(Icons.verified_outlined, size: 18),
                  label: Text(_isValidating ? 'Validating...' : 'Validate Figma File'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              if (_validatedFileName != null) ...[
                const Gap(16),
                _buildBanner(Icons.check_circle_outline, AppColors.success, 'File Found', _validatedFileName!),
              ],
              if (_validationError != null) ...[
                const Gap(16),
                _buildBanner(Icons.error_outline, AppColors.error, 'Error', _validationError!),
              ],
            ],
          ),
        );
      case DesignSource.aiGenerated:
        return KeyedSubtree(
          key: const ValueKey('ai_generated'),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: AppColors.primary),
                    const Gap(12),
                    Text('AI Design Generation', style: AppTextStyles.h4),
                  ],
                ),
                const Gap(8),
                Text('Describe the look and feel you want, and our AI will generate the Flutter UI code.', style: AppTextStyles.bodySmall),
                const Gap(24),
                WizardFieldLabel('Design Brief / Prompt'),
                const Gap(8),
                TextFormField(
                  controller: _briefPromptController,
                  maxLines: 3,
                  decoration: const InputDecoration(hintText: 'e.g. Modern, clean, lots of whitespace. Rounded corners and soft shadows.'),
                  onChanged: (_) => _updateBrief(),
                ),
                const Gap(16),
                WizardFieldLabel('Style Preferences (Colors, Typography)'),
                const Gap(8),
                TextFormField(
                  controller: _briefStyleController,
                  decoration: const InputDecoration(hintText: 'e.g. Primary color #FF5500, secondary #000000, Inter font.'),
                  onChanged: (_) => _updateBrief(),
                ),
              ],
            ),
          ),
        );
      case DesignSource.skipped:
        return KeyedSubtree(
          key: const ValueKey('code_only'),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.code, color: AppColors.textMuted, size: 32),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Standard Material/Cupertino', style: AppTextStyles.h4),
                      const Gap(4),
                      Text('No custom UI generation. Features will be scaffolded using default Flutter components.', style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildBanner(IconData icon, Color color, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.label.copyWith(color: color)),
                const Gap(2),
                Text(subtitle, style: AppTextStyles.body.copyWith(color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DesignSourceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _DesignSourceCard({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: selected ? AppColors.primary : AppColors.textMuted),
            const Gap(12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.label.copyWith(
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
