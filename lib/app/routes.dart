import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import all screen widgets
import 'splash.dart';
import '../modules/welcome/screen/welcome_screen.dart';
import '../presentation/screens/signup_screen.dart';
import '../presentation/screens/signin_screen.dart';
import '../presentation/screens/onboarding_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/journal_screen.dart';
import '../presentation/screens/chat_screen.dart';
import '../presentation/screens/insights_screen.dart';
import '../presentation/screens/reports_screen.dart';
import '../presentation/screens/profile_screen.dart';

class RouteManager {
  // Route names
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String journal = '/journal';
  static const String chat = '/chat';
  static const String insights = '/insights';
  static const String reports = '/reports';
  static const String profile = '/profile';

  // User state keys
  static const String keyOnboardingComplete = 'onboarding_completed';
  static const String keyDefaultMoodSet = 'default_mood_set';

  /// Navigation items configuration
  static final List<NavigationItem> navigationItems = [
    NavigationItem(
      route: home,
      label: 'Home',
      icon: Icons.home,
    ),
    NavigationItem(
      route: journal,
      label: 'Journal',
      icon: Icons.book,
    ),
    NavigationItem(
      route: chat,
      label: 'AI Chat',
      icon: Icons.chat,
    ),
    NavigationItem(
      route: insights,
      label: 'Insights',
      icon: Icons.insights,
    ),
    NavigationItem(
      route: reports,
      label: 'Reports',
      icon: Icons.assessment,
    ),
    NavigationItem(
      route: profile,
      label: 'Profile',
      icon: Icons.person,
    ),
  ];

  /// Helper method to build welcome screen directly
  static Widget buildWelcomeScreen() {
    return const WelcomeScreen();
  }

  /// Determines the appropriate route based on user state
  static Future<String> determineInitialRoute() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final auth = FirebaseAuth.instance;
      
      // Check if app is being opened for the first time
      final isFirstLaunch = !prefs.containsKey(keyOnboardingComplete);
      if (isFirstLaunch) {
        return welcome;
      }

      // Check authentication state
      final user = auth.currentUser;
      if (user == null) {
        // User is not logged in
        final hasCompletedOnboarding = prefs.getBool(keyOnboardingComplete) ?? false;
        return hasCompletedOnboarding ? signIn : welcome;
      }

      // Check if default mood is set
      final isDefaultMoodSet = prefs.getBool(keyDefaultMoodSet) ?? false;
      if (!isDefaultMoodSet) {
        await _setDefaultMood();
      }

      // All conditions met, go to home
      return home;
    } catch (e) {
      debugPrint('Error determining initial route: $e');
      return welcome;
    }
  }

  /// Sets the default neutral mood for a new user
  static Future<void> _setDefaultMood() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Your mood repository call would go here
      // await MoodRepository.setDefaultMood(userId, 'neutral');
      
      await prefs.setBool(keyDefaultMoodSet, true);
    } catch (e) {
      debugPrint('Error setting default mood: $e');
    }
  }

  /// Navigation helper methods with state management and BuildContext safety
  static Future<void> handlePostAuthNavigation(BuildContext context) async {
    if (!context.mounted) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDefaultMoodSet = prefs.getBool(keyDefaultMoodSet) ?? false;
      
      if (!isDefaultMoodSet) {
        await _setDefaultMood();
      }
      
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, home);
    } catch (e) {
      debugPrint('Error in post-auth navigation: $e');
    }
  }

  static Future<void> handlePostOnboardingNavigation(BuildContext context) async {
    if (!context.mounted) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(keyOnboardingComplete, true);
      
      if (!context.mounted) return;
      
      final auth = FirebaseAuth.instance;
      if (auth.currentUser != null) {
        await handlePostAuthNavigation(context);
      } else {
        Navigator.pushReplacementNamed(context, signIn);
      }
    } catch (e) {
      debugPrint('Error in post-onboarding navigation: $e');
    }
  }

  /// Custom page route transitions
  static PageRoute _buildPageRoute(Widget screen, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => screen,
      settings: settings,
    );
  }

  /// Route generation
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final String routeName = settings.name ?? welcome;
    
    switch (routeName) {
      case splash:
        return _buildPageRoute(const SplashScreen(), settings);
      case welcome:
        return _buildPageRoute(const WelcomeScreen(), settings);
      case signIn:
        return _buildPageRoute(const SignInScreen(), settings);
      case signUp:
        return _buildPageRoute(const SignUpScreen(), settings);
      case onboarding:
        return _buildPageRoute(const OnboardingScreen(), settings);
      case home:
        return _buildPageRoute(const HomeScreen(), settings);
      case journal:
        return _buildPageRoute(const JournalScreen(), settings);
      case chat:
        return _buildPageRoute(const ChatScreen(), settings);
      case insights:
        return _buildPageRoute(const InsightsScreen(), settings);
      case reports:
        return _buildPageRoute(const ReportsScreen(), settings);
      case profile:
        return _buildPageRoute(const ProfileScreen(), settings);
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No route defined for $routeName'),
            ),
          ),
        );
    }
  }
}

/// Navigation item model for the drawer menu
class NavigationItem {
  final String route;
  final String label;
  final IconData icon;

  NavigationItem({
    required this.route,
    required this.label,
    required this.icon,
  });
}

/// Navigation service for managing the drawer
class NavigationService {
  static void navigateToRoute(BuildContext context, String route) {
    // Close the drawer first
    Navigator.pop(context);
    
    // If we're already on this route, don't navigate
    if (ModalRoute.of(context)?.settings.name == route) {
      return;
    }
    
    // Navigate to the selected route
    Navigator.pushReplacementNamed(context, route);
  }

  static Future<void> handleLogout(BuildContext context) async {
    // Close the drawer first
    Navigator.pop(context);
    
    try {
      await FirebaseAuth.instance.signOut();
      
      // Check if context is still valid
      if (!context.mounted) return;
      
      // Clear preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      // Check context again before navigation
      if (!context.mounted) return;
      
      // Navigate to sign in screen
      Navigator.pushReplacementNamed(context, RouteManager.signIn);
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }
}

/// Mood management helper
class MoodManager {
  static Future<void> updateMoodFromJournal(String userId, String journalContent) async {
    try {
      // Here you would:
      // 1. Run sentiment analysis on the journal content
      // 2. Update the user's mood based on the analysis
      // 3. Store the updated mood in your database
      
      // Example pseudo-code:
      // final sentiment = await SentimentAnalyzer.analyze(journalContent);
      // await MoodRepository.updateMood(userId, sentiment);
    } catch (e) {
      debugPrint('Error updating mood from journal: $e');
    }
  }

  static Future<void> updateMoodFromChat(String userId, String chatContent) async {
    try {
      // Similar to journal content analysis
      // Would analyze chat content and update mood accordingly
    } catch (e) {
      debugPrint('Error updating mood from chat: $e');
    }
  }
}