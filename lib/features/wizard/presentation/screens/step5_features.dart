import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/feature_node.dart';
import '../../../../shared/widgets/feature_dependency_graph.dart';
import '../cubit/wizard_cubit.dart';
import '../cubit/wizard_state.dart';
import 'wizard_widgets.dart';


class Step5Features extends StatefulWidget {
  const Step5Features({super.key});

  @override
  State<Step5Features> createState() => _Step5FeaturesState();
}

class _Step5FeaturesState extends State<Step5Features>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedFeatureId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WizardCubit, WizardState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 32, 40, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: WizardSectionHeader(

                      icon: Icons.account_tree_outlined,
                      title: 'Feature Graph',
                      subtitle:
                          'Define your app\'s features and map their inter-dependencies.',
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddFeatureDialog(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Feature'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
            // Cycle warning
            if (state.cyclicDependencyWarnings.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.warning.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_outlined,
                          color: AppColors.warning, size: 18),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          'Circular dependency detected: ${state.cyclicDependencyWarnings.first}',
                          style: AppTextStyles.body.copyWith(
                              color: AppColors.warning),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // Tab bar
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.transparent,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textMuted,
                  labelStyle: AppTextStyles.label.copyWith(
                      fontWeight: FontWeight.w600),
                  tabs: const [
                    Tab(text: 'Visual Graph'),
                    Tab(text: 'Feature List'),
                  ],
                ),
              ),
            ),
            const Gap(16),
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Graph view
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: FeatureDependencyGraph(
                        nodes: state.config.features,
                        onNodeTap: (id) =>
                            setState(() => _selectedFeatureId = id),
                        onNodeDragged: (id, x, y) =>
                            context.read<WizardCubit>().updateFeaturePosition(id, x, y),
                      ),
                    ),
                  ),
                  // List view
                  ListView(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
                    children: [
                      if (state.config.features.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 60),
                            child: Column(
                              children: [
                                const Icon(Icons.layers_outlined,
                                    size: 48, color: AppColors.textMuted),
                                const Gap(12),
                                Text('No features yet',
                                    style: AppTextStyles.h4.copyWith(
                                        color: AppColors.textMuted)),
                                const Gap(6),
                                Text(
                                    'Click "Add Feature" to get started',
                                    style: AppTextStyles.body),
                              ],
                            ),
                          ),
                        )
                      else
                        ...state.config.features.map((feature) =>
                            _FeatureListItem(
                              feature: feature,
                              allFeatures: state.config.features,
                              onToggleDep: (depId) => context
                                  .read<WizardCubit>()
                                  .toggleDependency(feature.id, depId),
                              onDelete: () => context
                                  .read<WizardCubit>()
                                  .removeFeature(feature.id),
                            )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddFeatureDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    FeatureLayer layer = FeatureLayer.domain;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.card,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Add Feature', style: AppTextStyles.h3),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Feature Name',
                    style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary)),
                const Gap(8),
                TextField(
                  controller: nameCtrl,
                  autofocus: true,
                  style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'e.g. Authentication, Home, Profile',
                    hintStyle: AppTextStyles.body.copyWith(
                        color: AppColors.textMuted),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 1.5),
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceElevated,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                ),
                const Gap(16),
                Text('Layer',
                    style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary)),
                const Gap(8),
                Wrap(
                  spacing: 8,
                  children: FeatureLayer.values.map((l) {
                    final selected = layer == l;
                    return GestureDetector(
                      onTap: () => setDialogState(() => layer = l),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary.withOpacity(0.15)
                              : AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.border),
                        ),
                        child: Text(
                          l.name.toUpperCase(),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: selected
                                ? AppColors.primary
                                : AppColors.textMuted,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text('Cancel',
                  style:
                      AppTextStyles.label.copyWith(color: AppColors.textMuted)),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.trim().isNotEmpty) {
                  context.read<WizardCubit>().addFeature(
                        FeatureNode.create(
                          name: nameCtrl.text.trim(),
                          layer: layer,
                        ),
                      );
                  Navigator.pop(dialogCtx);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureListItem extends StatefulWidget {
  final FeatureNode feature;
  final List<FeatureNode> allFeatures;
  final ValueChanged<String> onToggleDep;
  final VoidCallback onDelete;

  const _FeatureListItem({
    required this.feature,
    required this.allFeatures,
    required this.onToggleDep,
    required this.onDelete,
  });

  @override
  State<_FeatureListItem> createState() => _FeatureListItemState();
}

class _FeatureListItemState extends State<_FeatureListItem> {
  bool _expanded = false;

  Color get _layerColor {
    switch (widget.feature.layer) {
      case FeatureLayer.ui: return AppColors.accent;
      case FeatureLayer.domain: return AppColors.primary;
      case FeatureLayer.data: return AppColors.success;
      case FeatureLayer.shared: return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final otherFeatures = widget.allFeatures
        .where((f) => f.id != widget.feature.id)
        .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _layerColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.feature.name,
                            style: AppTextStyles.label.copyWith(
                                color: AppColors.textPrimary)),
                        const Gap(2),
                        Text(
                          widget.feature.layer.name.toUpperCase() +
                              (widget.feature.dependencyIds.isNotEmpty
                                  ? ' · ${widget.feature.dependencyIds.length} deps'
                                  : ''),
                          style: AppTextStyles.bodySmall.copyWith(
                              color: _layerColor),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: AppColors.error, size: 18),
                    onPressed: widget.onDelete,
                  ),
                  Icon(
                    _expanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded && otherFeatures.isNotEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Depends on:',
                      style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary)),
                  const Gap(10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: otherFeatures.map((dep) {
                      final selected = widget.feature.dependencyIds
                          .contains(dep.id);
                      return GestureDetector(
                        onTap: () => widget.onToggleDep(dep.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary.withOpacity(0.15)
                                : AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (selected)
                                const Padding(
                                  padding: EdgeInsets.only(right: 6),
                                  child: Icon(Icons.check,
                                      size: 13, color: AppColors.primary),
                                ),
                              Text(
                                dep.name,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
