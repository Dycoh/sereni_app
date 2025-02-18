import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../presentation/screens/splash_screen.dart';
import '../presentation/screens/welcome_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // First determine the initial route
      final initialRoute = await RouteManager.determineInitialRoute();
      debugPrint('Initial route determined: $initialRoute');
      
      // Wait for 5 seconds regardless of initialization status
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

    // Ensure we have a valid route to start with
    final String initialRoute = _initialRoute ?? RouteManager.welcome;

    return MaterialApp(
      title: 'Sereni',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _buildInitialScreen(initialRoute),
      onGenerateRoute: RouteManager.generateRoute,
    );
  }

  Widget _buildInitialScreen(String route) {
    switch (route) {
      case RouteManager.welcome:
        return const WelcomeScreen();
      // You can add other cases here if needed
      default:
        return const WelcomeScreen();
    }
  }
}