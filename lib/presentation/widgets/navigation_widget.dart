// lib/presentation/widgets/navigation_widget.dart

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../app/theme/theme.dart';
import '../../app/routes.dart';

class CustomScaffold extends StatefulWidget {
  final Widget body;
  final String currentRoute;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;  // Add this line

  const CustomScaffold({
    Key? key,
    required this.body,
    required this.currentRoute,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.appBar,  // Add this line
  }) : super(key: key);

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: widget.backgroundColor ?? AppTheme.kBackgroundColor,
      appBar: widget.appBar ?? PreferredSize(  // Modify this line
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: AppBar(
            leading: null,
            actions: [
              ...(widget.actions ?? []),
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
              ),
            ],
            title: widget.title != null ? Text(
              widget.title!,
              style: Theme.of(context).textTheme.titleLarge,
            ) : null,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      endDrawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        child: _CustomDrawer(
          currentRoute: widget.currentRoute,
          onClose: () => _scaffoldKey.currentState?.closeEndDrawer(),
        ),
      ),
      body: widget.body,
      bottomNavigationBar: isSmallScreen ? _BottomNavBar(
        currentRoute: widget.currentRoute,
      ) : null,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
    );
  }
}

class _CustomDrawer extends StatelessWidget {
  final String currentRoute;
  final VoidCallback onClose;

  const _CustomDrawer({
    Key? key,
    required this.currentRoute,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.kBackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
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
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Mindful Digital Journey',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.kTextGreen,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const Divider(),
            // Navigation Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ...RouteManager.navigationItems.map((item) {
                    final isSelected = currentRoute == item.route;
                    return _buildDrawerItem(
                      context,
                      item.icon,
                      item.label,
                      item.route,
                      isSelected,
                    );
                  }).toList(),
                  const SizedBox(height: 16),
                  // Sereni Logo after navigation items
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Image.asset(
                      'assets/logos/sereni_logo.png',
                      height: 32,
                    ),
                  ),
                ],
              ),
            ),
            // Logout Button
            Padding(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String label,
    String route,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.kLightGreenContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(50), // Completely rounded edges
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
}

class _BottomNavBar extends StatelessWidget {
  final String currentRoute;

  const _BottomNavBar({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}