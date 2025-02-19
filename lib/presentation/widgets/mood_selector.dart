// lib/widgets/mood/mood_selector.dart
import 'package:flutter/material.dart';
import '../../app/theme/theme.dart';

class MoodSelector extends StatelessWidget {
  final String currentMood;
  final Function(String) onMoodSelected;

  const MoodSelector({
    super.key,
    required this.currentMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.kSpacing2x),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.kSpacing2x),
          Center(
            child: Text(
              currentMood,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
        ],
      ),
    );
  }
}