import 'package:flutter/material.dart';
import 'package:sereni_app/app/theme/theme.dart';
import 'package:sereni_app/app/app.dart';
import 'package:sereni_app/app/routes.dart';


class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  String selectedPeriod = 'Week';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.kBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Insights',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.kSpacing2x),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time Period Selector
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.kLightGreenContainer,
                  borderRadius: BorderRadius.circular(AppTheme.kRadiusXLarge),
                ),
                padding: const EdgeInsets.all(AppTheme.kSpacing),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPeriodButton('Day'),
                    _buildPeriodButton('Week'),
                    _buildPeriodButton('Monthly'),
                  ],
                ),
              ),
              
              const SizedBox(height: AppTheme.kSpacing3x),
              
              // Day Insights Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Day Insights',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.kSpacing2x,
                      vertical: AppTheme.kSpacing,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.kLightGreenContainer,
                      borderRadius: BorderRadius.circular(AppTheme.kRadiusXLarge),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Mood',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: AppTheme.kSpacing),
                        const Icon(Icons.sentiment_satisfied_alt, color: AppTheme.kPrimaryGreen),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.kSpacing2x),
              
              // Triggers Section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.kGray100,
                  borderRadius: BorderRadius.circular(AppTheme.kRadiusMedium),
                ),
                padding: const EdgeInsets.all(AppTheme.kSpacing2x),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.kSpacing2x,
                            vertical: AppTheme.kSpacing,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(AppTheme.kRadiusXLarge),
                          ),
                          child: Text(
                            'Triggers:',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppTheme.kWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.kSpacing2x),
                    // Trigger items would be listed here
                    _buildTriggerItem(context, 'Work Deadlines'),
                    _buildTriggerItem(context, 'Lack of Sleep'),
                  ],
                ),
              ),
              
              const SizedBox(height: AppTheme.kSpacing3x),
              
              // Solutions Section
              Text(
                'Possible solutions',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              
              const SizedBox(height: AppTheme.kSpacing2x),
              
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.kGray100,
                  borderRadius: BorderRadius.circular(AppTheme.kRadiusMedium),
                ),
                padding: const EdgeInsets.all(AppTheme.kSpacing2x),
                child: Column(
                  children: [
                    _buildSolutionItem(
                      context,
                      'Time Management',
                      'Break down tasks into smaller, manageable chunks',
                    ),
                    _buildSolutionItem(
                      context,
                      'Sleep Hygiene',
                      'Establish a consistent sleep schedule and bedtime routine',
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppTheme.kSpacing3x),
              
              // Reports Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.kAccentBrown,
                    padding: const EdgeInsets.all(AppTheme.kSpacing2x),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Reports',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppTheme.kWhite,
                        ),
                      ),
                      const SizedBox(width: AppTheme.kSpacing),
                      const Icon(Icons.arrow_forward, color: AppTheme.kWhite),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Insights tab
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    final isSelected = selectedPeriod == period;
    return GestureDetector(
      onTap: () => setState(() => selectedPeriod = period),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.kSpacing2x,
          vertical: AppTheme.kSpacing,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.kAccentBrown : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.kRadiusXLarge),
        ),
        child: Text(
          period,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isSelected ? AppTheme.kWhite : AppTheme.kTextBrown,
          ),
        ),
      ),
    );
  }

  Widget _buildTriggerItem(BuildContext context, String trigger) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.kSpacing),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppTheme.kWarningYellow),
          const SizedBox(width: AppTheme.kSpacing),
          Text(
            trigger,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildSolutionItem(BuildContext context, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.kSpacing2x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: AppTheme.kPrimaryGreen),
              const SizedBox(width: AppTheme.kSpacing),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: AppTheme.kSpacing4x),
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}