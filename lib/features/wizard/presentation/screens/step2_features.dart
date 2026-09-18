import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/feature_node.dart';
import '../../../../shared/widgets/feature_dependency_graph.dart';
import '../cubit/wizard_cubit.dart';
import '../cubit/wizard_state.dart';
import 'wizard_widgets.dart';
import 'package:uuid/uuid.dart';
import '../../models/project_config.dart';

class Step2Features extends StatefulWidget {
  const Step2Features({super.key});

  @override
  State<Step2Features> createState() => _Step2FeaturesState();
}

class _Step2FeaturesState extends State<Step2Features>
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
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.3)),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Colors.transparent,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
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
                              selectedNodeId: _selectedFeatureId,
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
                      const Gap(40),
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
                Text('Description',
                    style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary)),
                const Gap(8),
                TextField(
                  controller: descCtrl,
                  style: AppTextStyles.body.copyWith(
                      color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Brief description of the feature',
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
                              ? AppColors.primary.withValues(alpha: 0.15)
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
                          description: descCtrl.text.trim(),
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
                                ? AppColors.primary.withValues(alpha: 0.15)
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
            const Gap(16),
            const Divider(height: 1),
            _buildCustomRequirementsSection(context, widget.feature),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomRequirementsSection(BuildContext context, FeatureNode feature) {
    final state = context.watch<WizardCubit>().state;
    final painters = state.config.customPainters.where((p) => p.featureId == feature.id).toList();
    final modules = state.config.nativeModules.where((m) => m.featureId == feature.id).toList();
    final deps = state.config.dependencies.where((d) => d.featureId == feature.id).toList();
    final instrs = state.config.llmInstructions.where((i) => i.featureId == feature.id).toList();

    final hasAny = painters.isNotEmpty || modules.isNotEmpty || deps.isNotEmpty || instrs.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Custom Requirements', style: AppTextStyles.label.copyWith(color: AppColors.textPrimary)),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _showAddRequirementDialog(context, feature.id),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Requirement'),
              ),
            ],
          ),
          if (hasAny) const Gap(12),
          if (painters.isNotEmpty)
            ...painters.map((p) => _RequirementTile(
              icon: Icons.brush,
              title: 'Custom Painter: ${p.name}',
              subtitle: p.description,
              onDelete: () => context.read<WizardCubit>().removeCustomPainter(p.id),
            )),
          if (modules.isNotEmpty)
            ...modules.map((m) => _RequirementTile(
              icon: Icons.memory,
              title: 'Native Module: ${m.moduleName}',
              subtitle: '${m.platforms.join(", ")} - ${m.description}',
              onDelete: () => context.read<WizardCubit>().removeNativeModule(m.id),
            )),
          if (deps.isNotEmpty)
            ...deps.map((d) => _RequirementTile(
              icon: Icons.extension,
              title: 'Dependency: ${d.packageName}',
              subtitle: 'Version: ${d.version}',
              onDelete: () => context.read<WizardCubit>().removeDependency(d.id),
            )),

          if (!hasAny)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('No specific requirements for this feature.', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
            ),
        ],
      ),
    );
  }

  void _showAddRequirementDialog(BuildContext context, String featureId) {
    String type = 'Dependency';
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController(); // Or instruction
    String platform = 'iOS';

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Add Requirement', style: AppTextStyles.h3),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: type,
                  dropdownColor: AppColors.surfaceElevated,
                  decoration: InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: ['Dependency', 'Custom Painter', 'Native Module']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() => type = val);
                    }
                  },
                ),
                const Gap(16),
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      labelText: type == 'Dependency' ? 'Package Name / Pub.dev URL' : 'Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                const Gap(16),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: type == 'Dependency' ? 'Version (optional)' : 'Description',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                if (type == 'Native Module') ...[
                  const Gap(16),
                  DropdownButtonFormField<String>(
                    initialValue: platform,
                    dropdownColor: AppColors.surfaceElevated,
                    decoration: InputDecoration(
                      labelText: 'Platform',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    items: ['iOS', 'Android', 'macOS', 'Windows', 'Linux']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => platform = val);
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final cubit = context.read<WizardCubit>();
                if (type == 'Dependency') {
                  final input = nameCtrl.text.trim();
                  if (input.startsWith('http')) {
                    final resolved = await cubit.resolvePubDevUrl(input);
                    if (resolved != null) {
                      cubit.addDependency(resolved.copyWith(featureId: featureId));
                    }
                  } else {
                    cubit.addDependency(PubDependency(
                      id: const Uuid().v4(),
                      packageName: input,
                      pubDevUrl: 'https://pub.dev/packages/$input',
                      version: descCtrl.text.trim().isNotEmpty ? descCtrl.text.trim() : 'any',
                      featureId: featureId,
                    ));
                  }
                } else if (type == 'Custom Painter') {
                  cubit.addCustomPainter(CustomPainterSpec(
                    id: const Uuid().v4(),
                    name: nameCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                    featureId: featureId,
                  ));
                } else if (type == 'Native Module') {
                  cubit.addNativeModule(NativeModuleSpec(
                    id: const Uuid().v4(),
                    moduleName: nameCtrl.text.trim(),
                    platforms: [platform],
                    description: descCtrl.text.trim(),
                    featureId: featureId,
                  ));
                }
                if (context.mounted) Navigator.pop(dialogCtx);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequirementTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onDelete;

  const _RequirementTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.accent),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.label.copyWith(color: AppColors.textPrimary)),
                const Gap(2),
                Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16, color: AppColors.textMuted),
            onPressed: onDelete,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
