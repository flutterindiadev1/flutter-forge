import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../app/theme/app_theme.dart';
import '../cubit/wizard_cubit.dart';
import '../cubit/wizard_state.dart';

class Step1Identity extends StatefulWidget {
  const Step1Identity({super.key});

  @override
  State<Step1Identity> createState() => _Step1IdentityState();
}

class _Step1IdentityState extends State<Step1Identity> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _packageController;

  Set<String> _selectedPlatforms = {};

  static const _platforms = ['iOS', 'Android', 'Web', 'macOS', 'Windows', 'Linux'];

  @override
  void initState() {
    super.initState();
    final state = context.read<WizardCubit>().state;
    final config = state.config;
    _nameController = TextEditingController(text: config.projectName);
    _descController = TextEditingController(text: config.description);
    _packageController = TextEditingController(text: config.team.isNotEmpty ? config.team : config.environment.bundleIdBase);
    _selectedPlatforms = config.platforms.toSet();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _packageController.dispose();
    super.dispose();
  }

  void _update() {
    context.read<WizardCubit>().updateIdentity(
          projectName: _nameController.text,
          description: _descController.text,
          team: _packageController.text,
          platforms: _selectedPlatforms.toList(),
        );
  }

  String get _slug {
    return _nameController.text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WizardCubit, WizardState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    icon: Icons.folder_special_outlined,
                    title: 'Project Identity',
                    subtitle: 'Give your project a name, purpose, and target platforms.',
                  ),
                  const Gap(32),
                  // Project Name
                  _FieldLabel('Project Name *'),
                  const Gap(8),
                  TextFormField(
                    controller: _nameController,
                    style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'e.g. MyApp, EcommerceApp',
                      prefixIcon: Icon(Icons.label_outline,
                          color: AppColors.textMuted),
                    ),
                    onChanged: (_) {
                      _update();
                      setState(() {}); // rebuild slug
                    },
                  ),
                  if (_nameController.text.isNotEmpty) ...[
                    const Gap(8),
                    Row(
                      children: [
                        const Icon(Icons.code, size: 14, color: AppColors.textMuted),
                        const Gap(6),
                        Text('Package slug: ', style: AppTextStyles.bodySmall),
                        Text(_slug,
                            style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.accent,
                                fontFamily: 'monospace')),
                      ],
                    ),
                  ],
                  const Gap(24),
                  // Description
                  _FieldLabel('Description'),
                  const Gap(8),
                  TextFormField(
                    controller: _descController,
                    maxLines: 3,
                    style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'What does this app do?',
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: 40),
                        child: Icon(Icons.description_outlined,
                            color: AppColors.textMuted),
                      ),
                    ),
                    onChanged: (_) => _update(),
                  ),
                  const Gap(24),
                  // Package Name
                  _FieldLabel('Package Name (e.g. com.acmecorp.myapp)'),
                  const Gap(8),
                  TextFormField(
                    controller: _packageController,
                    style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'com.acmecorp.myapp',
                      prefixIcon: Icon(Icons.fingerprint_outlined,
                          color: AppColors.textMuted),
                    ),
                    onChanged: (_) => _update(),
                  ),
                  const Gap(32),

                  // Platforms
                  _FieldLabel('Target Platforms'),
                  const Gap(8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _platforms.map((platform) {
                      final isSelected = _selectedPlatforms.contains(platform);
                      return FilterChip(
                        label: Text(platform),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedPlatforms.add(platform);
                            } else {
                              _selectedPlatforms.remove(platform);
                            }
                          });
                          _update();
                        },
                        selectedColor: AppColors.primary.withValues(alpha: 0.2),
                        checkmarkColor: AppColors.primary,
                        labelStyle: AppTextStyles.body.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const Gap(16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.h2),
            const Gap(4),
            Text(subtitle, style: AppTextStyles.body),
          ],
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
    );
  }
}
