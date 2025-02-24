import 'package:flutter/material.dart';
import '../../app/theme.dart';

class MoodSelector extends StatelessWidget {
  const MoodSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.kSpacing3x,
        vertical: AppTheme.kSpacing2x,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
      ),
      child: Row(
        children: [
          Text(
            'Mood',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppTheme.kTextBrown,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            '😊', // Placeholder mood emoji
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ],
      ),
    );
  }
}