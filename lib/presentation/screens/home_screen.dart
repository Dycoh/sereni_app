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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;
  late AnimationController _fillController;
  late Animation<double> _fillAnimation;
  
  // Typing animation text
  late AnimationController _typeController;
  late Animation<int> _typeAnimation;
  final String _subtitle = "Your daily dose of AI-powered mental wellness insights";

  @override
  void initState() {
    super.initState();
    _colorController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _colorAnimation = ColorTween(
      begin: AppTheme.kAccentBrown,
      end: AppTheme.kPrimaryGreen,
    ).animate(_colorController);

    _fillController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fillAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_fillController);

    _typeController = AnimationController(
      duration: Duration(milliseconds: _subtitle.length * 100),
      vsync: this,
    )..repeat(reverse: true);

    _typeAnimation = IntTween(
      begin: 0,
      end: _subtitle.length,
    ).animate(_typeController);
  }

  @override
  void dispose() {
    _colorController.dispose();
    _fillController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 600 ? 0.05 : 0.1;
    final isSmallScreen = screenWidth < 600;

    // Placeholder data for widgets
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
                padding: const EdgeInsets.all(6.0),
                child: Image.asset(
                  'assets/logos/sereni_logo.png',
                  height: 35,
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
                  const Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 224,
                      child: PsychScoreChart(score: 85),
                    ),
                  ),
                  const SizedBox(width: AppTheme.kSpacing2x),
                  // Right Column - Mood and Journal with Golden Ratio
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        // Mood Container (smaller)
                        const SizedBox(
                          height: 64, // Approximately 1/φ of total height
                          child: MoodSelector(),
                        ),
                        const SizedBox(height: AppTheme.kSpacing2x),
                        // Journal Streak Container (larger)
                        const SizedBox(
                          height: 144, // Remaining space
                          child: JournalStreakChart(
                            weeklyEntries: [60, 80, 40, 90, 70],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.kSpacing3x),
              
              // AI Insights Header
              Text(
                'AI Insights ✨',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: AppTheme.kSpacing),
              // Animated subtitle
              AnimatedBuilder(
                animation: _typeAnimation,
                builder: (context, child) {
                  return Text(
                    _subtitle.substring(0, _typeAnimation.value),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.kGray600,
                        ),
                  );
                },
              ),
              const SizedBox(height: AppTheme.kSpacing2x),
              
              // AI Insights Section
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
      ),
      floatingActionButton: MouseRegion(
        onEnter: (_) => _fillController.forward(),
        onExit: (_) => _fillController.reverse(),
        child: AnimatedBuilder(
          animation: Listenable.merge([_colorAnimation, _fillAnimation]),
          builder: (context, child) {
            return Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    _colorAnimation.value ?? AppTheme.kAccentBrown,
                    AppTheme.kPrimaryGreen,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, _fillAnimation.value],
                ),
              ),
              child: FloatingActionButton(
                onPressed: () {
                  _showActionButtons(context);
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
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
      bottomNavigationBar: isSmallScreen ? Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
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
              tabBackgroundColor: AppTheme.kPrimaryGreen.withAlpha(26),
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
      ) : null,
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