import 'package:flutter/material.dart';
import '../../app/theme.dart';
// import 'onboarding_screen.dart';
// import 'signin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linearToEaseOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.kBackgroundColor,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Animated rotating circle
                AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(160, 160),
                      painter: CircleStrokePainter(
                        progress: _rotationAnimation.value,
                        color: AppTheme.kPrimaryGreen,
                      ),
                    );
                  },
                ),
                // Centered logo
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Image.asset(
                    'assets/logos/sereni_logo.png',
                    width: 32,
                    height: 32,
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

class CircleStrokePainter extends CustomPainter {
  final double progress;
  final Color color;

  CircleStrokePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 4.0;
    
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final startAngle = -0.5 * 3.14159; // Start from top
    final sweepAngle = progress * 2 * 3.14159; // Full circle based on progress
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircleStrokePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}