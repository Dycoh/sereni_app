import 'package:flutter/material.dart';

// Import your screens
import '../presentation/screens/splash_screen.dart';
import '../presentation/screens/signup_screen.dart';
import '../presentation/screens/signin_screen.dart';
import '../presentation/screens/onboarding_screen.dart';
import '../presentation/screens/home_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String signup = '/signup';
  static const String signin = '/signin';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case signin:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}