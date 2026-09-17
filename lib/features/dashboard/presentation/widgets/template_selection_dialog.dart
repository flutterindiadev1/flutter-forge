import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../wizard/presentation/cubit/wizard_cubit.dart';

class TemplateSelectionDialog extends StatefulWidget {
  const TemplateSelectionDialog({super.key});

  @override
  State<TemplateSelectionDialog> createState() => _TemplateSelectionDialogState();
}

class _TemplateSelectionDialogState extends State<TemplateSelectionDialog> {
  int _selectedIndex = 0;

  final _templates = [
    {
      'title': 'Blank Canvas',
      'description': 'Start from scratch with a completely clean architecture.',
      'icon': Icons.crop_square,
      'color': AppColors.primary,
    },
    {
      'title': 'E-Commerce',
      'description': 'Pre-configured with Cart, Payments, and Product Catalog features.',
      'icon': Icons.shopping_bag_outlined,
      'color': Colors.orangeAccent,
    },
    {
      'title': 'Social Media',
      'description': 'Includes Feeds, Profiles, and Chat functionality.',
      'icon': Icons.people_alt_outlined,
      'color': Colors.pinkAccent,
    },
    {
      'title': 'SaaS Dashboard',
      'description': 'Admin panels, charts, and user management ready to go.',
      'icon': Icons.dashboard_outlined,
      'color': Colors.cyan,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose a Template', style: AppTextStyles.h2),
            const Gap(8),
            Text('Select a starting point for your new Flutter project.',
                style: AppTextStyles.body.copyWith(color: AppColors.textMuted)),
            const Gap(32),
            SizedBox(
              height: 300,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.6,
                ),
                itemCount: _templates.length,
                itemBuilder: (context, index) {
                  final t = _templates[index];
                  final isSelected = _selectedIndex == index;
                  return InkWell(
                    onTap: () => setState(() => _selectedIndex = index),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(t['icon'] as IconData,
                              color: t['color'] as Color, size: 32),
                          const Gap(12),
                          Text(t['title'] as String, style: AppTextStyles.h4),
                          const Gap(4),
                          Expanded(
                            child: Text(
                              t['description'] as String,
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: AppColors.textMuted),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Gap(32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
                const Gap(16),
                ElevatedButton(
                  onPressed: () {
                    // Start Wizard with this template
                    final title = _templates[_selectedIndex]['title'] as String;
                    // Reset wizard state to start fresh
                    context.read<WizardCubit>().reset(templateId: title);
                    Navigator.of(context).pop();
                    context.go('/wizard');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Continue'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
