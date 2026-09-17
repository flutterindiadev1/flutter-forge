import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_theme.dart';
import '../cubit/pipeline_cubit.dart';
import '../widgets/post_generation_panel.dart';


class PipelineScreen extends StatefulWidget {
  const PipelineScreen({super.key});

  @override
  State<PipelineScreen> createState() => _PipelineScreenState();
}

class _PipelineScreenState extends State<PipelineScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _logScrollController = ScrollController();
  late AnimationController _pulseController;
  bool _answeredFirst = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _logScrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PipelineCubit, PipelineState>(
      listener: (context, state) {
        if (_logScrollController.hasClients) {
          _logScrollController.animateTo(
            _logScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              _buildTopBar(context, state),
              Expanded(
                child: Row(
                  children: [
                    // Phase timeline
                    _buildPhasePanel(state),
                    // Main content area
                    Expanded(
                      child: state.isComplete && state.phase != PipelinePhase.failed
                          ? PostGenerationPanel(state: state)
                          : Column(
                              children: [
                                if (state.isAwaitingElicitation)
                                  _ElicitationBanner(
                                    state: state,
                                    onAnswer: (answer) {
                                      if (!_answeredFirst) {
                                        _answeredFirst = true;
                                        context
                                            .read<PipelineCubit>()
                                            .answerElicitation(answer);
                                      } else {
                                        context
                                            .read<PipelineCubit>()
                                            .answerSecondElicitation(answer);
                                      }
                                    },
                                  ),
                                Expanded(child: _buildLogPanel(state)),
                              ],
                            ),
                    ),
                    // Output tree panel (only when NOT complete, as PostGenPanel takes over)
                    if (!state.isComplete && state.generatedPayloadPreview != null)
                      _OutputTreePanel(content: state.generatedPayloadPreview!),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context, PipelineState state) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
          ),
          const Gap(12),
          Text('FlutterForge', style: AppTextStyles.h4),
          const Gap(24),
          Container(
            width: 1,
            height: 24,
            color: AppColors.border,
          ),
          const Gap(24),
          if (!state.isComplete)
            AnimatedBuilder(
              animation: _pulseController,
              builder: (_, _) => Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(
                          alpha: 0.5 + _pulseController.value * 0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    _phaseLabel(state.phase),
                    style: AppTextStyles.label.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            )
          else if (state.phase == PipelinePhase.failed)
            Row(
              children: [
                const Icon(Icons.error, color: AppColors.error, size: 18),
                const Gap(8),
                Text('Generation Failed',
                    style: AppTextStyles.label.copyWith(color: AppColors.error)),
              ],
            )
          else
            Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                const Gap(8),
                Text('Generation Complete',
                    style: AppTextStyles.label.copyWith(color: AppColors.success)),
              ],
            ),
          const Spacer(),
          if (state.phase == PipelinePhase.failed)
            ElevatedButton.icon(
              onPressed: () => context.read<PipelineCubit>().retryPipeline(),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            )
          else if (state.isComplete)
            ElevatedButton.icon(
              onPressed: () => context.go('/dashboard'),
              icon: const Icon(Icons.dashboard_outlined, size: 18),
              label: const Text('Back to Dashboard'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            )
          else
            TextButton.icon(
              onPressed: () => context.go('/dashboard'),
              icon: const Icon(Icons.arrow_back, size: 16),
              label: const Text('Dashboard'),
              style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary),
            ),
        ],
      ),
    );
  }

  Widget _buildPhasePanel(PipelineState state) {
    final phases = [
      (PipelinePhase.parsing, 'Parsing', Icons.document_scanner_outlined),
      (PipelinePhase.structureGen, 'Structure Gen', Icons.folder_outlined),
      (PipelinePhase.elicitation, 'Elicitation', Icons.record_voice_over_outlined),
      (PipelinePhase.llmGen, 'LLM Generation', Icons.smart_toy_outlined),
      (PipelinePhase.astMerge, 'AST Merge', Icons.merge_type),
    ];

    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pipeline Phases', style: AppTextStyles.h4),
          const Gap(20),
          ...phases.map((phase) {
            final currentIdx = PipelinePhase.values.indexOf(state.phase);
            final phaseIdx = PipelinePhase.values.indexOf(phase.$1);
            final isDone = phaseIdx < currentIdx ||
                (state.isComplete && state.phase != PipelinePhase.failed);
            final isCurrent = phaseIdx == currentIdx;
            final isWaiting = phaseIdx > currentIdx;

            return _PhaseRow(
              icon: phase.$3,
              label: phase.$2,
              isDone: isDone,
              isCurrent: isCurrent && !state.isComplete,
              isWaiting: isWaiting,
              progress: isCurrent ? state.phaseProgress : (isDone ? 1.0 : 0.0),
              isElicitation: phase.$1 == PipelinePhase.elicitation &&
                  state.isAwaitingElicitation,
            );
          }),
          if (state.isComplete)
            _PhaseRow(
              icon: state.phase == PipelinePhase.failed ? Icons.error_outline : Icons.check_circle_outline,
              label: state.phase == PipelinePhase.failed ? 'Failed' : 'Complete!',
              isDone: state.isComplete && state.phase != PipelinePhase.failed,
              isCurrent: false,
              isWaiting: false,
              progress: 1.0,
            ),
        ],
      ),
    );
  }

  Widget _buildLogPanel(PipelineState state) {
    return Container(
      color: const Color(0xFF080C16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: AppColors.surface,
            child: Row(
              children: [
                const Icon(Icons.terminal, color: AppColors.textMuted, size: 16),
                const Gap(8),
                Text('Pipeline Log', style: AppTextStyles.label),
                const Spacer(),
                Text('${state.logs.length} events', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _logScrollController,
              padding: const EdgeInsets.all(16),
              itemCount: state.logs.length,
              itemBuilder: (_, i) {
                final log = state.logs[i];
                return _LogLine(event: log);
              },
            ),
          ),
        ],
      ),
    );
  }

  String _phaseLabel(PipelinePhase phase) {
    switch (phase) {
      case PipelinePhase.parsing: return 'Parsing files...';
      case PipelinePhase.structureGen: return 'Generating structure...';
      case PipelinePhase.elicitation: return 'Awaiting your input...';
      case PipelinePhase.llmGen: return 'LLM generating code...';
      case PipelinePhase.astMerge: return 'Merging & validating...';
      case PipelinePhase.done: return 'Complete!';
      case PipelinePhase.failed: return 'Failed';
    }
  }
}

