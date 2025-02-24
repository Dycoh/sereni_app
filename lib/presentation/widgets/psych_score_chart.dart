import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../app/theme.dart';

class PsychScoreChart extends StatelessWidget {
  final int score;
  final double size;
  
  const PsychScoreChart({
    super.key,
    required this.score,
    this.size = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.kSpacing2x),
      decoration: BoxDecoration(
        color: AppTheme.kPrimaryGreen.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dotted circle background
          CustomPaint(
            size: Size(size, size),
            painter: DottedCirclePainter(),
          ),
          // Main score circle
          CustomPaint(
            size: Size(size * 0.8, size * 0.8),
            painter: _CircularScoreIndicator(
              score: score,
              backgroundColor: AppTheme.kPrimaryGreen.withOpacity(0.3),
              foregroundColor: AppTheme.kPrimaryGreen,
            ),
          ),
          // Score text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$score',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.kPrimaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.kSpacing),
              Text(
                'Psych Score',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.kPrimaryGreen,
                ),
              ),
            ],
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

class DottedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppTheme.kPrimaryGreen.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2 - 10;

    // Draw dotted circle
    final Path path = Path();
    for (double i = 0; i < 360; i += 5) {
      final double x1 = centerX + radius * math.cos(i * math.pi / 180);
      final double y1 = centerY + radius * math.sin(i * math.pi / 180);
      final double x2 = centerX + radius * math.cos((i + 2) * math.pi / 180);
      final double y2 = centerY + radius * math.sin((i + 2) * math.pi / 180);
      path.moveTo(x1, y1);
      path.lineTo(x2, y2);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}