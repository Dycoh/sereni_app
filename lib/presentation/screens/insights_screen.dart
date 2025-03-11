// Path: lib/presentation/screens/insights_screen.dart

// Author: Dycoh Gacheri (https://github.com/Dycoh)
// Description: Displays user insights data organized by time periods (day/week/month)
// with triggers, solutions and navigation to detailed reports. Implements responsive
// design patterns for various screen sizes.

// Last Modified: Tuesday, 11 March 2025 16:35

// Core/Framework imports
import 'package:flutter/material.dart';

// Project imports - Theme
import 'package:sereni_app/app/theme.dart';
import '../../app/scaffold.dart';

// Project imports - Routes
import 'package:sereni_app/app/routes.dart';

// Project imports - Layout
import '../../shared/layout/app_layout.dart';
import '../widgets/navigation_widget.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> with SingleTickerProviderStateMixin {
  // State variables
  String selectedPeriod = 'Week';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // Asset paths
  static const String _logoPath = 'assets/logos/sereni_logo.png';
  
  // Configuration parameters
  static const Duration _animationDuration = Duration(milliseconds: 300);
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
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
    return AppScaffold(
      currentRoute: RouteManager.insights,
      title: 'Insights',
      layoutType: LayoutType.contentOnly,
      contentPadding: EdgeInsets.zero,
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline, color: AppTheme.kTextBrown),
          onPressed: () {
            // Show help dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Insights Help'),
                content: const Text(
                  'This screen displays your wellness insights based on your journal entries and interactions. '
                  'You can view triggers and potential solutions for different time periods.'
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _buildInsightsContent(context),
      ),
    );
  }

  Widget _buildInsightsContent(BuildContext context) {
    // Get responsive information
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;
    
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? AppTheme.kSpacing4x : AppTheme.kSpacing2x,
          vertical: AppTheme.kSpacing2x,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Period Selector with improved UI
            Center(
              child: Container(
                width: isDesktop ? screenWidth * 0.3 : double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.kLightGreenContainer,
                  borderRadius: BorderRadius.circular(AppTheme.kRadiusXLarge),
                  boxShadow: AppTheme.kShadowSmall,
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
            
            // Period Title with Mood - Enhanced with animation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  insightsPeriodTitle,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.kTextBrown,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.kSpacing2x,
                    vertical: AppTheme.kSpacing,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.kLightGreenContainer,
                    borderRadius: BorderRadius.circular(AppTheme.kRadiusXLarge),
                    boxShadow: AppTheme.kShadowSmall,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Mood',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: AppTheme.kSpacing),
                      const Icon(Icons.sentiment_satisfied_alt, color: AppTheme.kPrimaryGreen),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.kSpacing2x),
            
            // Insights Summary Card - New element
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.kLightGreenContainer, AppTheme.kPrimaryGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
                boxShadow: AppTheme.kShadowMedium,
              ),
              padding: const EdgeInsets.all(AppTheme.kSpacing2x),
              margin: const EdgeInsets.only(bottom: AppTheme.kSpacing3x),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Summary',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.kWhite,
                      fontWeight: FontWeight.bold,
                    ) ?? Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.kWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.kSpacing),
                  Text(
                    'Your overall wellness has improved by 12% compared to last ${selectedPeriod.toLowerCase()}.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.kWhite,
                    ),
                  ),
                  const SizedBox(height: AppTheme.kSpacing2x),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem(context, '85%', 'Wellness Score'),
                      _buildSummaryItem(context, '72%', 'Sleep Quality'),
                      _buildSummaryItem(context, '68%', 'Stress Level'),
                    ],
                  ),
                ],
              ),
            ),
            
            // Triggers Section with enhanced corners
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.kGray100,
                borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
                boxShadow: AppTheme.kShadowMedium,
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
                          color: AppTheme.kPrimaryGreen,
                          borderRadius: BorderRadius.circular(AppTheme.kRadiusXLarge),
                          boxShadow: AppTheme.kShadowSmall,
                        ),
                        child: Text(
                          'Triggers:',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppTheme.kWhite,
                            fontWeight: FontWeight.bold,
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
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.kTextBrown,
              ),
            ),
            
            const SizedBox(height: AppTheme.kSpacing2x),
            
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.kGray100,
                borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
                boxShadow: AppTheme.kShadowMedium,
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
            
            // Reports Button with navigation to reports screen
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the reports screen
                  Navigator.pushNamed(context, RouteManager.reports);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.kAccentBrown,
                  padding: const EdgeInsets.all(AppTheme.kSpacing2x),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Detailed Reports',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme.kWhite,
                        fontWeight: FontWeight.bold,
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
                _logoPath,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: AppTheme.kSpacing2x),
          ],
        ),
      ),
    );
  }

  // Helper widgets with enhanced styling
  Widget _buildPeriodButton(String period) {
    final isSelected = selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedPeriod = period;
            // Trigger fade animation when period changes
            _animationController.reset();
            _animationController.forward();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.kSpacing,
            vertical: AppTheme.kSpacing,
          ),
          margin: const EdgeInsets.symmetric(horizontal: AppTheme.kSpacing / 2),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.kAccentBrown : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.kRadiusXLarge),
            boxShadow: isSelected ? AppTheme.kShadowSmall : null,
          ),
          child: Text(
            period,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isSelected ? AppTheme.kWhite : AppTheme.kTextBrown,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTriggerItem(BuildContext context, String trigger) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.kSpacing),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.kSpacing2x,
          vertical: AppTheme.kSpacing,
        ),
        decoration: BoxDecoration(
          color: AppTheme.kWhite,
          borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
          boxShadow: AppTheme.kShadowSmall,
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppTheme.kWarningYellow),
            const SizedBox(width: AppTheme.kSpacing),
            Expanded(
              child: Text(
                trigger,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolutionItem(BuildContext context, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.kSpacing2x),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.kSpacing2x),
        decoration: BoxDecoration(
          color: AppTheme.kWhite,
          borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
          boxShadow: AppTheme.kShadowSmall,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.kSpacing / 2),
                  decoration: BoxDecoration(
                    color: AppTheme.kLightGreenContainer,
                    borderRadius: BorderRadius.circular(AppTheme.kRadiusSmall),
                  ),
                  child: const Icon(Icons.lightbulb_outline, color: AppTheme.kPrimaryGreen, size: 20),
                ),
                const SizedBox(width: AppTheme.kSpacing),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.kPrimaryGreen,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.kSpacing),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.kTextBrown,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppTheme.kWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.kSpacing / 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.kWhite,
          ),
        ),
      ],
    );
  }
}