class _PhaseRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDone;
  final bool isCurrent;
  final bool isWaiting;
  final double progress;
  final bool isElicitation;

  const _PhaseRow({
    required this.icon,
    required this.label,
    required this.isDone,
    required this.isCurrent,
    required this.isWaiting,
    required this.progress,
    this.isElicitation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isDone
                      ? AppColors.success.withValues(alpha: 0.15)
                      : isCurrent
                          ? (isElicitation
                              ? AppColors.warning.withValues(alpha: 0.15)
                              : AppColors.primary.withValues(alpha: 0.15))
                          : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDone
                        ? AppColors.success.withValues(alpha: 0.4)
                        : isCurrent
                            ? (isElicitation
                                ? AppColors.warning.withValues(alpha: 0.5)
                                : AppColors.primary.withValues(alpha: 0.5))
                            : AppColors.border,
                  ),
                ),
                child: Icon(
                  isDone ? Icons.check : icon,
                  size: 16,
                  color: isDone
                      ? AppColors.success
                      : isCurrent
                          ? (isElicitation ? AppColors.warning : AppColors.primary)
                          : AppColors.textMuted,
                ),
              ),
              const Gap(10),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.label.copyWith(
                    color: isDone
                        ? AppColors.success
                        : isCurrent
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          if (isCurrent) ...[
            const Gap(8),
            Padding(
              padding: const EdgeInsets.only(left: 42),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.surfaceElevated,
                  valueColor: AlwaysStoppedAnimation(
                    isElicitation ? AppColors.warning : AppColors.primary,
                  ),
                  minHeight: 4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LogLine extends StatelessWidget {
  final PipelineEvent event;

  const _LogLine({required this.event});

  Color get _levelColor {
    switch (event.level) {
      case 'success': return AppColors.success;
      case 'warning': return AppColors.warning;
      case 'error': return AppColors.error;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('HH:mm:ss').format(event.timestamp),
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Text(
              event.message,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: _levelColor,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ElicitationBanner extends StatelessWidget {
  final PipelineState state;
  final ValueChanged<String> onAnswer;

  const _ElicitationBanner({required this.state, required this.onAnswer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.record_voice_over_outlined,
                  color: AppColors.warning, size: 20),
              const Gap(10),
              Text(
                'FlutterForge needs your input',
                style: AppTextStyles.h4.copyWith(color: AppColors.warning),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('Elicitation Phase',
                    style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.warning, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          if (state.elicitationContext != null) ...[
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: AppColors.textMuted, size: 14),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      state.elicitationContext!,
                      style: AppTextStyles.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const Gap(14),
          Text(
            state.currentElicitationQuestion!,
            style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary),
          ),
          const Gap(16),
          if (state.elicitationOptions != null)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: state.elicitationOptions!
                  .map((option) => ElevatedButton(
                        onPressed: () => onAnswer(option),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceElevated,
                          foregroundColor: AppColors.textPrimary,
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                        ),
                        child: Text(option,
                            style: AppTextStyles.label.copyWith(
                                color: AppColors.textPrimary)),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _OutputTreePanel extends StatelessWidget {
  final String content;
  const _OutputTreePanel({required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(left: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                const Icon(Icons.folder_open_outlined,
                    color: AppColors.success, size: 16),
                const Gap(8),
                Text('Generated Files', style: AppTextStyles.label.copyWith(
                    color: AppColors.success)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(
                content,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
