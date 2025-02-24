// Path: lib/shared/layout/app_navigation.dart

// Author: Dycoh Gacheri (https://github.com/Dycoh)
// Description: Handles all navigation-related widgets and functionality.
// Provides both drawer and bottom navigation components for consistent
// navigation experience across the app.

// Last Modified: Monday, 24 February 2025 16:35

// Core/Framework imports
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// Project imports - Theme and Routes
import '../../app/theme.dart';
import '../../app/routes.dart' hide NavigationService;

// Project imports - Services
import '../../services/navigation_service.dart';

/// Handles all navigation-related widgets and functionality.
/// Provides both drawer and bottom navigation components.
class AppNavigation {
  // Asset paths
  static const String _appTagline = 'Mindful Digital Journey';
  static const String _appLogoPath = 'assets/logos/sereni_logo.png';
  
  // UI configuration constants
  static const double _appLogoHeight = 32.0;
  static const double _drawerItemVerticalPadding = 4.0;
  static const double _drawerItemHorizontalPadding = 8.0;
  static const double _drawerItemBorderRadius = 50.0;
  static const double _logoutButtonMinHeight = 48.0;
  
  /// Builds the navigation drawer for larger screens
  ///
  /// @param context The BuildContext for the drawer
  /// @param currentRoute The current active route
  /// @param onClose Callback function when the drawer is closed
  /// @param drawerWidth The width to set for the drawer
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
  ///
  /// @param context The BuildContext for the navigation bar
  /// @param currentRoute The current active route
  static Widget buildBottomNav({
    required BuildContext context,
    required String currentRoute,
  }) {
    // Primary navigation destinations for bottom nav
    final navigationItems = [
      RouteManager.home,
      RouteManager.journal,
      RouteManager.insights,
      RouteManager.profile,
    ];

    // Find the selected index, defaulting to 0 if not found
    final int selectedIndex = navigationItems.contains(currentRoute)
        ? navigationItems.indexOf(currentRoute)
        : 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26), // Replaced withOpacity(0.1)
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
            tabBackgroundColor: AppTheme.kPrimaryGreen.withAlpha(77), // Replaced withOpacity(0.3)
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.edit_note, text: 'Journal'),
              GButton(icon: Icons.insights, text: 'Insights'),
              GButton(icon: Icons.person_outline, text: 'Profile'),
            ],
            selectedIndex: selectedIndex,
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

  /// Builds the drawer header with title and close button
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

  /// Builds the app tagline section in the drawer
  static Widget _buildTagline(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        _appTagline,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppTheme.kTextGreen,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  /// Builds the navigation items list in the drawer
  static Widget _buildNavigationItems(BuildContext context, String currentRoute) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Directly spread the mapped items without unnecessary toList()
        ...RouteManager.navigationItems.map((item) {
          final isSelected = currentRoute == item.route;
          return _buildDrawerItem(
            context: context,
            icon: item.icon,
            label: item.label,
            route: item.route,
            isSelected: isSelected,
          );
        }),
        const SizedBox(height: 16),
        // App Logo
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Image.asset(
            _appLogoPath,
            height: _appLogoHeight,
          ),
        ),
      ],
    );
  }

  /// Builds a single navigation item for the drawer
  ///
  /// @param context The BuildContext for the item
  /// @param icon The icon to display
  /// @param label The text label
  /// @param route The route to navigate to when tapped
  /// @param isSelected Whether this item is currently selected
  static Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: _drawerItemHorizontalPadding,
        vertical: _drawerItemVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.kLightGreenContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(_drawerItemBorderRadius),
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
        onTap: () {
          // Close drawer first
          Navigator.pop(context);
          // Then navigate to the selected route
          NavigationService.navigateToRoute(context, route);
        },
      ),
    );
  }

  /// Builds the logout button at the bottom of the drawer
  static Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () async {
          // Close drawer first
          Navigator.pop(context);
          // Then handle logout
          await NavigationService.handleLogout(context);
        },
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
            borderRadius: BorderRadius.circular(_drawerItemBorderRadius),
          ),
          minimumSize: const Size(double.infinity, _logoutButtonMinHeight),
        ),
      ),
    );
  }
}