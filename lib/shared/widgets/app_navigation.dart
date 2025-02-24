// lib/shared/widgets/app_navigation.dart

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../services/navigation_service.dart';

/// Handles all navigation-related widgets and functionality.
/// Provides both drawer and bottom navigation components.
class AppNavigation {
  /// Builds the navigation drawer for larger screens
  static Widget buildDrawer({
    required BuildContext context,
    required String currentRoute,
    required VoidCallback onClose,
    required double drawerWidth,
  }) {
    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        backgroundColor: AppTheme.kBackgroundColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drawer Header
              _buildDrawerHeader(context, onClose),
              const Divider(),
              
              // App Tagline
              _buildTagline(context),
              const Divider(),
              
              // Navigation Items List
              Expanded(
                child: _buildNavigationItems(context, currentRoute),
              ),
              
              // Logout Button
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the bottom navigation bar for mobile screens
  static Widget buildBottomNav({
    required BuildContext context,
    required String currentRoute,
  }) {
    final navigationItems = [
      RouteManager.home,
      RouteManager.journal,
      RouteManager.insights,
      RouteManager.profile,
    ];

    return Container(
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
            backgroundColor: AppTheme.kPrimaryGreen,
            activeColor: AppTheme.kWhite,
            color: AppTheme.kWhite,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.kSpacing2x,
              vertical: AppTheme.kSpacing,
            ),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: AppTheme.kPrimaryGreen.withOpacity(0.3),
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.edit_note, text: 'Journal'),
              GButton(icon: Icons.insights, text: 'Insights'),
              GButton(icon: Icons.person_outline, text: 'Profile'),
            ],
            selectedIndex: navigationItems.indexOf(currentRoute),
            onTabChange: (index) {
              final newRoute = navigationItems[index];
              if (newRoute != currentRoute) {
                Navigator.pushReplacementNamed(context, newRoute);
              }
            },
          ),
        ),
      ),
    );
  }

  // Private helper methods for drawer components

  static Widget _buildDrawerHeader(BuildContext context, VoidCallback onClose) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Menu',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }

  static Widget _buildTagline(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        'Mindful Digital Journey',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppTheme.kTextGreen,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  static Widget _buildNavigationItems(BuildContext context, String currentRoute) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        ...RouteManager.navigationItems.map((item) {
          final isSelected = currentRoute == item.route;
          return _buildDrawerItem(
            context: context,
            icon: item.icon,
            label: item.label,
            route: item.route,
            isSelected: isSelected,
          );
        }).toList(),
        const SizedBox(height: 16),
        // App Logo
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Image.asset(
            'assets/logos/sereni_logo.png',
            height: 32,
          ),
        ),
      ],
    );
  }

  static Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.kLightGreenContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(50),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? AppTheme.kPrimaryGreen : AppTheme.kTextGreen,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.kPrimaryGreen : AppTheme.kTextGreen,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () => NavigationService.navigateToRoute(context, route),
      ),
    );
  }

  static Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () => NavigationService.handleLogout(context),
        icon: Icon(
          Icons.logout,
          color: AppTheme.kWhite,
        ),
        label: Text(
          'Log Out',
          style: TextStyle(color: AppTheme.kWhite),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.kAccentBrown,
          foregroundColor: AppTheme.kWhite,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.kSpacing3x,
            vertical: AppTheme.kSpacing2x,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
    );
  }
}