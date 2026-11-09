import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Circular progress track. Purely presentational: [progress] is derived
/// from the engine's remaining time; the ring is never used as a clock.
class PhaseRing extends StatelessWidget {
  const PhaseRing({
    super.key,
    required this.progress,
    required this.color,
    required this.child,
  });

  /// 0 = phase just started, 1 = phase complete.
  final double progress;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _RingPainter(
      progress: progress.clamp(0, 1),
      color: color,
      track: Theme.of(context).colorScheme.surfaceContainerHighest,
    ),
    child: child,
  );
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.color,
    required this.track,
  });

  final double progress;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.shortestSide * 0.06;
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: (size.shortestSide - stroke) / 2,
    );
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, math.pi * 2, false, base..color = track);
    final remaining = 1 - progress;
    if (remaining > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2,
        math.pi * 2 * remaining,
        false,
        base..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color || old.track != track;
}
