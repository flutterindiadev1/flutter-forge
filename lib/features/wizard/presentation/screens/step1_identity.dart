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
  late TextEditingController _teamController;
  Set<String> _selectedPlatforms = {};

  static const _platforms = ['iOS', 'Android', 'Web', 'macOS', 'Windows', 'Linux'];

  @override
  void initState() {
    super.initState();
    final config = context.read<WizardCubit>().state.config;
    _nameController = TextEditingController(text: config.projectName);
    _descController = TextEditingController(text: config.description);
    _teamController = TextEditingController(text: config.team);
    _selectedPlatforms = config.platforms.toSet();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _teamController.dispose();
    super.dispose();
  }

  void _update() {
    context.read<WizardCubit>().updateIdentity(
          projectName: _nameController.text,
          description: _descController.text,
          team: _teamController.text,
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
              // Team
              _FieldLabel('Team / Organization'),
              const Gap(8),
              TextFormField(
                controller: _teamController,
                style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'e.g. Acme Corp',
                  prefixIcon: Icon(Icons.group_outlined,
                      color: AppColors.textMuted),
                ),
                onChanged: (_) => _update(),
              ),
              const Gap(32),
              // Platforms
              _FieldLabel('Target Platforms'),
              const Gap(12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _platforms.map((p) {
                  final selected = _selectedPlatforms.contains(p);
                  return _PlatformChip(
                    label: p,
                    selected: selected,
                    onTap: () {
                      setState(() {
                        if (selected) {
                          _selectedPlatforms.remove(p);
                        } else {
                          _selectedPlatforms.add(p);
                        }
                      });
                      _update();
                    },
                  );
                }).toList(),
              ),
              const Gap(40),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlatformChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PlatformChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  IconData get _icon {
    switch (label) {
      case 'iOS': return Icons.phone_iphone;
      case 'Android': return Icons.android;
      case 'Web': return Icons.language;
      case 'macOS': return Icons.laptop_mac;
      case 'Windows': return Icons.desktop_windows;
      case 'Linux': return Icons.computer;
      default: return Icons.devices;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.15)
              : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon,
                size: 16,
                color: selected ? AppColors.primary : AppColors.textMuted),
            const Gap(8),
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: selected ? AppColors.primary : AppColors.textSecondary,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
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
            color: AppColors.primary.withOpacity(0.12),
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
