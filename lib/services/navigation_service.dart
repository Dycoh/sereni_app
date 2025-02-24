// Path: lib/services/navigation_service.dart

// Author: Dycoh Gacheri (https://github.com/Dycoh)
// Description: Service for handling navigation throughout the app.
// Provides consistent navigation methods and handles special cases 
// like authentication flows.

// Last Modified: Monday, 24 February 2025 16:35

// Core/Framework imports
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports - Routes
import '../app/routes.dart';

/// Service for handling navigation throughout the app.
/// Provides consistent navigation methods and handles special cases.
class NavigationService {
  /// Navigates to the specified route, replacing the current screen
  static void navigateToRoute(BuildContext context, String route) {
    // If we're already on this route, don't navigate
    if (ModalRoute.of(context)?.settings.name == route) {
      return;
    }
    
    Navigator.pushReplacementNamed(context, route);
  }
  
  /// Handles user logout process
  static Future<void> handleLogout(BuildContext context) async {
    try {
      // Sign out from Firebase Auth
      await FirebaseAuth.instance.signOut();
      
      // Check if context is still valid
      if (!context.mounted) return;
      
      // Clear user preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      // Check context again before navigation
      if (!context.mounted) return;
      
      // Navigate to sign in screen, removing all previous routes
      Navigator.pushNamedAndRemoveUntil(
        context, 
        RouteManager.signIn, // Using signIn instead of login
        (route) => false, // Remove all previous routes
      );
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }
  
  /// Handles navigation after successful authentication
  static Future<void> handlePostAuthNavigation(BuildContext context) async {
    if (!context.mounted) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDefaultMoodSet = prefs.getBool(RouteManager.keyDefaultMoodSet) ?? false;
      
      if (!isDefaultMoodSet) {
        // Set default mood if not already set
        await _setDefaultMood();
      }
      
      if (!context.mounted) return;
      navigateToRoute(context, RouteManager.home);
    } catch (e) {
      debugPrint('Error in post-auth navigation: $e');
    }
  }
  
  /// Sets the default neutral mood for a new user
  static Future<void> _setDefaultMood() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Your mood repository call would go here
      // await MoodRepository.setDefaultMood(userId, 'neutral');
      
      await prefs.setBool(RouteManager.keyDefaultMoodSet, true);
    } catch (e) {
      debugPrint('Error setting default mood: $e');
    }
  }
}