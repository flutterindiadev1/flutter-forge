import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../app/theme/app_theme.dart';

class StepIndicator extends StatelessWidget {
  final List<String> steps;
  final int currentStep;
  final ValueChanged<int>? onStepTapped;

  const StepIndicator({
    super.key,
    required this.steps,
    required this.currentStep,
    this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        final isDone = index < currentStep;
        final isCurrent = index == currentStep;
        final isLast = index == steps.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Line + circle column
              Column(
                children: [
                  _StepCircle(
                    index: index,
                    isDone: isDone,
                    isCurrent: isCurrent,
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: isDone
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                ],
              ),
              const Gap(14),
              // Label
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 28),
                child: GestureDetector(
                  onTap: isDone ? () => onStepTapped?.call(index) : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Step ${index + 1}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isCurrent
                              ? AppColors.primary
                              : isDone
                                  ? AppColors.textSecondary
                                  : AppColors.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Gap(2),
                      Text(
                        steps[index],
                        style: AppTextStyles.label.copyWith(
                          color: isCurrent
                              ? AppColors.textPrimary
                              : isDone
                                  ? AppColors.textSecondary
                                  : AppColors.textMuted,
                          fontWeight: isCurrent
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int index;
  final bool isDone;
  final bool isCurrent;

  const _StepCircle({
    required this.index,
    required this.isDone,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isCurrent ? AppColors.primaryGradient : null,
        color: isDone
            ? AppColors.primary.withOpacity(0.2)
            : isCurrent
                ? null
                : AppColors.surfaceElevated,
        border: Border.all(
          color: isCurrent
              ? AppColors.primary
              : isDone
                  ? AppColors.primary.withOpacity(0.5)
                  : AppColors.border,
          width: 1.5,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                )
              ]
            : null,
      ),
      child: Center(
        child: isDone
            ? const Icon(Icons.check, color: AppColors.primary, size: 16)
            : Text(
                '${index + 1}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: isCurrent ? Colors.white : AppColors.textMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
