import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/step_indicator.dart';
import '../../../../shared/widgets/app_button.dart';
import '../cubit/wizard_cubit.dart';
import '../cubit/wizard_state.dart';
import 'step1_identity.dart';
import 'step2_postman.dart';
import 'step3_figma.dart';
import 'step4_architecture.dart';
import 'step5_features.dart';

class WizardShell extends StatelessWidget {
  const WizardShell({super.key});

  static const _stepLabels = [
    'Project Identity',
    'Postman Collection',
    'Figma Design',
    'Architecture',
    'Feature Graph',
  ];

  static const _stepDescriptions = [
    'Name and describe your project',
    'Upload your API collection',
    'Link your design file',
    'Choose your tech stack',
    'Map features & dependencies',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<WizardCubit, WizardState>(
        listener: (context, state) {
          if (!state.isSubmitting && state.errorMessage == null &&
              state.currentStep == WizardStep.features) {
            // Already on last step — submission handled by button
          }
        },
        builder: (context, state) {
          return Row(
            children: [
              // ── Left Sidebar ──────────────────────────────────────────────
              _buildSidebar(context, state),
              // ── Main Content ──────────────────────────────────────────────
              Expanded(
                child: Column(
                  children: [
                    _buildTopBar(context, state),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.04, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: _buildCurrentStep(context, state),
                      ),
                    ),
                    _buildBottomBar(context, state),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, WizardState state) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo section
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.auto_awesome,
                      color: Colors.white, size: 18),
                ),
                const Gap(10),
                Text('FlutterForge', style: AppTextStyles.h4),
              ],
            ),
          ),
          const Divider(height: 1),
          // Project name preview
          if (state.config.projectName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Project', style: AppTextStyles.bodySmall),
                  const Gap(4),
                  Text(state.config.projectName,
                      style: AppTextStyles.h4.copyWith(
                          color: AppColors.primary)),
                  if (state.config.slug.isNotEmpty)
                    Text(state.config.slug,
                        style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted)),
                  const Gap(16),
                  const Divider(height: 1),
                ],
              ),
            ),
          // Step indicator
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: StepIndicator(
              steps: _stepLabels,
              currentStep: state.stepIndex,
              onStepTapped: (index) {
                if (index < state.stepIndex) {
                  context
                      .read<WizardCubit>()
                      .goToStep(WizardStep.values[index]);
                }
              },
            ),
          ),
          const Spacer(),
          // Help panel
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: AppColors.primary, size: 16),
                      const Gap(8),
                      Text('Step ${state.stepIndex + 1} of 5',
                          style: AppTextStyles.label.copyWith(
                              color: AppColors.primary)),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    _stepDescriptions[state.stepIndex],
                    style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, WizardState state) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Text(_stepLabels[state.stepIndex], style: AppTextStyles.h3),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textSecondary),
            onPressed: () => context.go('/dashboard'),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(BuildContext context, WizardState state) {
    switch (state.currentStep) {
      case WizardStep.identity:
        return const Step1Identity(key: ValueKey('step1'));
      case WizardStep.postman:
        return const Step2Postman(key: ValueKey('step2'));
      case WizardStep.figma:
        return const Step3Figma(key: ValueKey('step3'));
      case WizardStep.architecture:
        return const Step4Architecture(key: ValueKey('step4'));
      case WizardStep.features:
        return const Step5Features(key: ValueKey('step5'));
    }
  }

  Widget _buildBottomBar(BuildContext context, WizardState state) {
    final cubit = context.read<WizardCubit>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (!state.isFirstStep)
            AppButton(
              label: 'Back',
              isSecondary: true,
              icon: Icons.arrow_back,
              onPressed: cubit.previousStep,
            ),
          const Spacer(),
          if (state.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                state.errorMessage!,
                style: AppTextStyles.body.copyWith(color: AppColors.error),
              ),
            ),
          if (state.isLastStep)
            GradientButton(
              label: 'Generate Project',
              isLoading: state.isSubmitting,
              trailingIcon: Icons.rocket_launch,
              onPressed: () async {
                await cubit.submitProject();
                if (context.mounted) {
                  context.go('/pipeline/${state.config.projectId}');
                }
              },
            )
          else
            AppButton(
              label: 'Continue',
              trailingIcon: Icons.arrow_forward,
              onPressed: cubit.nextStep,
            ),
        ],
      ),
    );
  }
}
