// Path: lib/app/scaffold.dart

// Author: Dycoh Gacheri (https://github.com/Dycoh)
// Description: A customizable scaffold widget that provides a consistent layout structure 
// across the app. This component handles responsive layouts, theme adaptation, and 
// standardized navigation elements.

// Last Modified: Monday, 24 February 2025 16:35

// Core/Framework imports
import 'package:flutter/material.dart';

// Project imports - Theme
import '../../app/theme.dart';

// Project imports - Layout
import '../shared/layout/app_layout.dart';
import '../shared/layout/app_background.dart';

// Project imports - UI Components
import '../shared/layout/app_navigation.dart';


// IMPORTANT: Always import '../shared/layout/app_layout.dart' when using AppScaffold to access LayoutType enum


/// A customizable scaffold widget that provides a consistent layout structure across the app.
/// Handles responsive behavior, navigation, and background decoration.
class AppScaffold extends StatefulWidget {
  // Core properties
  final Widget body;                  // Main content of the screen
  final String currentRoute;          // Current route for navigation highlighting
  final String? title;                // Screen title
  
  // Layout properties
  final LayoutType layoutType;        // Type of layout to use
  final List<Widget>? panels;         // Additional panels for split layouts
  final Widget? sidebar;              // Optional sidebar content
  final SidebarPosition sidebarPosition; // Position of sidebar (left/right)
  final Widget? header;               // Optional header for contentWithHeader layout
  final EdgeInsetsGeometry contentPadding; // Padding for main content
  final double breakpoint;            // Custom breakpoint for responsive layouts
  final double contentWidthFraction;  // Width of centered content as fraction of screen
  
  // Navigation & UI elements
  final List<Widget>? actions;        // Additional app bar actions
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final PreferredSizeWidget? appBar;  // Custom app bar
  final Color? backgroundColor;       // Override default background color
  final bool showNavigation;          // Toggle for whether to show navigation elements
  final bool useBackgroundDecorator;  // Toggle background decoration

  /// Creates an AppScaffold for consistent layout across the app.
  /// 
  /// The [body] and [currentRoute] parameters are required.
  /// [layoutType] determines the responsive layout pattern to use.
  /// Additional parameters allow customizing appearance and behavior.
  const AppScaffold({
    super.key,
    required this.body,
    required this.currentRoute,
    this.title,
    this.layoutType = LayoutType.contentOnly,
    this.panels,
    this.sidebar,
    this.sidebarPosition = SidebarPosition.left,
    this.header,
    this.contentPadding = const EdgeInsets.all(16),
    this.actions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.appBar,
    this.backgroundColor,
    this.showNavigation = true,
    this.useBackgroundDecorator = true,
    this.breakpoint = 600,
    this.contentWidthFraction = 0.8,
  });

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
    final isSmallScreen = screenSize.width < widget.breakpoint;

    // Apply background decoration if enabled - moved outside LayoutBuilder to cover entire screen
    Widget backgroundContent = LayoutBuilder(
      builder: (context, constraints) {
        // Use the AppLayoutManager to build the appropriate layout
        final mainContent = AppLayoutManager.buildLayout(
          context: context,
          layoutType: widget.layoutType,
          body: widget.body,
          constraints: constraints,
          panels: widget.panels,
          sidebar: widget.sidebar,
          sidebarPosition: widget.sidebarPosition,
          header: widget.header,
          contentPadding: widget.contentPadding,
          useBackgroundDecorator: false, // Set to false since we're handling it at the Scaffold level
          breakpoint: widget.breakpoint,
          contentWidthFraction: widget.contentWidthFraction,
        );

        return mainContent;
      },
    );

    // Construct the scaffold with all components
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: widget.backgroundColor ?? AppTheme.kBackgroundColor,
      appBar: widget.appBar ?? _buildDefaultAppBar(context, isSmallScreen),
      endDrawer: !isSmallScreen && widget.showNavigation ? AppNavigation.buildDrawer(
        context: context,
        currentRoute: widget.currentRoute,
        onClose: () => _scaffoldKey.currentState?.closeEndDrawer(),
        drawerWidth: screenSize.width * 0.25,
      ) : null,
      // Apply background decorator at Scaffold level
      body: widget.useBackgroundDecorator 
          ? AppBackground(child: SafeArea(child: backgroundContent))
          : SafeArea(child: backgroundContent),
      bottomNavigationBar: isSmallScreen && widget.showNavigation ? AppNavigation.buildBottomNav(
        context: context,
        currentRoute: widget.currentRoute,
      ) : null,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      resizeToAvoidBottomInset: true, // Ensures keyboard doesn't cause overflow
    );
  }

  /// Builds the default app bar if no custom app bar is provided
  PreferredSizeWidget _buildDefaultAppBar(BuildContext context, bool isSmallScreen) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: SafeArea(
        child: AppBar(
          leading: null,
          title: widget.title != null ? Text(
            widget.title!,
            style: Theme.of(context).textTheme.titleLarge,
          ) : null,
          actions: [
            ...(widget.actions ?? []),
            if (widget.showNavigation && !isSmallScreen) IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
    );
  }
}