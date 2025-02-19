import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../presentation/screens/splash_screen.dart';
import '../presentation/screens/welcome_screen.dart';
import '../presentation/screens/home_screen.dart';

import 'theme/theme.dart';
import 'routes.dart';

class SereniApp extends StatefulWidget {
  const SereniApp({super.key});

  @override
  State<SereniApp> createState() => _SereniAppState();
}

class _SereniAppState extends State<SereniApp> {
  String? _initialRoute;
  bool _isInitialized = false;

  /// Temporary debug override for testing a specific screen.
  /// Set this to a route like `RouteManager.home` when testing.
  /// Change back to `null` to restore normal onboarding behavior.
  static const String? debugOverrideRoute = RouteManager.home; // Change this for temporary testing

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Determine the initial route dynamically
      final initialRoute = await RouteManager.determineInitialRoute();
      debugPrint('Initial route determined: $initialRoute');

      // Simulate a splash delay (5 seconds)
      await Future.delayed(const Duration(seconds: 5));

      if (mounted) {
        setState(() {
          _initialRoute = initialRoute;
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing app: $e');

      // Still wait for the full 5 seconds even if there's an error
      await Future.delayed(const Duration(seconds: 5));

      if (mounted) {
        setState(() {
          _initialRoute = RouteManager.welcome;
          _isInitialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building app with _isInitialized: $_isInitialized, _initialRoute: $_initialRoute');

    // Show splash screen while initializing
    if (!_isInitialized) {
      return MaterialApp(
        title: 'Sereni',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      );
    }

    /// If `debugOverrideRoute` is set, use it instead of the normal flow.
    final String initialRoute = debugOverrideRoute ?? _initialRoute ?? RouteManager.welcome;

    return MaterialApp(
      title: 'Sereni',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _buildInitialScreen(initialRoute),
      onGenerateRoute: RouteManager.generateRoute,
    );
  }

  /// Builds the initial screen based on the determined route.
  Widget _buildInitialScreen(String route) {
    switch (route) {
      case RouteManager.welcome:
        return const WelcomeScreen();
      case RouteManager.home:
        return const HomeScreen(); // Example: Add other screens as needed
      default:
        return const WelcomeScreen();
    }
  }
}
