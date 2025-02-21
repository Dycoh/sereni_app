import 'package:flutter/material.dart';
import 'package:sereni_app/app/theme/theme.dart';
import 'package:sereni_app/app/routes.dart';
import 'package:sereni_app/presentation/widgets/navigation_widget.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  String selectedPeriod = 'Week';
  
  String get insightsPeriodTitle {
    switch (selectedPeriod) {
      case 'Day':
        return 'Day Insights';
      case 'Week':
        return 'Weekly Insights';
        case 'Monthly':
        return 'Monthly Insights';
      default:
        return 'Insights';
    }
  }

  // Sample data structure - replace with your actual data model
  Map<String, Map<String, dynamic>> periodData = {
    'Day': {
      'triggers': ['Work Deadlines', 'Lack of Sleep'],
      'solutions': [
        {'title': 'Time Management', 'description': 'Break down tasks into smaller, manageable chunks'},
        {'title': 'Sleep Hygiene', 'description': 'Establish a consistent sleep schedule'}
      ]
    },
    'Week': {
      'triggers': ['Social Media Overuse', 'Irregular Exercise', 'Work Stress'],
      'solutions': [
        {'title': 'Digital Wellbeing', 'description': 'Set daily app usage limits and take regular breaks'},
        {'title': 'Exercise Routine', 'description': 'Schedule regular workout sessions'}
      ]
    },
    'Monthly': {
      'triggers': ['Financial Stress', 'Family Responsibilities', 'Career Goals'],
      'solutions': [
        {'title': 'Budget Planning', 'description': 'Create a monthly budget and tracking system'},
        {'title': 'Work-Life Balance', 'description': 'Set boundaries and prioritize personal time'}
      ]
    }
  };

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return CustomScaffold(
      currentRoute: RouteManager.insights,
      title: 'Insights',
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isDesktop ? AppTheme.kSpacing4x : AppTheme.kSpacing2x),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time Period Selector - Responsive width
              Center(
                child: Container(
                  width: isDesktop ? screenWidth * 0.3 : double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.kLightGreenContainer,
                    borderRadius: BorderRadius.circular(AppTheme.kRadiusXLarge),
                  ),
                  padding: const EdgeInsets.all(AppTheme.kSpacing),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPeriodButton('Day'),
                      _buildPeriodButton('Week'),
                      _buildPeriodButton('Monthly'),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: AppTheme.kSpacing3x),
              
              // Period Title with Mood
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    insightsPeriodTitle,
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
              
              // Triggers Section with enhanced corners
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.kGray100,
                  borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
                  boxShadow: AppTheme.kShadowSmall,
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
                    ...periodData[selectedPeriod]!['triggers'].map((trigger) => 
                      _buildTriggerItem(context, trigger)
                    ).toList(),
                  ],
                ),
              ),
              
              const SizedBox(height: AppTheme.kSpacing3x),
              
              // Solutions Section with enhanced corners
              Text(
                'Possible solutions',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              
              const SizedBox(height: AppTheme.kSpacing2x),
              
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.kGray100,
                  borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
                  boxShadow: AppTheme.kShadowSmall,
                ),
                padding: const EdgeInsets.all(AppTheme.kSpacing2x),
                child: Column(
                  children: [
                    ...periodData[selectedPeriod]!['solutions'].map((solution) => 
                      _buildSolutionItem(
                        context,
                        solution['title'],
                        solution['description'],
                      )
                    ).toList(),
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

              // Sereni Logo
              const SizedBox(height: AppTheme.kSpacing4x),
              Center(
                child: Image.asset(
                  'assets/logos/sereni_logo.png',
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: AppTheme.kSpacing2x),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    final isSelected = selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedPeriod = period),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.kSpacing,
            vertical: AppTheme.kSpacing,
          ),
          margin: const EdgeInsets.symmetric(horizontal: AppTheme.kSpacing / 2),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.kAccentBrown : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.kRadiusXLarge),
          ),
          child: Text(
            period,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isSelected ? AppTheme.kWhite : AppTheme.kTextBrown,
            ),
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