// lib/presentation/screens/splash/splash_screen.dart
import 'package:flutter/material.dart';
import '../../../app/theme/theme.dart';
import 'onboarding_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _checkAuthStatus();
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

    _animationController.forward();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;
    
    final bool isFirstTime = true; // Replace with actual first-time check
    final bool isLoggedIn = false; // Replace with actual auth check
    
    if (isFirstTime) {
      _navigateToOnboarding();
    } else if (!isLoggedIn) {
      _navigateToLogin();
    } else {
      _navigateToHome();
    }
  }

  void _navigateToOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _navigateToHome() {
    // TODO: Implement home navigation
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.kPrimaryGreen.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.psychology_outlined,
                    size: 60,
                    color: AppTheme.kPrimaryGreen,
                  ),
                ),
                SizedBox(height: AppTheme.kSpacing3x),
                Text(
                  'Sereni',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppTheme.kTextGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppTheme.kSpacing),
                Text(
                  'Your Mental Wellness Companion',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.kTextGreen.withOpacity(0.7),
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