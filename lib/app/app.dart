// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/screens/splash_screen.dart';  // Updated import
import 'theme/theme.dart';

class SereniApp extends StatelessWidget {
  const SereniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sereni',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),  // Updated class name
    );
  }
}