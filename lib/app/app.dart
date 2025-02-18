// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/screens/splash_screen.dart';  // Make sure this path is correct
import 'theme/theme.dart';  // Make sure this path is correct
import 'routes.dart';

class SereniApp extends StatelessWidget {
  const SereniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sereni',
      debugShowCheckedModeBanner: false,  // Remove debug banner
      theme: AppTheme.lightTheme,  // Ensure this theme is correctly defined
      home: const SplashScreen(),
    );
  }
}