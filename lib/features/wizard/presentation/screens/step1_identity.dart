import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/project_config.dart';
import '../cubit/wizard_cubit.dart';
import '../cubit/wizard_state.dart';
import '../../../../shared/widgets/app_button.dart';

class Step1Identity extends StatefulWidget {
  const Step1Identity({super.key});

  @override
  State<Step1Identity> createState() => _Step1IdentityState();
}

class _Step1IdentityState extends State<Step1Identity> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _teamController;
  late TextEditingController _inspiredByController;
  late TextEditingController _personaRoleController;
  late TextEditingController _personaGoalController;
  late TextEditingController _personaPainPointsController;
  late TextEditingController _apiKeyController;
  late TextEditingController _githubTokenController;

  Set<String> _selectedPlatforms = {};

  static const _platforms = ['iOS', 'Android', 'Web', 'macOS', 'Windows', 'Linux'];

  @override
  void initState() {
    super.initState();
    final state = context.read<WizardCubit>().state;
    final config = state.config;
    _nameController = TextEditingController(text: config.projectName);
    _descController = TextEditingController(text: config.description);
    _teamController = TextEditingController(text: config.team);
    _inspiredByController = TextEditingController(text: config.inspiredBy);
    _personaRoleController = TextEditingController(text: config.persona?.role ?? '');
    _personaGoalController = TextEditingController(text: config.persona?.goal ?? '');
    _personaPainPointsController = TextEditingController(text: config.persona?.painPoints ?? '');
    _apiKeyController = TextEditingController(text: config.geminiApiKey);
    _githubTokenController = TextEditingController(text: config.githubToken ?? '');
    _selectedPlatforms = config.platforms.toSet();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _teamController.dispose();
    _inspiredByController.dispose();
    _personaRoleController.dispose();
    _personaGoalController.dispose();
    _personaPainPointsController.dispose();
    _apiKeyController.dispose();
    _githubTokenController.dispose();
    super.dispose();
  }

  void _update() {
    final persona = (_personaRoleController.text.isNotEmpty || 
                     _personaGoalController.text.isNotEmpty || 
                     _personaPainPointsController.text.isNotEmpty)
        ? UserPersona(
            role: _personaRoleController.text,
            goal: _personaGoalController.text,
            painPoints: _personaPainPointsController.text,
          )
        : null;

    context.read<WizardCubit>().updateIdentity(
          projectName: _nameController.text,
          description: _descController.text,
          team: _teamController.text,
          platforms: _selectedPlatforms.toList(),
          inspiredBy: _inspiredByController.text.isNotEmpty ? _inspiredByController.text : null,
          persona: persona,
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
                  // Team & Inspired By
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                          ],
                        ),
                      ),
                      const Gap(24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel('Inspired By (Reference Apps)'),
                            const Gap(8),
                            TextFormField(
                              controller: _inspiredByController,
                              style: AppTextStyles.body.copyWith(
                                  color: AppColors.textPrimary),
                              decoration: const InputDecoration(
                                hintText: 'e.g. Uber, Airbnb',
                                prefixIcon: Icon(Icons.lightbulb_outline,
                                    color: AppColors.textMuted),
                              ),
                              onChanged: (_) => _update(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(32),

                  // User Persona Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person_pin_outlined, color: AppColors.accent),
                            const Gap(12),
                            Text('Primary User Persona', style: AppTextStyles.h4),
                          ],
                        ),
                        const Gap(8),
                        Text('Help AI understand who will use this app.', style: AppTextStyles.bodySmall),
                        const Gap(24),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _FieldLabel('Role / Title'),
                                  const Gap(8),
                                  TextFormField(
                                    controller: _personaRoleController,
                                    decoration: const InputDecoration(hintText: 'e.g. Freelance Designer'),
                                    onChanged: (_) => _update(),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _FieldLabel('Main Goal'),
                                  const Gap(8),
                                  TextFormField(
                                    controller: _personaGoalController,
                                    decoration: const InputDecoration(hintText: 'e.g. Find new clients quickly'),
                                    onChanged: (_) => _update(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Gap(16),
                        _FieldLabel('Pain Points'),
                        const Gap(8),
                        TextFormField(
                          controller: _personaPainPointsController,
                          maxLines: 2,
                          decoration: const InputDecoration(hintText: 'e.g. Too much time spent on administrative tasks'),
                          onChanged: (_) => _update(),
                        ),
                      ],
                    ),
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

                  // API Key Section
                  const Divider(color: AppColors.border),
                  const Gap(32),
                  _SectionHeader(
                    icon: Icons.key_outlined,
                    title: 'Gemini API Key',
                    subtitle: 'Required to generate features, architectures, and boilerplate code.',
                  ),
                  const Gap(24),
                  if (state.apiKeySaved)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('API Key Saved', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: Colors.green)),
                                const Gap(4),
                                Text('Your API key is securely saved and active.', style: AppTextStyles.bodySmall.copyWith(color: Colors.green)),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<WizardCubit>().saveApiKey('');
                            },
                            child: const Text('Remove Key', style: TextStyle(color: AppColors.error)),
                          ),
                        ],
                      ),
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FieldLabel('API Key'),
                              const Gap(8),
                              TextFormField(
                                controller: _apiKeyController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: 'AIzaSy...',
                                  prefixIcon: Icon(Icons.password, color: AppColors.textMuted),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(16),
                        AppButton(
                          label: 'Save Key',
                          icon: Icons.save_outlined,
                          onPressed: () {
                            if (_apiKeyController.text.isNotEmpty) {
                              context.read<WizardCubit>().saveApiKey(_apiKeyController.text);
                            }
                          },
                        ),
                      ],
                    ),
                  const Gap(40),

                  // GitHub Token Section
                  const Divider(color: AppColors.border),
                  const Gap(32),
                  _SectionHeader(
                    icon: Icons.code_outlined,
                    title: 'GitHub Personal Access Token (Optional)',
                    subtitle: 'Required if you want the backend to automatically push the generated project to GitHub.',
                  ),
                  const Gap(24),
                  if (state.githubTokenSaved)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('GitHub Token Saved', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: Colors.green)),
                                const Gap(4),
                                Text('Your token is securely saved.', style: AppTextStyles.bodySmall.copyWith(color: Colors.green)),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<WizardCubit>().saveGithubToken('');
                            },
                            child: const Text('Remove Token', style: TextStyle(color: AppColors.error)),
                          ),
                        ],
                      ),
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FieldLabel('GitHub PAT (Classic/Fine-grained)'),
                              const Gap(8),
                              TextFormField(
                                controller: _githubTokenController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: 'ghp_...',
                                  prefixIcon: Icon(Icons.lock, color: AppColors.textMuted),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(16),
                        AppButton(
                          label: 'Save Token',
                          icon: Icons.save_outlined,
                          onPressed: () {
                            if (_githubTokenController.text.isNotEmpty) {
                              context.read<WizardCubit>().saveGithubToken(_githubTokenController.text);
                            }
                          },
                        ),
                      ],
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
              ? AppColors.primary.withValues(alpha: 0.15)
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
