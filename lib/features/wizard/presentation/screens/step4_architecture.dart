import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../app/theme/app_theme.dart';
import '../../models/project_config.dart';
import '../cubit/wizard_cubit.dart';
import '../cubit/wizard_state.dart';
import 'wizard_widgets.dart';

class Step4Architecture extends StatefulWidget {
  const Step4Architecture({super.key});

  @override
  State<Step4Architecture> createState() => _Step4ArchitectureState();
}

class _Step4ArchitectureState extends State<Step4Architecture> {
  int _selectedIndex = 0;

  final List<String> _tabs = [
    'Tech Stack',
    'Integrations',
    'Environment',
    'Localization',
    'Monetization',
    'Testing',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WizardCubit, WizardState>(
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Rail
            Container(
              width: 200,
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: AppColors.border)),
              ),
              child: ListView.builder(
                itemCount: _tabs.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedIndex == index;
                  return InkWell(
                    onTap: () => setState(() => _selectedIndex = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
                        border: Border(
                          right: BorderSide(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        _tabs[index],
                        style: AppTextStyles.label.copyWith(
                          color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: _buildContent(context, state.config),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, ProjectConfig config) {
    switch (_selectedIndex) {
      case 0:
        return _TechStackTab(config: config);
      case 1:
        return _IntegrationsTab(config: config);
      case 2:
        return _EnvironmentTab(config: config);
      case 3:
        return _LocalizationTab(config: config);
      case 4:
        return _MonetizationTab(config: config);
      case 5:
        return _TestingTab(config: config);
      default:
        return const SizedBox();
    }
  }
}

// ─── 0. Tech Stack ─────────────────────────────────────────────────────────

class _TechStackTab extends StatelessWidget {
  final ProjectConfig config;
  const _TechStackTab({required this.config});

  void _update(BuildContext context, {
    String? pattern,
    String? stateManagement,
    String? di,
    String? network,
    String? localStorage,
    String? navigation,
  }) {
    context.read<WizardCubit>().updateArchitectureField(
      pattern: pattern,
      stateManagement: stateManagement,
      di: di,
      network: network,
      localStorage: localStorage,
      navigation: navigation,
    );
  }

  @override
  Widget build(BuildContext context) {
    final arch = config.architecture ?? const ArchitectureConfig(
      pattern: 'clean_architecture',
      stateManagement: 'bloc',
      di: 'get_it',
      network: 'dio',
      localStorage: 'hive',
      navigation: 'go_router',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WizardSectionHeader(
          icon: Icons.architecture,
          title: 'Architecture & Stack',
          subtitle: 'Define the structural blueprint for your Flutter app.',
        ),
        const Gap(32),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            _OptionGroup(
              width: 380,
              title: 'Architecture Pattern',
              icon: Icons.account_tree_outlined,
              options: const [
                _OptionData('clean_architecture', 'Clean Architecture', 'Domain, Data, Presentation layers'),
                _OptionData('hexagonal', 'Hexagonal', 'Ports & Adapters'),
                _OptionData('mvvm', 'MVVM', 'Model-View-ViewModel'),
              ],
              selected: arch.pattern,
              onSelected: (v) => _update(context, pattern: v),
            ),
            _OptionGroup(
              width: 380,
              title: 'State Management',
              icon: Icons.swap_horiz,
              options: const [
                _OptionData('bloc', 'BLoC', 'Stream-based logic'),
                _OptionData('riverpod', 'Riverpod', 'Compile-safe reactive state'),
                _OptionData('provider', 'Provider', 'InheritedWidget wrapper'),
              ],
              selected: arch.stateManagement,
              onSelected: (v) => _update(context, stateManagement: v),
            ),
            _OptionGroup(
              width: 380,
              title: 'Dependency Injection',
              icon: Icons.settings_input_component_outlined,
              options: const [
                _OptionData('get_it', 'GetIt', 'Simple service locator'),
                _OptionData('injectable', 'Injectable', 'GetIt + code generation'),
                _OptionData('manual', 'Manual', 'Hand-wired constructors'),
              ],
              selected: arch.di,
              onSelected: (v) => _update(context, di: v),
            ),
            _OptionGroup(
              width: 380,
              title: 'Navigation',
              icon: Icons.route_outlined,
              options: const [
                _OptionData('go_router', 'GoRouter', 'Declarative, deep linking'),
                _OptionData('auto_route', 'AutoRoute', 'Code-gen based typed routing'),
              ],
              selected: arch.navigation,
              onSelected: (v) => _update(context, navigation: v),
            ),
            _OptionGroup(
              width: 380,
              title: 'Network',
              icon: Icons.cloud_outlined,
              options: const [
                _OptionData('dio', 'Dio', 'Powerful HTTP client'),
                _OptionData('http', 'http', 'Standard Dart HTTP'),
              ],
              selected: arch.network,
              onSelected: (v) => _update(context, network: v),
            ),
            _OptionGroup(
              width: 380,
              title: 'Local Storage',
              icon: Icons.storage_outlined,
              options: const [
                _OptionData('hive', 'Hive', 'Lightweight NoSQL'),
                _OptionData('isar', 'Isar', 'Multi-platform database'),
                _OptionData('shared_prefs', 'SharedPrefs', 'Simple key-value'),
              ],
              selected: arch.localStorage,
              onSelected: (v) => _update(context, localStorage: v),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── 1. Integrations ───────────────────────────────────────────────────────

class _IntegrationsTab extends StatelessWidget {
  final ProjectConfig config;
  const _IntegrationsTab({required this.config});

  @override
  Widget build(BuildContext context) {
    final intg = config.integrations;
    final cubit = context.read<WizardCubit>();

    Widget toggle(String label, bool val, ValueChanged<bool> onChanged) {
      return SwitchListTile(
        title: Text(label, style: AppTextStyles.body),
        value: val,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
        contentPadding: EdgeInsets.zero,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WizardSectionHeader(
          icon: Icons.extension,
          title: '3rd-Party Integrations',
          subtitle: 'Select services to pre-configure in your app.',
        ),
        const Gap(32),
        Text('Firebase', style: AppTextStyles.h4),
        const Gap(8),
        toggle('Firebase Auth', intg.firebaseAuth, (v) => cubit.updateIntegrations(intg.copyWith(firebaseAuth: v))),
        toggle('Cloud Firestore', intg.firebaseFirestore, (v) => cubit.updateIntegrations(intg.copyWith(firebaseFirestore: v))),
        toggle('Firebase Storage', intg.firebaseStorage, (v) => cubit.updateIntegrations(intg.copyWith(firebaseStorage: v))),
        toggle('Firebase Analytics', intg.firebaseAnalytics, (v) => cubit.updateIntegrations(intg.copyWith(firebaseAnalytics: v))),
        toggle('Crashlytics', intg.firebaseCrashlytics, (v) => cubit.updateIntegrations(intg.copyWith(firebaseCrashlytics: v))),
        const Gap(24),
        Text('Payments & Subscriptions', style: AppTextStyles.h4),
        const Gap(8),
        toggle('Stripe', intg.stripe, (v) => cubit.updateIntegrations(intg.copyWith(stripe: v))),
        toggle('RevenueCat', intg.revenueCat, (v) => cubit.updateIntegrations(intg.copyWith(revenueCat: v))),
        const Gap(24),
        Text('Maps', style: AppTextStyles.h4),
        const Gap(8),
        toggle('Google Maps', intg.googleMaps, (v) => cubit.updateIntegrations(intg.copyWith(googleMaps: v))),
        toggle('Mapbox', intg.mapbox, (v) => cubit.updateIntegrations(intg.copyWith(mapbox: v))),
      ],
    );
  }
}

// ─── 2. Environment ────────────────────────────────────────────────────────

class _EnvironmentTab extends StatelessWidget {
  final ProjectConfig config;
  const _EnvironmentTab({required this.config});

  @override
  Widget build(BuildContext context) {
    final env = config.environment;
    final cubit = context.read<WizardCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WizardSectionHeader(
          icon: Icons.layers,
          title: 'Environment Flavors',
          subtitle: 'Configure build flavors and base identifiers.',
        ),
        const Gap(32),
        CheckboxListTile(
          title: Text('Development Flavor', style: AppTextStyles.body),
          value: env.hasDev,
          onChanged: (v) => cubit.updateEnvironment(env.copyWith(hasDev: v ?? false)),
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          title: Text('Staging Flavor', style: AppTextStyles.body),
          value: env.hasStaging,
          onChanged: (v) => cubit.updateEnvironment(env.copyWith(hasStaging: v ?? false)),
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          title: Text('Production Flavor', style: AppTextStyles.body),
          value: env.hasProd,
          onChanged: (v) => cubit.updateEnvironment(env.copyWith(hasProd: v ?? false)),
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),

      ],
    );
  }
}

// ─── 3. Localization ───────────────────────────────────────────────────────

class _LocalizationTab extends StatelessWidget {
  final ProjectConfig config;
  const _LocalizationTab({required this.config});

  @override
  Widget build(BuildContext context) {
    final loc = config.localization;
    final cubit = context.read<WizardCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WizardSectionHeader(
          icon: Icons.language,
          title: 'Localization (l10n)',
          subtitle: 'Setup languages supported by your app.',
        ),
        const Gap(32),
        WizardFieldLabel('Default Language'),
        const Gap(8),
        TextFormField(
          initialValue: loc.defaultLanguage,
          onChanged: (v) => cubit.updateLocalization(loc.copyWith(defaultLanguage: v)),
          decoration: const InputDecoration(hintText: 'English'),
        ),
        const Gap(24),
        WizardFieldLabel('Additional Languages (comma separated)'),
        const Gap(8),
        TextFormField(
          initialValue: loc.targetLanguages.where((l) => l != loc.defaultLanguage).join(', '),
          onChanged: (v) {
            final langs = v.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
            cubit.updateLocalization(loc.copyWith(targetLanguages: [loc.defaultLanguage, ...langs]));
          },
          decoration: const InputDecoration(hintText: 'Spanish, French, German'),
        ),
      ],
    );
  }
}

// ─── 4. Monetization ───────────────────────────────────────────────────────

class _MonetizationTab extends StatelessWidget {
  final ProjectConfig config;
  const _MonetizationTab({required this.config});

  @override
  Widget build(BuildContext context) {
    final mon = config.monetization ?? const MonetizationConfig();
    final cubit = context.read<WizardCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WizardSectionHeader(
          icon: Icons.attach_money,
          title: 'Monetization Strategy',
          subtitle: 'How will your app make money?',
        ),
        const Gap(32),
        WizardFieldLabel('Business Model'),
        const Gap(8),
        DropdownButtonFormField<MonetizationModel>(
          initialValue: mon.model,
          dropdownColor: AppColors.surfaceElevated,
          items: MonetizationModel.values.map((m) {
            return DropdownMenuItem(
              value: m,
              child: Text(m.name.toUpperCase()),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) cubit.updateMonetization(mon.copyWith(model: v));
          },
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        if (mon.model == MonetizationModel.freemium || mon.model == MonetizationModel.oneTimePurchase) ...[
          const Gap(24),
          WizardFieldLabel('Subscription/IAP Provider'),
          const Gap(8),
          DropdownButtonFormField<SubscriptionProvider>(
            initialValue: mon.provider ?? SubscriptionProvider.revenueCat,
            dropdownColor: AppColors.surfaceElevated,
            items: SubscriptionProvider.values.map((p) {
              return DropdownMenuItem(
                value: p,
                child: Text(p.name.toUpperCase()),
              );
            }).toList(),
            onChanged: (v) {
              if (v != null) cubit.updateMonetization(mon.copyWith(provider: v));
            },
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ],
      ],
    );
  }
}

// ─── 5. Testing ────────────────────────────────────────────────────────────

class _TestingTab extends StatelessWidget {
  final ProjectConfig config;
  const _TestingTab({required this.config});

  @override
  Widget build(BuildContext context) {
    final test = config.testing;
    final cubit = context.read<WizardCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WizardSectionHeader(
          icon: Icons.bug_report,
          title: 'Testing & QA',
          subtitle: 'Setup automated testing generation.',
        ),
        const Gap(32),
        CheckboxListTile(
          title: Text('Generate Unit Tests', style: AppTextStyles.body),
          value: test.generateUnitTests,
          onChanged: (v) => cubit.updateTesting(test.copyWith(generateUnitTests: v ?? false)),
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          title: Text('Generate Widget Tests', style: AppTextStyles.body),
          value: test.generateWidgetTests,
          onChanged: (v) => cubit.updateTesting(test.copyWith(generateWidgetTests: v ?? false)),
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          title: Text('Generate Integration Tests', style: AppTextStyles.body),
          value: test.generateIntegrationTests,
          onChanged: (v) => cubit.updateTesting(test.copyWith(generateIntegrationTests: v ?? false)),
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }
}


// ─── Shared Components ─────────────────────────────────────────────────────

class _OptionData {
  final String value;
  final String label;
  final String description;
  const _OptionData(this.value, this.label, this.description);
}

class _OptionGroup extends StatelessWidget {
  final double width;
  final String title;
  final IconData icon;
  final List<_OptionData> options;
  final String selected;
  final ValueChanged<String> onSelected;

  const _OptionGroup({
    required this.width,
    required this.title,
    required this.icon,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 18),
                const Gap(8),
                Text(title, style: AppTextStyles.h4),
              ],
            ),
            const Gap(14),
            ...options.map((opt) => _OptionTile(
                  option: opt,
                  isSelected: selected == opt.value,
                  onTap: () => onSelected(opt.value),
                )),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final _OptionData option;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.12) : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: 1.5,
                  ),
                  color: isSelected ? AppColors.primary : Colors.transparent,
                ),
                child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 12) : null,
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.label,
                      style: AppTextStyles.label.copyWith(
                        color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      option.description,
                      style: AppTextStyles.bodySmall,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
