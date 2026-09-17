import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../app/theme/app_theme.dart';

/// Shared section header used across wizard steps
class WizardSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const WizardSectionHeader({
    super.key,
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

/// Shared field label used across wizard steps
class WizardFieldLabel extends StatelessWidget {
  final String text;
  const WizardFieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
    );
  }
}
