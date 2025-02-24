// lib/presentation/widgets/app_scaffold.dart

import 'package:flutter/material.dart';
import '../../app/theme.dart';
import 'app_navigation.dart';
import 'app_background.dart';

/// A customizable scaffold widget that provides a consistent layout structure across the app.
/// Handles responsive behavior, navigation, and background decoration.
class AppScaffold extends StatefulWidget {
  // Core properties
  final Widget body;              // Main content of the screen
  final String currentRoute;      // Current route for navigation highlighting
  final String? title;           // Screen title
  
  // Optional customization properties
  final List<Widget>? actions;    // Additional app bar actions
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;   // Override default background color
  final PreferredSizeWidget? appBar;  // Custom app bar
  final bool useBackgroundDecorator;  // Toggle background decoration
  final EdgeInsetsGeometry? padding;   // Custom padding for body content

  const AppScaffold({
    Key? key,
    required this.body,
    required this.currentRoute,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.appBar,
    this.useBackgroundDecorator = true,
    this.padding,
  }) : super(key: key);

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  // Key for accessing scaffold state (e.g., for drawer operations)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive layout
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    // Calculate content width based on screen size
    // Mobile: 90% of screen width
    // Desktop: 80% of screen width
    final contentWidth = isSmallScreen ? screenSize.width * 0.9 : screenSize.width * 0.8;

    // Build main content with responsive width
    Widget mainContent = Center(
      child: SizedBox(
        width: contentWidth,
        child: widget.body,
      ),
    );

    // Apply custom padding if specified
    if (widget.padding != null) {
      mainContent = Padding(
        padding: widget.padding!,
        child: mainContent,
      );
    }

    // Apply background decoration if enabled
    if (widget.useBackgroundDecorator) {
      mainContent = AppBackground(child: mainContent);
    }

    // Construct the scaffold with all components
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: widget.backgroundColor ?? AppTheme.kBackgroundColor,
      appBar: widget.appBar ?? _buildDefaultAppBar(context, isSmallScreen),
      endDrawer: !isSmallScreen ? AppNavigation.buildDrawer(
        context: context,
        currentRoute: widget.currentRoute,
        onClose: () => _scaffoldKey.currentState?.closeEndDrawer(),
        drawerWidth: screenSize.width * 0.25,
      ) : null,
      body: mainContent,
      bottomNavigationBar: isSmallScreen ? AppNavigation.buildBottomNav(
        context: context,
        currentRoute: widget.currentRoute,
      ) : null,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
    );
  }

  /// Builds the default app bar if no custom app bar is provided
  PreferredSizeWidget _buildDefaultAppBar(BuildContext context, bool isSmallScreen) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: SafeArea(
        child: AppBar(
          leading: null,
          actions: [
            ...(widget.actions ?? []),
            if (!isSmallScreen) IconButton(
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
    );
  }
}