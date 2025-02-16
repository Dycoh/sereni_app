import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme/theme.dart';

class SereniApp extends StatelessWidget {
  const SereniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sereni',
      theme: AppTheme.lightTheme,
      home: const MySplashScreen(), // Replace 'SplashScreen' with the name of your custom SplashScreen class
    );
  }
}