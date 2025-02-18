import 'package:flutter/material.dart';
import '../../app/theme/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.kBackgroundColor,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: AppTheme.kPrimaryGreen,
        foregroundColor: AppTheme.kWhite,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: AppTheme.kPrimaryGreen,
              size: 80,
            ),
            const SizedBox(height: AppTheme.kSpacing2x),
            Text(
              'Welcome to Sereni',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.kTextGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.kSpacing),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.kSpacing4x),
              child: Text(
                'Your mental health journey begins here.',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}