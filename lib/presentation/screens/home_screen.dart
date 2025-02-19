import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sereni_app/presentation/screens/chat_screen.dart';
import 'package:sereni_app/presentation/screens/insights_screen.dart';
import 'package:sereni_app/presentation/screens/journal_screen.dart';
import 'package:sereni_app/presentation/screens/profile_screen.dart';
import '../../app/theme/theme.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../widgets/psych_score_chart.dart';
import '../widgets/mood_selector.dart';
import '../widgets/journal_streak_chart.dart';
import '../widgets/insights_carousel.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 600 ? 0.05 : 0.1;

    // Placeholder data
    final psychScore = 85;
    final currentMood = '😊';
    final insights = [
      const InsightCard(
        title: 'Mood Analysis',
        content: 'Your mood has been consistently positive this week!',
        icon: Icons.mood,
      ),
      const InsightCard(
        title: 'Journal Progress',
        content: 'You\'ve maintained a great journaling streak!',
        icon: Icons.edit,
      ),
      const InsightCard(
        title: 'Chat Insights',
        content: 'Recent conversations show improved emotional awareness.',
        icon: Icons.chat,
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.kBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * horizontalPadding,
            ),
            child: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/logos/sereni_logo.png',
                  height: 30,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    // Handle menu action
                  },
                ),
              ],
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppTheme.kSpacing3x),
              // Greeting Section
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.kGray300,
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/placeholder_profile.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.kSpacing2x),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        'John Doe',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.kSpacing3x),
              
              // Main Content Grid
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column - PsychScore
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 200,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.kPrimaryGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(150, 150),
                            painter: DottedCirclePainter(),
                          ),
                          PsychScoreChart(score: psychScore),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.kSpacing2x),
                  // Right Column - Mood and Journal
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        // Mood Container
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Mood',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.emoji_emotions_outlined),
                                ],
                              ),
                              MoodSelector(
                                currentMood: currentMood,
                                onMoodSelected: (mood) {
                                  // Handle mood selection
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppTheme.kSpacing2x),
                        // Journal Streak Container
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.kAccentBrown.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Journal Streak',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.edit_calendar),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 60,
                                child: JournalStreakChart(
                                  weeklyEntries: [60, 80, 40, 90, 70],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.kSpacing2x),
              // AI Insights Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'AI Insights',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.psychology),
                      ],
                    ),
                    const SizedBox(height: AppTheme.kSpacing2x),
                    SizedBox(
                      height: 200,
                      child: InsightsCarousel(
                        insights: insights,
                        autoPlay: true,
                        animationDuration: const Duration(milliseconds: 500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: TweenAnimationBuilder(
          tween: ColorTween(
            begin: AppTheme.kAccentBrown,
            end: AppTheme.kAccentBrown.withRed(150),
          ),
          duration: const Duration(seconds: 2),
          builder: (context, color, child) {
            return Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.kAccentBrown,
                    AppTheme.kAccentBrown.withRed(150),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: FloatingActionButton(
                onPressed: () {
                  _showActionButtons(context);
                },
                backgroundColor: Colors.transparent,
                elevation: 4,
                child: const Text(
                  'AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.kSpacing2x,
              vertical: AppTheme.kSpacing,
            ),
            child: GNav(
              gap: 8,
              activeColor: AppTheme.kPrimaryGreen,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.kSpacing2x,
                vertical: AppTheme.kSpacing,
              ),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: AppTheme.kPrimaryGreen.withOpacity(0.1),
              color: AppTheme.kGray400,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.edit_note,
                  text: 'Journal',
                ),
                GButton(
                  icon: Icons.insights,
                  text: 'Insights',
                ),
                GButton(
                  icon: Icons.person_outline,
                  text: 'Profile',
                ),
              ],
              selectedIndex: 0,
              onTabChange: (index) {
                switch (index) {
                  case 0:
                    // Already on home
                    break;
                  case 1:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const JournalScreen()),
                    );
                    break;
                  case 2:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const InsightsScreen()),
                    );
                    break;
                  case 3:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfileScreen()),
                    );
                    break;
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  void _showActionButtons(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.kSpacing3x),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const JournalScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.kAccentBrown,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.kSpacing3x,
                    vertical: AppTheme.kSpacing2x,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    side: const BorderSide(
                      color: AppTheme.kAccentBrown,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.edit_note),
                    const SizedBox(width: AppTheme.kSpacing),
                    Text(
                      'Journal',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppTheme.kSpacing2x),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.kAccentBrown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.kSpacing3x,
                    vertical: AppTheme.kSpacing2x,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.chat_bubble_outline),
                    const SizedBox(width: AppTheme.kSpacing),
                    Text(
                      'Chat',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.kRadiusLarge),
        ),
      ),
    );
  }
}

// Custom painter for dotted circle
// Custom painter for dotted circle
class DottedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2 - 10;

    // Draw dotted circle
    final Path path = Path();
    for (double i = 0; i < 360; i += 5) {
      final double x1 = centerX + radius * cos(i * pi / 180);
      final double y1 = centerY + radius * sin(i * pi / 180);
      final double x2 = centerX + radius * cos((i + 2) * pi / 180);
      final double y2 = centerY + radius * sin((i + 2) * pi / 180);
      path.moveTo(x1, y1);
      path.lineTo(x2, y2);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}