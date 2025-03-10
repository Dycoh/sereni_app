// Path: lib/presentation/screens/home_screen.dart

// Author: Dycoh Gacheri (https://github.com/Dycoh)
// Description: Home screen that displays user overview, mood tracking, 
// journal streaks, and AI insights. Uses the app's standardized layout system for consistency.

// Last Modified: Monday, 10 March 2025 16:35

// Core/Framework imports
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// Project imports - Layout
import '../../shared/layout/app_layout.dart';
import '../../app/scaffold.dart';

// Project imports - Theme
import '../../app/theme.dart';
import '../../app/routes.dart';

// Project imports - Screens
import 'package:sereni_app/presentation/screens/chat_screen.dart';
import 'package:sereni_app/presentation/screens/journal_screen.dart';

// Project imports - Widgets
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
  // Asset paths
  static const String _profileImagePlaceholder = 'assets/images/placeholder_profile.png';
  static const String _sereniLogoPath = 'assets/logos/sereni_logo.png';
  
  // Animation controllers
  late AnimationController _colorController;
  late Animation<Color?> _colorTween1;
  late Animation<Color?> _colorTween2;
  late Animation<Color?> _colorTween3;
  late AnimationController _fillController;
  late Animation<double> _fillAnimation;
  
  // Typing animation
  late AnimationController _typeController;
  late Animation<int> _typeAnimation;
  final String _subtitle = "Your daily dose of AI-powered mental wellness insights";
  
  // Profile image
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Color animation for gradient effects
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

    // Fill animation for hover effects
    _fillController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fillAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_fillController);

    // Typing animation for subtitle
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
    return AppScaffold(
      currentRoute: RouteManager.home,
      backgroundColor: AppTheme.kBackgroundColor,
      title: null,
      layoutType: LayoutType.contentOnly,
      // Use the standard layout system's contentWidthFraction instead of manual padding
      contentPadding: const EdgeInsets.all(AppTheme.kSpacing2x),
      body: Stack(
        children: [
          _buildHomeContent(),
          // Position AI button at fixed position from bottom
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.05, // 5% from bottom
            left: 0,
            right: 0,
            child: _buildAIFab(context),
          ),
        ],
      ),
      // Remove the default FAB since we're using a custom positioned one
      floatingActionButton: null,
    );
  }

  Widget _buildHomeContent() {
    // Placeholder data for insights widget
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppTheme.kSpacing3x),
          // Greeting Section
          _buildGreetingSection(),
          const SizedBox(height: AppTheme.kSpacing3x),
          
          // Main Content Grid
          _buildMainContentGrid(),
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
          
          // AI Insights Section - Make height adaptive
          SizedBox(
            height: 200,
            child: InsightsCarousel(
              insights: insights,
              autoPlay: true,
              animationDuration: const Duration(milliseconds: 500),
            ),
          ),
          // Add extra padding at bottom to account for fixed FAB position
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        ],
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Row(
      children: [
        GestureDetector(
          onTap: _selectProfileImage,
          child: Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppTheme.kGray300,
                  shape: BoxShape.circle,
                  image: _profileImage != null
                    ? DecorationImage(
                        image: FileImage(_profileImage!),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: AssetImage(_profileImagePlaceholder),
                        fit: BoxFit.cover,
                      ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.kAccentBrown,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppTheme.kSpacing2x),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'Sconl', // Placeholder name
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainContentGrid() {
    // Get screen width to make layout responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    // Use Column for small screens, Row for larger screens
    if (isSmallScreen) {
      return Column(
        children: [
          // PsychScore (full width on small screens)
          const SizedBox(
            height: 224,
            child: PsychScoreChart(score: 85),
          ),
          const SizedBox(height: AppTheme.kSpacing2x),
          // Mood Selector
          const SizedBox(
            height: 64,
            child: MoodSelector(),
          ),
          const SizedBox(height: AppTheme.kSpacing2x),
          // Journal Streak Chart
          const SizedBox(
            height: 144,
            child: JournalStreakChart(),
          ),
        ],
      );
    } else {
      // Original Row layout for larger screens
      return Row(
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
      );
    }
  }

  Widget _buildAIFab(BuildContext context) {
    final buttonSize = MediaQuery.of(context).size.width < 600 ? 50.0 : 60.0;
    
    return Center(
      child: MouseRegion(
        onEnter: (_) => _fillController.forward(),
        onExit: (_) => _fillController.reverse(),
        child: AnimatedBuilder(
          animation: Listenable.merge([_colorTween1, _colorTween2, _colorTween3, _fillAnimation]),
          builder: (context, child) {
            return Container(
              height: buttonSize,
              width: buttonSize,
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
                // Add shadow for better visibility
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _showActionDialog(context);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: Text(
                      'AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: buttonSize * 0.4,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
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

  Future<void> _selectProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
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
                _sereniLogoPath,
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