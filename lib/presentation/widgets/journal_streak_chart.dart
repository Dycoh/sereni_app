// lib/widgets/journal/journal_streak_chart.dart
import 'package:flutter/material.dart';
import '../../app/theme/theme.dart';

class JournalStreakChart extends StatelessWidget {
  final List<int> weeklyEntries;

  const JournalStreakChart({
    super.key,
    required this.weeklyEntries,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.kSpacing2x),
      decoration: BoxDecoration(
        color: AppTheme.kAccentBrown,
        borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Journal Streak',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppTheme.kSpacing2x),
          SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                weeklyEntries.length,
                (index) {
                  final double height =
                      (weeklyEntries[index] / 100) * 50; // Max height is 50
                  return Container(
                    width: 40,
                    height: height,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(AppTheme.kRadiusSmall),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}