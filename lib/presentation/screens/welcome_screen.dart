//lib/presentation/screens/welcome_Screen.dart

import 'package:flutter/material.dart';
import 'dart:async';
import '../../app/theme.dart';
import 'onboarding_screen.dart';
import '../../presentation/widgets/background_decorator_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  static const String _gifPath = 'assets/gifs/welcome_sereni_bot.gif';
  static const String _logoPath = 'assets/logos/sereni_logo.png';
  static const String _fullTitle = "Hello. I'm Sereni ...";
  static const String _fullSubtitle = "Your dedicated companion for mental wellness. I'm here to help you track your moods, capture your thoughts, and discover useful insights along the way.";
  
  String _currentTitle = '';
  String _currentSubtitle = '';
  bool _titleComplete = false;
  bool _subtitleComplete = false;
  late Timer _titleTimer;
  late Timer _subtitleTimer;
  
  @override
  void initState() {
    super.initState();
    _startTitleAnimation();
  }
  
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
        _startSubtitleAnimation();
      }
    });
  }
  
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
    _titleTimer.cancel();
    if (_titleComplete) {
      _subtitleTimer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.kBackgroundColor,
      body: SafeArea(
        child: BackgroundDecorator(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWideScreen = constraints.maxWidth > 800;
              // Adjust side padding based on screen width
              final sidePadding = constraints.maxWidth * (isWideScreen ? 0.1 : 0.05);
              final gutterWidth = constraints.maxWidth * 0.05; // 5% gutter
              
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: sidePadding),
                child: isWideScreen 
                  ? _buildWideScreenLayout(constraints, gutterWidth)
                  : _buildNarrowScreenLayout(constraints),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWideScreenLayout(BoxConstraints constraints, double gutterWidth) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Center(
            child: SizedBox(
              height: constraints.maxHeight * 0.8,
              width: constraints.maxWidth * 0.4, // 80% of half the screen
              child: Image.asset(
                _gifPath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(width: gutterWidth),
        Expanded(
          flex: 6,
          child: Center(
            child: SizedBox(
              height: constraints.maxHeight * 0.8,
              width: constraints.maxWidth * 0.4, // 80% of half the screen
              child: _buildContentSection(isWideScreen: true),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowScreenLayout(BoxConstraints constraints) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: AppTheme.kSpacing4x),
          SizedBox(
            height: constraints.maxHeight * 0.4,
            width: constraints.maxWidth * 0.8, // 90% of screen width
            child: Image.asset(
              _gifPath,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: AppTheme.kSpacing4x),
          SizedBox(
            width: constraints.maxWidth * 0.8, // 90% of screen width
            child: _buildContentSection(isWideScreen: false),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection({required bool isWideScreen}) {
    return Padding(
      padding: EdgeInsets.only(top: isWideScreen ? AppTheme.kSpacing8x : AppTheme.kSpacing4x),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            
            Container(
              width: 180,
              height: 3,
              decoration: BoxDecoration(
                color: AppTheme.kPrimaryGreen.withOpacity(0.5),
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
            SizedBox(height: AppTheme.kSpacing3x),
            
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

  Widget _buildGetStartedButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: ElevatedButton(
        onPressed: _subtitleComplete ? _handleGetStarted : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.kAccentBrown,
          foregroundColor: AppTheme.kWhite,
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.kSpacing4x,
            vertical: AppTheme.kSpacing2x,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
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

  void _handleGetStarted() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }
}