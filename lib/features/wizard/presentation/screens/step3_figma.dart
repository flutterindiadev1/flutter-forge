import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../app/theme/app_theme.dart';
import '../cubit/wizard_cubit.dart';
import '../cubit/wizard_state.dart';
import 'wizard_widgets.dart';


class Step3Figma extends StatefulWidget {
  const Step3Figma({super.key});

  @override
  State<Step3Figma> createState() => _Step3FigmaState();
}

class _Step3FigmaState extends State<Step3Figma> {
  late TextEditingController _urlController;
  late TextEditingController _tokenController;
  bool _obscureToken = true;
  bool _isValidating = false;
  String? _validatedFileName;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    final config = context.read<WizardCubit>().state.config;
    _urlController = TextEditingController(text: config.figmaFileUrl ?? '');
    _tokenController =
        TextEditingController(text: config.figmaAccessToken ?? '');
  }

  @override
  void dispose() {
    _urlController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  void _update() {
    context.read<WizardCubit>().updateFigma(
          figmaFileUrl: _urlController.text,
          figmaAccessToken: _tokenController.text,
        );
  }

  Future<void> _validate() async {
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
                title: 'Figma Design Link',
                subtitle:
                    'Connect your Figma file to auto-generate screen skeletons and widget mappings.',
              ),
              const Gap(32),
              WizardFieldLabel('Figma File URL'),

              const Gap(8),
              TextFormField(
                controller: _urlController,
                style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText:
                      'https://www.figma.com/file/XYZ.../My-Design-File',
                  prefixIcon: const Icon(Icons.link, color: AppColors.textMuted),
                  suffixIcon: _validatedFileName != null
                      ? const Icon(Icons.check_circle,
                          color: AppColors.success, size: 20)
                      : null,
                ),
                onChanged: (_) {
                  _update();
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
                style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary, fontFamily: 'monospace'),
                decoration: InputDecoration(
                  hintText: 'figd_XXXXXXXX...',
                  prefixIcon: const Icon(Icons.vpn_key_outlined,
                      color: AppColors.textMuted),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureToken
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureToken = !_obscureToken),
                  ),
                ),
                onChanged: (_) => _update(),
              ),
              const Gap(8),
              Text(
                'Required to access private files. Generate at figma.com → Account Settings → Personal Access Tokens.',
                style: AppTextStyles.bodySmall,
              ),
              const Gap(24),
              // Validate button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed:
                      _urlController.text.isNotEmpty && !_isValidating
                          ? _validate
                          : null,
                  icon: _isValidating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              color: AppColors.primary, strokeWidth: 2),
                        )
                      : const Icon(Icons.verified_outlined, size: 18),
                  label: Text(_isValidating
                      ? 'Validating...'
                      : 'Validate Figma File'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              if (_validatedFileName != null) ...[
                const Gap(16),
                _buildSuccessBanner(_validatedFileName!),
              ],
              if (_validationError != null) ...[
                const Gap(16),
                _buildErrorBanner(_validationError!),
              ],
              const Gap(32),
              _buildHowToSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessBanner(String name) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline,
              color: AppColors.success, size: 20),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('File Found', style: AppTextStyles.label.copyWith(
                    color: AppColors.success)),
                const Gap(2),
                Text(name, style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const Gap(12),
          Expanded(
            child: Text(error,
                style: AppTextStyles.body.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildHowToSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What FlutterForge does with your Figma file:',
              style: AppTextStyles.h4),
          const Gap(14),
          ...[
            ('Auto-generate Screen Widgets', 'Creates empty scaffold widgets for each Figma frame'),
            ('Extract Color Tokens', 'Maps Figma color styles to a Dart ThemeData'),
            ('Detect Component Patterns', 'Identifies repeated components and generates reusable widgets'),
            ('Map Navigation Flow', 'Reads prototype connections to generate GoRouter routes'),
          ].map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.chevron_right,
                        color: AppColors.primary, size: 18),
                    const Gap(8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.$1,
                              style: AppTextStyles.label.copyWith(
                                  color: AppColors.textPrimary)),
                          Text(item.$2, style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
