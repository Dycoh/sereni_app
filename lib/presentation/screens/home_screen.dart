import 'package:flutter/material.dart';
import 'package:sereni_app/presentation/screens/chat_screen.dart';
import 'package:sereni_app/presentation/screens/insights_screen.dart';
import 'package:sereni_app/presentation/screens/journal_screen.dart';
import 'package:sereni_app/presentation/screens/profile_screen.dart';
import '../../app/theme.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../widgets/psych_score_chart.dart';
import '../widgets/mood_selector.dart';
import '../widgets/journal_streak_chart.dart';
import '../widgets/insights_carousel.dart';
import '../widgets/navigation_widget.dart';
import '../../app/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _colorController;
  late Animation<Color?> _colorTween1;
  late Animation<Color?> _colorTween2;
  late Animation<Color?> _colorTween3;
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
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _colorTween1 = ColorTween(
      begin: Colors.purple,
      end: Colors.blue,
    ).animate(
      CurvedAnimation(
        parent: _colorController,
        curve: const Interval(0.0, 0.33, curve: Curves.easeInOut),
      ),
    );

    _colorTween2 = ColorTween(
      begin: Colors.blue,
      end: Colors.green,
    ).animate(
      CurvedAnimation(
        parent: _colorController,
        curve: const Interval(0.33, 0.66, curve: Curves.easeInOut),
      ),
    );

    _colorTween3 = ColorTween(
      begin: Colors.green,
      end: Colors.purple,
    ).animate(
      CurvedAnimation(
        parent: _colorController,
        curve: const Interval(0.66, 1.0, curve: Curves.easeInOut),
      ),
    );

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
    final screenHeight = MediaQuery.of(context).size.height;
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

    return CustomScaffold(
      currentRoute: RouteManager.home,
      backgroundColor: AppTheme.kBackgroundColor,
      title: null,
      actions: [
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Handle menu action
          },
        ),
      ],
      body: Stack(
        children: [
          SingleChildScrollView(
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
                        width: 64,
                        height: 64,
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
                            'Sarah Mitchell', // Placeholder name
                            style: Theme.of(context).textTheme.displayMedium,
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
                              height: 64,
                              child: MoodSelector(),
                            ),
                            const SizedBox(height: AppTheme.kSpacing2x),
                            // Journal Streak Container (larger)
                            const SizedBox(
                              height: 144,
                              child: JournalStreakChart(),
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
                  // Add extra padding at bottom for FAB
                  SizedBox(height: isSmallScreen ? 100 : 80),
                ],
              ),
            ),
          ),
          // Positioned FAB
          Positioned(
            bottom: isSmallScreen 
                ? screenHeight * 0.02  // 2% from bottom for small screens
                : screenHeight * 0.05, // 5% from bottom for larger screens
            left: 0,
            right: 0,
            child: Center(
              child: MouseRegion(
                onEnter: (_) => _fillController.forward(),
                onExit: (_) => _fillController.reverse(),
                child: AnimatedBuilder(
                  animation: Listenable.merge([_colorTween1, _colorTween2, _colorTween3, _fillAnimation]),
                  builder: (context, child) {
                    return Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            _colorTween1.value ?? Colors.purple,
                            _colorTween2.value ?? Colors.blue,
                            _colorTween3.value ?? Colors.green,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: FloatingActionButton(
                        onPressed: () {
                          _showActionDialog(context);
                        },
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
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
            ),
          ),
        ],
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

  void _showActionDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final dialogWidth = isSmallScreen 
        ? screenWidth * 0.8 
        : screenWidth * 0.6; // 60% of screen for wider displays
        
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppTheme.kBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
        ),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.kSpacing3x),
          width: dialogWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sereni Logo
              Image.asset(
                'assets/logos/sereni_logo.png',
                height: 48,
              ),
              const SizedBox(height: AppTheme.kSpacing3x),
              
              // Creative Title
              Text(
                'AI Mind Sanctuary',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              // Witty Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.kSpacing2x,
                  horizontal: AppTheme.kSpacing,
                ),
                child: Text(
                  'Choose your AI-powered wellness path — express your thoughts or have a mindful conversation',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.kGray600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: AppTheme.kSpacing3x),
              
              // Journal Button with Animated Outline
              AnimatedBuilder(
                animation: _colorController,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      gradient: LinearGradient(
                        colors: [
                          _colorTween1.value ?? Colors.purple,
                          _colorTween2.value ?? Colors.blue,
                          _colorTween3.value ?? Colors.green,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      // Create padding for the border
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.kBackgroundColor,
                          spreadRadius: -4,
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const JournalScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.kBackgroundColor,
                        foregroundColor: AppTheme.kAccentBrown,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.kSpacing3x,
                          vertical: AppTheme.kSpacing2x,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(48.0),
                        ),
                        minimumSize: const Size(double.infinity, 60),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_note,
                            color: AppTheme.kAccentBrown,
                          ),
                          const SizedBox(width: AppTheme.kSpacing),
                          Text(
                            isSmallScreen ? 'Journal' : 'Express Your Thoughts',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: AppTheme.kSpacing2x),
              
              // Chat Button with Animated Gradient Fill
              AnimatedBuilder(
                animation: _colorController,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      gradient: LinearGradient(
                        colors: [
                          _colorTween1.value ?? Colors.purple,
                          _colorTween2.value ?? Colors.blue,
                          _colorTween3.value ?? Colors.green,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChatScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.kSpacing3x,
                          vertical: AppTheme.kSpacing2x,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(48.0),
                        ),
                        minimumSize: const Size(double.infinity, 60),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                          ),
                          const SizedBox(width: AppTheme.kSpacing),
                          Text(
                            isSmallScreen ? 'Chat' : 'Talk With AI',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}