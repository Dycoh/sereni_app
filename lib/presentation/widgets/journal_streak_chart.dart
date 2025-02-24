import 'package:flutter/material.dart';
import '../../app/theme.dart';

class JournalStreakChart extends StatefulWidget {
  const JournalStreakChart({super.key});

  @override
  State<JournalStreakChart> createState() => _JournalStreakChartState();
}

class _JournalStreakChartState extends State<JournalStreakChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Placeholder data
  final List<int> weeklyData = [65, 80, 45, 90, 75, 60, 85];
  final List<int> monthlyData = [
    65, 80, 45, 90, 75, 60, 85, 70, 55, 95, 
    80, 65, 70, 85, 90, 75, 60, 80, 85, 70,
    75, 90, 85, 65, 70, 80, 75, 85, 90, 95
  ];
  final List<String> weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];  // Shortened day labels
  final List<String> monthDays = List.generate(30, (index) => '${index + 1}');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final data = isSmallScreen ? weeklyData : monthlyData;
    final labels = isSmallScreen ? weekDays : monthDays;

    return Container(
      padding: const EdgeInsets.all(AppTheme.kSpacing2x),
      decoration: BoxDecoration(
        color: AppTheme.kAccentBrown,
        borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Journal Streak',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
              Text(
                isSmallScreen ? 'This Week' : 'This Month',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.white.withOpacity(0.7)),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.kSpacing2x),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                data.length,
                (index) {
                  final double maxHeight = 60;
                  final double height = (data[index] / 100) * maxHeight;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 4.0 : 2.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Container(
                                height: height * _animation.value,
                                width: isSmallScreen ? 10 : 8, // Thinner bars
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4), // Completely rounded edges
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 4),
                          Text(
                            labels[index],
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: isSmallScreen ? 10 : 8,
                                ),
                          ),
                        ],
                      ),
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