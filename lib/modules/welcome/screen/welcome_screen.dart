// Path: lib/presentation/screens/welcome_screen.dart

// Author: Dycoh Gacheri (https://github.com/Dycoh)
// Description: Welcome screen that displays an introduction to Sereni with animated text
// and transitions to the onboarding flow. Uses standardized AppScaffold for consistent
// layout structure while maintaining responsive behavior.

// Last Modified: Monday, 24 February 2025 16:35

// Core/Framework imports
import 'package:flutter/material.dart';
import 'dart:async';

// Project imports - Theme
import '../../../app/theme.dart';

// Project imports - Navigation
import '../../../presentation/screens/onboarding_screen.dart';

// Project imports - Layout
import '../../../app/scaffold.dart';
import '../../../shared/layout/app_layout.dart'; // Import for LayoutType enum

/// Welcome screen that displays an animated introduction to Sereni
/// with a typewriter text effect and responsive layout.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // Asset paths
  static const String _gifPath = 'assets/gifs/welcome_sereni_bot.gif';
  static const String _logoPath = 'assets/logos/sereni_logo.png';
  
  // Content constants
  static const String _fullTitle = "Hello. I'm Sereni ...";
  static const String _fullSubtitle = "Your dedicated companion for mental wellness. I'm here to help you track your moods, capture your thoughts, and discover useful insights along the way.";
  
  // Animation state variables
  String _currentTitle = '';
  String _currentSubtitle = '';
  // ignore: unused_field
  bool _titleComplete = false;
  bool _subtitleComplete = false;
  
  // Animation controller
  // ignore: unused_field
  late AnimationController _titleAnimationController;
  // ignore: unused_field
  late AnimationController _subtitleAnimationController;
  
  // Configuration parameters
  static const double _breakpoint = 800.0;
  
  // Improved animation speeds (doubled)
  static const Duration _titleTypingInterval = Duration(milliseconds: 25); // from 50ms
  static const Duration _subtitleTypingInterval = Duration(milliseconds: 10); // from 20ms
  
  @override
  void initState() {
    super.initState();
    // Start the typewriter animation for the title
    _startTitleAnimation();
  }
  
  /// Animates the title text letter by letter with a typewriter effect
  /// Using a more efficient implementation with fewer setState calls
  void _startTitleAnimation() {
    int charIndex = 0;
    Timer.periodic(_titleTypingInterval, (timer) {
      charIndex++;
      if (charIndex <= _fullTitle.length) {
        setState(() {
          _currentTitle = _fullTitle.substring(0, charIndex);
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
  /// Using batch updates to improve efficiency
  void _startSubtitleAnimation() {
    int charIndex = 0;
    // Calculate characters to add per frame for smoother animation
    const int charsPerFrame = 2; // Add 2 characters per frame for efficiency
    
    Timer.periodic(_subtitleTypingInterval, (timer) {
      charIndex += charsPerFrame;
      if (charIndex <= _fullSubtitle.length) {
        setState(() {
          _currentSubtitle = _fullSubtitle.substring(0, charIndex);
        });
      } else {
        // Ensure we display the complete text
        if (_currentSubtitle.length < _fullSubtitle.length) {
          setState(() {
            _currentSubtitle = _fullSubtitle;
          });
        }
        timer.cancel();
        setState(() {
          _subtitleComplete = true;
        });
      }
    });
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: '/', // Root route for welcome screen
      useBackgroundDecorator: true,
      backgroundColor: AppTheme.kBackgroundColor,
      showNavigation: false, // No navigation needed for welcome screen
      // No app bar needed for welcome screen
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(),
      ),
      // Using splitVertical layout with gif on left, content on right
      layoutType: LayoutType.splitVertical,
      breakpoint: _breakpoint,
      // Let the AppLayoutManager handle the content width fraction
      // based on screen size (0.9 for mobile, 0.8 for desktop)
      contentPadding: const EdgeInsets.all(16),
      // The main body content will appear on the right side on wide screens
      body: _buildContentSection(),
      // The panels array contains the left content (gif)
      panels: [_buildGifSection()],
    );
  }

  /// Builds the animated GIF section that appears on the left (wide screens)
  /// or top (narrow screens)
  Widget _buildGifSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 400),
            padding: const EdgeInsets.all(AppTheme.kSpacing4x),
            child: Image.asset(
              _gifPath,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

  /// Builds the main content section with title, subtitle, and button
  Widget _buildContentSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Check if we're in a wide screen layout
        final isWideScreen = constraints.maxWidth > _breakpoint / 2;
        
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.kSpacing4x),
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
                const SizedBox(height: AppTheme.kSpacing4x),
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
              const SizedBox(height: AppTheme.kSpacing2x),
              
              // Decorative divider line
              Container(
                width: 180,
                height: 3,
                decoration: BoxDecoration(
                  color: AppTheme.kPrimaryGreen.withAlpha(128),
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
              const SizedBox(height: AppTheme.kSpacing3x),
              
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
              const SizedBox(height: AppTheme.kSpacing6x),
              
              // Button that fades in after subtitle animation completes
              AnimatedOpacity(
                opacity: _subtitleComplete ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: _buildGetStartedButton(),
              ),
              const SizedBox(height: AppTheme.kSpacing4x),
            ],
          ),
        );
      },
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
          padding: const EdgeInsets.symmetric(
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
          // Fix: Use Wrap instead of Row to prevent overflow
          child: Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const [
              Text('Get Started'),
              Icon(Icons.arrow_forward, size: 18, color: AppTheme.kWhite),
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