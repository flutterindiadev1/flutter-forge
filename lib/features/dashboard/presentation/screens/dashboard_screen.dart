import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../app/theme/app_theme.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../../models/project_summary.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          _buildSidebar(context),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(context),
                Expanded(child: _buildContent(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 220,
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.auto_awesome,
                      color: Colors.white, size: 20),
                ),
                const Gap(10),
                Text('FlutterForge', style: AppTextStyles.h4),
              ],
            ),
          ),
          const Divider(height: 1),
          const Gap(12),
          _NavItem(icon: Icons.grid_view, label: 'Projects', selected: true),
          _NavItem(icon: Icons.settings_outlined, label: 'Settings'),
          _NavItem(icon: Icons.help_outline, label: 'Docs'),
          const Spacer(),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, size: 18, color: Colors.white),
                ),
                const Gap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Developer', style: AppTextStyles.label),
                      Text('demo@forge.dev',
                          style: AppTextStyles.bodySmall,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Text('Projects', style: AppTextStyles.h2),
          const Spacer(),
          // Search
          SizedBox(
            width: 280,
            child: TextField(
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: const Icon(Icons.search, size: 18,
                    color: AppColors.textMuted),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                filled: true,
                fillColor: AppColors.surfaceElevated,
              ),
            ),
          ),
          const Gap(16),
          ElevatedButton.icon(
            onPressed: () => context.go('/wizard'),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New Project'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return _buildLoadingGrid();
        }
        if (state is DashboardLoaded) {
          if (state.projects.isEmpty) {
            return _buildEmptyState(context);
          }
          return _buildProjectGrid(context, state.projects);
        }
        return Center(child: Text('Error loading projects',
            style: AppTextStyles.body));
      },
    );
  }

  Widget _buildLoadingGrid() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: List.generate(3, (_) => _SkeletonCard()),
      ),
    );
  }

  Widget _buildProjectGrid(BuildContext context, List<ProjectSummary> projects) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats row
          Row(
            children: [
              _StatChip(label: '${projects.length} Projects', icon: Icons.folder),
              const Gap(12),
              _StatChip(
                label: '${projects.where((p) => p.status == ProjectStatus.ready).length} Ready',
                icon: Icons.check_circle_outline,
                color: AppColors.success,
              ),
              const Gap(12),
              _StatChip(
                label: '${projects.where((p) => p.status == ProjectStatus.generating).length} Generating',
                icon: Icons.autorenew,
                color: AppColors.warning,
              ),
            ],
          ),
          const Gap(24),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: projects
                .map((p) => _ProjectCard(
                      project: p,
                      onTap: () {
                        if (p.status == ProjectStatus.generating) {
                          context.go('/pipeline/${p.id}');
                        } else if (p.status == ProjectStatus.draft) {
                          context.go('/wizard');
                        }
                      },
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.add_circle_outline,
                size: 40, color: AppColors.primary),
          ),
          const Gap(20),
          Text('No projects yet', style: AppTextStyles.h2),
          const Gap(8),
          Text('Create your first AI-powered Flutter project',
              style: AppTextStyles.body),
          const Gap(24),
          ElevatedButton.icon(
            onPressed: () => context.go('/wizard'),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Create Project'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _NavItem({required this.icon, required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary.withOpacity(0.12) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon,
            size: 20,
            color: selected ? AppColors.primary : AppColors.textMuted),
        title: Text(label,
            style: AppTextStyles.label.copyWith(
                color: selected ? AppColors.primary : AppColors.textSecondary)),
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _StatChip({
    required this.label,
    required this.icon,
    this.color = AppColors.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const Gap(8),
          Text(label,
              style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final ProjectSummary project;
  final VoidCallback onTap;

  const _ProjectCard({required this.project, required this.onTap});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  Color get _statusColor {
    switch (widget.project.status) {
      case ProjectStatus.ready: return AppColors.success;
      case ProjectStatus.generating: return AppColors.warning;
      case ProjectStatus.draft: return AppColors.textMuted;
      case ProjectStatus.failed: return AppColors.error;
    }
  }

  String get _statusLabel {
    switch (widget.project.status) {
      case ProjectStatus.ready: return 'Ready';
      case ProjectStatus.generating: return 'Generating';
      case ProjectStatus.draft: return 'Draft';
      case ProjectStatus.failed: return 'Failed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 340,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.surfaceElevated : AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? AppColors.primary.withOpacity(0.4)
                  : AppColors.border,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: _statusColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const Gap(6),
                        Text(
                          _statusLabel,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: _statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: _hovered
                        ? AppColors.primary
                        : AppColors.textMuted,
                  ),
                ],
              ),
              const Gap(16),
              Text(widget.project.name, style: AppTextStyles.h3),
              const Gap(6),
              Text(
                widget.project.description,
                style: AppTextStyles.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Gap(16),
              // Meta row
              Row(
                children: [
                  const Icon(Icons.group_outlined,
                      size: 14, color: AppColors.textMuted),
                  const Gap(4),
                  Text(widget.project.team,
                      style: AppTextStyles.bodySmall),
                  const Gap(16),
                  const Icon(Icons.layers_outlined,
                      size: 14, color: AppColors.textMuted),
                  const Gap(4),
                  Text('${widget.project.featureCount} features',
                      style: AppTextStyles.bodySmall),
                ],
              ),
              const Gap(12),
              // Platforms
              Wrap(
                spacing: 6,
                children: widget.project.platforms
                    .map((p) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(p,
                              style: AppTextStyles.bodySmall.copyWith(
                                  fontSize: 10)),
                        ))
                    .toList(),
              ),
              const Gap(12),
              Text(
                'Updated ${DateFormat.jm().format(widget.project.lastUpdated)}',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.card,
      highlightColor: AppColors.surfaceElevated,
      child: Container(
        width: 340,
        height: 220,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
      ),
    );
  }
}
