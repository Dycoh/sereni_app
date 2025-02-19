// lib/widgets/psych_score/psych_score_chart.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../app/theme/theme.dart';

class PsychScoreChart extends StatelessWidget {
  final int score;
  final double size;

  const PsychScoreChart({
    super.key,
    required this.score,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.kSpacing2x),
      decoration: BoxDecoration(
        color: AppTheme.kPrimaryGreen,
        borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Psych Score',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: AppTheme.kSpacing),
          CustomPaint(
            size: Size(size, size),
            painter: _CircularScoreIndicator(
              score: score,
              backgroundColor: Colors.white.withOpacity(0.3),
              foregroundColor: Colors.white,
            ),
            child: Center(
              child: Text(
                '$score',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularScoreIndicator extends CustomPainter {
  final int score;
  final Color backgroundColor;
  final Color foregroundColor;

  _CircularScoreIndicator({
    required this.score,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = size.width * 0.1;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    // Score arc
    final scorePaint = Paint()
      ..color = foregroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final scoreAngle = 2 * math.pi * (score / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2, // Start from top
      scoreAngle,
      false,
      scorePaint,
    );
  }

  @override
  bool shouldRepaint(_CircularScoreIndicator oldDelegate) =>
      oldDelegate.score != score;
}
