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
  late ArchitectureConfig _config;

  @override
  void initState() {
    super.initState();
    _config = context.read<WizardCubit>().state.config.architecture ??
        const ArchitectureConfig(
          pattern: 'clean_architecture',
          stateManagement: 'bloc',
          di: 'get_it',
          network: 'dio',
          localStorage: 'hive',
          navigation: 'go_router',
        );
  }

  void _updateField({
    String? pattern,
    String? stateManagement,
    String? di,
    String? network,
    String? localStorage,
    String? navigation,
  }) {
    setState(() {
      _config = ArchitectureConfig(
        pattern: pattern ?? _config.pattern,
        stateManagement: stateManagement ?? _config.stateManagement,
        di: di ?? _config.di,
        network: network ?? _config.network,
        localStorage: localStorage ?? _config.localStorage,
        navigation: navigation ?? _config.navigation,
      );
    });
    context.read<WizardCubit>().updateArchitecture(_config.copyWith(
          pattern: pattern,
          stateManagement: stateManagement,
          di: di,
          network: network,
          localStorage: localStorage,
          navigation: navigation,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WizardSectionHeader(
                icon: Icons.architecture,
                title: 'Architecture & Stack',
                subtitle:
                    'Define the structural blueprint. These choices shape every generated file.',
              ),
              const Gap(36),
              _buildGrid(),
              const Gap(32),
              _buildStackSummary(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return LayoutBuilder(builder: (context, constraints) {
      final cols = constraints.maxWidth > 600 ? 2 : 1;
      return Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          _OptionGroup(
            width: (constraints.maxWidth - (cols - 1) * 20) / cols,
            title: 'Architecture Pattern',
            icon: Icons.account_tree_outlined,
            options: _architectureOptions,
            selected: _config.pattern,
            onSelected: (v) => _updateField(pattern: v),
          ),
          _OptionGroup(
            width: (constraints.maxWidth - (cols - 1) * 20) / cols,
            title: 'State Management',
            icon: Icons.swap_horiz,
            options: _stateOptions,
            selected: _config.stateManagement,
            onSelected: (v) => _updateField(stateManagement: v),
          ),
          _OptionGroup(
            width: (constraints.maxWidth - (cols - 1) * 20) / cols,
            title: 'Dependency Injection',
            icon: Icons.settings_input_component_outlined,
            options: _diOptions,
            selected: _config.di,
            onSelected: (v) => _updateField(di: v),
          ),
          _OptionGroup(
            width: (constraints.maxWidth - (cols - 1) * 20) / cols,
            title: 'Network Layer',
            icon: Icons.cloud_outlined,
            options: _networkOptions,
            selected: _config.network,
            onSelected: (v) => _updateField(network: v),
          ),
          _OptionGroup(
            width: (constraints.maxWidth - (cols - 1) * 20) / cols,
            title: 'Local Storage',
            icon: Icons.storage_outlined,
            options: _storageOptions,
            selected: _config.localStorage,
            onSelected: (v) => _updateField(localStorage: v),
          ),
          _OptionGroup(
            width: (constraints.maxWidth - (cols - 1) * 20) / cols,
            title: 'Navigation',
            icon: Icons.route_outlined,
            options: _navOptions,
            selected: _config.navigation,
            onSelected: (v) => _updateField(navigation: v),
          ),
        ],
      );
    });
  }

  Widget _buildStackSummary() {
    final items = [
      ('Architecture', _config.pattern, Icons.account_tree_outlined),
      ('State', _config.stateManagement, Icons.swap_horiz),
      ('DI', _config.di, Icons.settings_input_component_outlined),
      ('Network', _config.network, Icons.cloud_outlined),
      ('Storage', _config.localStorage, Icons.storage_outlined),
      ('Navigation', _config.navigation, Icons.route_outlined),
    ];
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.08),
            AppColors.secondary.withOpacity(0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.summarize_outlined,
                  color: AppColors.primary, size: 18),
              const Gap(8),
              Text('Selected Stack', style: AppTextStyles.h4),
            ],
          ),
          const Gap(16),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.$3, size: 14, color: AppColors.textMuted),
                    const Gap(6),
                    Text('${item.$1}: ',
                        style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted)),
                    Text(
                      _formatValue(item.$2),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _formatValue(String v) =>
      v.replaceAll('_', ' ').split(' ').map((w) =>
          w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1)).join(' ');
}

extension ArchConfigCopyWith on ArchitectureConfig {
  ArchitectureConfig copyWith({
    String? pattern,
    String? stateManagement,
    String? di,
    String? network,
    String? localStorage,
    String? navigation,
  }) {
    return ArchitectureConfig(
      pattern: pattern ?? this.pattern,
      stateManagement: stateManagement ?? this.stateManagement,
      di: di ?? this.di,
      network: network ?? this.network,
      localStorage: localStorage ?? this.localStorage,
      navigation: navigation ?? this.navigation,
    );
  }
}

// ─── Option Groups ────────────────────────────────────────────────────────────

const _architectureOptions = [
  _OptionData('clean_architecture', 'Clean Architecture',
      'Domain, Data, Presentation layers with clear boundaries'),
  _OptionData('hexagonal', 'Hexagonal Architecture',
      'Ports & Adapters — true inversion of dependencies'),
  _OptionData('mvvm', 'MVVM',
      'Model-View-ViewModel with reactive data binding'),
];

const _stateOptions = [
  _OptionData('bloc', 'BLoC', 'Stream-based business logic, event-driven'),
  _OptionData('cubit', 'Cubit', 'Simplified BLoC with method-based state'),
  _OptionData('riverpod', 'Riverpod', 'Compile-safe reactive state management'),
  _OptionData('getx', 'GetX', 'All-in-one: state, routing, DI'),
  _OptionData('provider', 'Provider', 'InheritedWidget wrapper, Flutter-native'),
];

const _diOptions = [
  _OptionData('get_it', 'GetIt', 'Simple, fast service locator'),
  _OptionData('injectable', 'Injectable', 'GetIt + code generation annotations'),
  _OptionData('manual', 'Manual', 'Hand-wired constructors, maximum control'),
];

const _networkOptions = [
  _OptionData('dio', 'Dio', 'Interceptors, multipart, cancellation tokens'),
  _OptionData('retrofit', 'Retrofit', 'Type-safe HTTP via code generation'),
  _OptionData('http', 'dart:http', 'Minimal, zero-dependency HTTP client'),
  _OptionData('graphql', 'GraphQL', 'Apollo-style client with schema typing'),
];

const _storageOptions = [
  _OptionData('hive', 'Hive', 'Lightweight NoSQL, pure Dart, fast reads'),
  _OptionData('isar', 'Isar', 'Multi-platform, full-text search, reactive'),
  _OptionData('drift', 'Drift', 'Type-safe SQLite with reactive streams'),
  _OptionData('shared_prefs', 'SharedPreferences', 'Key-value pairs, simple settings'),
];

const _navOptions = [
  _OptionData('go_router', 'GoRouter', 'Declarative, deep linking, shell routes'),
  _OptionData('auto_route', 'AutoRoute', 'Code-gen based typed routing'),
  _OptionData('nav2', 'Navigator 2.0', 'Full manual control over back stack'),
];

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
            color: isSelected
                ? AppColors.primary.withOpacity(0.12)
                : AppColors.surfaceElevated,
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
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 12)
                    : null,
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.label,
                      style: AppTextStyles.label.copyWith(
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
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
