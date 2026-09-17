import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../features/wizard/models/feature_node.dart';

class FeatureDependencyGraph extends StatefulWidget {
  final List<FeatureNode> nodes;
  final ValueChanged<String>? onNodeTap;
  final Function(String id, double x, double y)? onNodeDragged;

  const FeatureDependencyGraph({
    super.key,
    required this.nodes,
    this.onNodeTap,
    this.onNodeDragged,
  });

  @override
  State<FeatureDependencyGraph> createState() =>
      _FeatureDependencyGraphState();
}

class _FeatureDependencyGraphState extends State<FeatureDependencyGraph>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

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
    _pulseController.dispose();
    super.dispose();
  }

  Map<String, Offset> _buildLayout(BoxConstraints constraints) {
    final positions = <String, Offset>{};
    final nodes = widget.nodes;
    if (nodes.isEmpty) return positions;

    for (int i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      if (node.x != null && node.y != null) {
        positions[node.id] = Offset(node.x!, node.y!);
      } else {
        // Auto-arrange in a circle
        final angle = (2 * math.pi * i) / nodes.length - math.pi / 2;
        final radius = math.min(constraints.maxWidth, constraints.maxHeight) *
            0.35;
        final cx = constraints.maxWidth / 2;
        final cy = constraints.maxHeight / 2;
        positions[node.id] = Offset(
          cx + radius * math.cos(angle),
          cy + radius * math.sin(angle),
        );
      }
    }
    return positions;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.nodes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.account_tree_outlined,
                size: 48, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text('Add features to see the dependency graph',
                style: AppTextStyles.body),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final positions = _buildLayout(constraints);
        return Stack(
          children: [
            // Edges
            AnimatedBuilder(
              animation: _pulseController,
              builder: (_, __) => CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _EdgePainter(
                  nodes: widget.nodes,
                  positions: positions,
                  animationValue: _pulseController.value,
                ),
              ),
            ),
            // Nodes
            ...widget.nodes.map((node) {
              final pos = positions[node.id];
              if (pos == null) return const SizedBox.shrink();
              return _DraggableNode(
                node: node,
                position: pos,
                onTap: () => widget.onNodeTap?.call(node.id),
                onDragEnd: (newPos) => widget.onNodeDragged?.call(
                  node.id,
                  newPos.dx.clamp(60, constraints.maxWidth - 60),
                  newPos.dy.clamp(30, constraints.maxHeight - 30),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class _DraggableNode extends StatefulWidget {
  final FeatureNode node;
  final Offset position;
  final VoidCallback onTap;
  final ValueChanged<Offset> onDragEnd;

  const _DraggableNode({
    required this.node,
    required this.position,
    required this.onTap,
    required this.onDragEnd,
  });

  @override
  State<_DraggableNode> createState() => _DraggableNodeState();
}

class _DraggableNodeState extends State<_DraggableNode> {
  late Offset _position;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _position = widget.position;
  }

  @override
  void didUpdateWidget(_DraggableNode old) {
    super.didUpdateWidget(old);
    if (!_isDragging) {
      _position = widget.position;
    }
  }

  Color get _layerColor {
    switch (widget.node.layer) {
      case FeatureLayer.ui:
        return AppColors.accent;
      case FeatureLayer.domain:
        return AppColors.primary;
      case FeatureLayer.data:
        return AppColors.success;
      case FeatureLayer.shared:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx - 60,
      top: _position.dy - 28,
      child: GestureDetector(
        onTap: widget.onTap,
        onPanStart: (_) => setState(() => _isDragging = true),
        onPanUpdate: (details) {
          setState(() {
            _position = _position + details.delta;
          });
        },
        onPanEnd: (_) {
          setState(() => _isDragging = false);
          widget.onDragEnd(_position);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 120,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isDragging
                  ? _layerColor
                  : _layerColor.withOpacity(0.5),
              width: _isDragging ? 2 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _layerColor.withOpacity(_isDragging ? 0.4 : 0.15),
                blurRadius: _isDragging ? 20 : 8,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.node.name,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _layerColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.node.layer.name.toUpperCase(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: _layerColor,
                      fontSize: 9,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EdgePainter extends CustomPainter {
  final List<FeatureNode> nodes;
  final Map<String, Offset> positions;
  final double animationValue;

  _EdgePainter({
    required this.nodes,
    required this.positions,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final nodeMap = {for (final n in nodes) n.id: n};

    for (final node in nodes) {
      for (final depId in node.dependencyIds) {
        final from = positions[node.id];
        final to = positions[depId];
        if (from == null || to == null) continue;

        // Draw arrow line
        final paint = Paint()
          ..color = AppColors.primary.withOpacity(0.5 + animationValue * 0.3)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;

        final path = Path();
        path.moveTo(from.dx, from.dy);

        // Curved bezier
        final midX = (from.dx + to.dx) / 2;
        final midY = (from.dy + to.dy) / 2;
        path.quadraticBezierTo(
          midX + (from.dy - to.dy) * 0.25,
          midY + (to.dx - from.dx) * 0.25,
          to.dx,
          to.dy,
        );
        canvas.drawPath(path, paint);

        // Arrowhead
        _drawArrowhead(canvas, from, to);
      }
    }
  }

  void _drawArrowhead(Canvas canvas, Offset from, Offset to) {
    final angle = math.atan2(to.dy - from.dy, to.dx - from.dx);
    const arrowLength = 10.0;
    const arrowAngle = 0.4;

    final tip = to;
    final p1 = Offset(
      tip.dx - arrowLength * math.cos(angle - arrowAngle),
      tip.dy - arrowLength * math.sin(angle - arrowAngle),
    );
    final p2 = Offset(
      tip.dx - arrowLength * math.cos(angle + arrowAngle),
      tip.dy - arrowLength * math.sin(angle + arrowAngle),
    );

    final arrowPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..close();

    canvas.drawPath(path, arrowPaint);
  }

  @override
  bool shouldRepaint(_EdgePainter old) =>
      old.animationValue != animationValue ||
      old.nodes != nodes ||
      old.positions != positions;
}
