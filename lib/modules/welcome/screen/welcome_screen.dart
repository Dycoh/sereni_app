//lib/presentation/screens/welcome_Screen.dart

import 'package:flutter/material.dart';
import 'dart:async';
import '../../../app/theme.dart';
import '../../../presentation/screens/onboarding_screen.dart';
import '../../../app/scaffold.dart'; // Import the AppScaffold

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // Asset paths for images and content
  static const String _gifPath = 'assets/gifs/welcome_sereni_bot.gif';
  static const String _logoPath = 'assets/logos/sereni_logo.png';
  static const String _fullTitle = "Hello. I'm Sereni ...";
  static const String _fullSubtitle = "Your dedicated companion for mental wellness. I'm here to help you track your moods, capture your thoughts, and discover useful insights along the way.";
  
  // Animation state variables
  String _currentTitle = '';
  String _currentSubtitle = '';
  bool _titleComplete = false;
  bool _subtitleComplete = false;
  late Timer _titleTimer;
  late Timer _subtitleTimer;
  
  @override
  void initState() {
    super.initState();
    // Start the typewriter animation for the title
    _startTitleAnimation();
  }
  
  /// Animates the title text letter by letter with a typewriter effect
  void _startTitleAnimation() {
    _titleTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_currentTitle.length < _fullTitle.length) {
        setState(() {
          _currentTitle = _fullTitle.substring(0, _currentTitle.length + 1);
        });
      } else {
        timer.cancel();
        setState(() {
          _titleComplete = true;
        });
        // Once title animation completes, start subtitle animation
        _startSubtitleAnimation();
      }
    });
  }
  
  /// Animates the subtitle text letter by letter with a typewriter effect
  /// Runs faster than the title animation for better user experience
  void _startSubtitleAnimation() {
    _subtitleTimer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (_currentSubtitle.length < _fullSubtitle.length) {
        setState(() {
          _currentSubtitle = _fullSubtitle.substring(0, _currentSubtitle.length + 1);
        });
      } else {
        timer.cancel();
        setState(() {
          _subtitleComplete = true;
        });
      }
    });
  }
  
  @override
  void dispose() {
    // Clean up timers to prevent memory leaks
    _titleTimer.cancel();
    if (_titleComplete) {
      _subtitleTimer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use AppScaffold instead of custom Scaffold implementation
    return AppScaffold(
      // No title needed for welcome screen
      currentRoute: '/', // Assuming welcome screen is the root route
      useBackgroundDecorator: true, // Use the background decoration from AppScaffold
      backgroundColor: AppTheme.kBackgroundColor,
      // No app bar needed for welcome screen
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), // Zero height app bar
        child: Container(), // Empty container as we don't need an app bar
      ),
      // Main body content with responsive layout
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWideScreen = constraints.maxWidth > 800;
            
            return isWideScreen 
              ? _buildWideScreenLayout(constraints)
              : _buildNarrowScreenLayout(constraints);
          },
        ),
      ),
    );
  }

  /// Builds a side-by-side layout for wider screens (tablets, desktops)
  /// Places the animation gif on the left and content on the right
  Widget _buildWideScreenLayout(BoxConstraints constraints) {
    // Calculate appropriate spacing for wide layout
    final sidePadding = constraints.maxWidth * 0.1; // 10% padding on sides
    final gutterWidth = constraints.maxWidth * 0.05; // 5% gutter between columns
    
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Center(
            child: SizedBox(
              height: constraints.maxHeight * 0.8,
              width: constraints.maxWidth * 0.4, // 40% of screen width for image
              child: Image.asset(
                _gifPath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(width: gutterWidth), // Gutter space between columns
        Expanded(
          flex: 6,
          child: Center(
            child: SizedBox(
              height: constraints.maxHeight * 0.8,
              width: constraints.maxWidth * 0.4, // 40% of screen width for content
              child: _buildContentSection(isWideScreen: true),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a stacked layout for narrower screens (mobile devices)
  /// Places the animation gif above the content
  Widget _buildNarrowScreenLayout(BoxConstraints constraints) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: AppTheme.kSpacing4x), // Top spacing
          SizedBox(
            height: constraints.maxHeight * 0.4,
            width: constraints.maxWidth * 0.8, // 80% of screen width
            child: Image.asset(
              _gifPath,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: AppTheme.kSpacing4x), // Spacing between image and content
          SizedBox(
            width: constraints.maxWidth * 0.8, // 80% of screen width
            child: _buildContentSection(isWideScreen: false),
          ),
        ],
      ),
    );
  }

  /// Builds the main content section with title, subtitle, and button
  /// Adapts layout based on screen size
  Widget _buildContentSection({required bool isWideScreen}) {
    return Padding(
      padding: EdgeInsets.only(top: isWideScreen ? AppTheme.kSpacing8x : AppTheme.kSpacing4x),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Only show logo on wide screens
            if (isWideScreen) ...[
              SizedBox(
                height: 48,
                child: Image.asset(
                  _logoPath,
                  fit: BoxFit.contain,
                  alignment: Alignment.centerLeft,
                ),
              ),
              SizedBox(height: AppTheme.kSpacing4x),
            ],
            
            // Animated title text with typewriter effect
            Text(
              _currentTitle,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: AppTheme.kTextBrown,
                fontWeight: FontWeight.w800,
                fontSize: 48,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: AppTheme.kSpacing2x),
            
            // Decorative divider line
            Container(
              width: 180,
              height: 3,
              decoration: BoxDecoration(
                color: AppTheme.kPrimaryGreen.withOpacity(0.5),
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
            SizedBox(height: AppTheme.kSpacing3x),
            
            // Animated subtitle text with typewriter effect
            Text(
              _currentSubtitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.kTextBrown,
                fontWeight: FontWeight.w300,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: AppTheme.kSpacing6x),
            
            // Button that fades in after subtitle animation completes
            AnimatedOpacity(
              opacity: _subtitleComplete ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: _buildGetStartedButton(),
            ),
            SizedBox(height: AppTheme.kSpacing4x),
          ],
        ),
      ),
    );
  }

  /// Builds the "Get Started" button with proper styling and icon
  /// Button is disabled until the subtitle animation completes
  Widget _buildGetStartedButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: ElevatedButton(
        onPressed: _subtitleComplete ? _handleGetStarted : null, // Only enabled when animations complete
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.kAccentBrown,
          foregroundColor: AppTheme.kWhite,
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.kSpacing4x,
            vertical: AppTheme.kSpacing2x,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0), // Pill-shaped button
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.kSpacing,
            vertical: AppTheme.kSpacing,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Get Started'),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 18, color: AppTheme.kWhite),
            ],
          ),
        ),
      ),
    );
  }

  /// Handles the "Get Started" button press
  /// Navigates to the onboarding screen, replacing the current route
  void _handleGetStarted() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }
}