// Path: lib/shared/layout/app_layout.dart

// Author: Dycoh Gacheri (https://github.com/Dycoh)
// Description: Defines layout types and provides layout building functionality
// for responsive UI patterns across the app. This component centralizes
// layout logic to maintain consistency and reduce duplication.

// Last Modified: Monday, 24 February 2025 16:35

// Core/Framework imports
import 'package:flutter/material.dart';

// Project imports - UI Components
import 'app_background.dart';

/// Defines the various layout patterns available throughout the app
enum LayoutType {
  /// Just centers content with appropriate width
  contentOnly,
  
  /// Creates a side-by-side layout for wide screens, stacked for narrow
  splitVertical,
  
  /// Creates a top-bottom split layout
  splitHorizontal,
  
  /// Main content with optional sidebar (left or right)
  contentWithSidebar,
  
  /// Content with a prominent header section
  contentWithHeader,
  
  /// Grid-based layout for dashboard interfaces
  dashboard,
}

/// Defines the position of the sidebar relative to the main content
enum SidebarPosition {
  /// Sidebar appears on the left side of main content
  left,
  
  /// Sidebar appears on the right side of main content
  right,
}

/// Manages the creation and configuration of different layout patterns
/// throughout the app. This class centralizes responsive layout logic to
/// maintain consistency across screens.
class AppLayoutManager {
  // Configuration constants
  static const double defaultBreakpoint = 600.0;
  static const double mobileContentWidthFraction = 1;
  static const double desktopContentWidthFraction = 0.8;
  
  /// Builds the appropriate layout based on layout type and constraints
  static Widget buildLayout({
    required BuildContext context,
    required LayoutType layoutType,
    required Widget body,
    required BoxConstraints constraints,
    List<Widget>? panels,
    Widget? sidebar,
    SidebarPosition sidebarPosition = SidebarPosition.left,
    Widget? header,
    EdgeInsetsGeometry contentPadding = const EdgeInsets.all(16),
    bool useBackgroundDecorator = true,
    double breakpoint = defaultBreakpoint,
    double contentWidthFraction = desktopContentWidthFraction,
  }) {
    final isSmallScreen = constraints.maxWidth < breakpoint;
    final effectiveContentWidthFraction = isSmallScreen 
        ? mobileContentWidthFraction 
        : contentWidthFraction;
    
    // Apply content padding
    Widget content = Padding(
      padding: contentPadding,
      child: body,
    );
    
    // Apply background decorator if enabled (moved to Scaffold level)
    if (useBackgroundDecorator) {
      content = AppBackground(child: content);
    }
    
    // Apply the appropriate layout pattern based on layoutType
    Widget layoutContent;
    switch (layoutType) {
      case LayoutType.contentOnly:
        layoutContent = _buildCenteredContent(
          content, 
          constraints, 
          effectiveContentWidthFraction
        );
        break;
        
      case LayoutType.splitVertical:
        if (panels == null || panels.isEmpty) {
          layoutContent = _buildCenteredContent(
            content, 
            constraints, 
            effectiveContentWidthFraction
          );
        } else {
          Widget splitContent = isSmallScreen
            ? _buildVerticalStack(content, panels, constraints)
            : _buildHorizontalSplit(content, panels, constraints);
            
          // Apply width constraints to the whole split layout
          layoutContent = Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth * effectiveContentWidthFraction,
              ),
              child: splitContent,
            ),
          );
        }
        break;
        
      case LayoutType.splitHorizontal:
        if (panels == null || panels.isEmpty) {
          layoutContent = _buildCenteredContent(
            content, 
            constraints, 
            effectiveContentWidthFraction
          );
        } else {
          Widget stackContent = _buildVerticalStack(content, panels, constraints);
          
          // Apply width constraints to the vertical stack
          layoutContent = Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth * effectiveContentWidthFraction,
              ),
              child: stackContent,
            ),
          );
        }
        break;
        
      case LayoutType.contentWithSidebar:
        if (sidebar == null) {
          layoutContent = _buildCenteredContent(
            content, 
            constraints, 
            effectiveContentWidthFraction
          );
        } else {
          // For sidebar layout, we'll keep the original implementation
          // since it might need the full width for proper sidebar proportions
          layoutContent = isSmallScreen
            ? _buildVerticalStack(content, [sidebar], constraints)
            : _buildWithSidebar(
                content, 
                sidebar, 
                sidebarPosition, 
                constraints
              );
        }
        break;
        
      case LayoutType.contentWithHeader:
        if (header == null) {
          layoutContent = _buildCenteredContent(
            content, 
            constraints, 
            effectiveContentWidthFraction
          );
        } else {
          Widget headerContent = _buildWithHeader(content, header, constraints);
          
          // Apply width constraints to the header content
          layoutContent = Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth * effectiveContentWidthFraction,
              ),
              child: headerContent,
            ),
          );
        }
        break;
        
      case LayoutType.dashboard:
        layoutContent = _buildCenteredContent(
          content, 
          constraints, 
          effectiveContentWidthFraction
        );
        break;
    }
    
    // Wrap in SingleChildScrollView to prevent overflow errors
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: layoutContent,
          ),
        );
      }
    );
  }
  
  /// Builds a centered content layout with appropriate width constraints
  static Widget _buildCenteredContent(
    Widget content, 
    BoxConstraints constraints, 
    double widthFraction
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: constraints.maxWidth * widthFraction,
        ),
        child: content,
      ),
    );
  }
  
  /// Builds a horizontal split layout (side-by-side panels)
  static Widget _buildHorizontalSplit(
    Widget main, 
    List<Widget> panels, 
    BoxConstraints constraints
  ) {
    // Create a Row with panels first, then main content
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...panels.map((panel) => Expanded(flex: 6, child: panel)),
        Expanded(flex: 6, child: main),
      ],
    );
  }
  
  /// Builds a vertical stack layout (stacked panels)
  static Widget _buildVerticalStack(
    Widget main, 
    List<Widget> panels, 
    BoxConstraints constraints
  ) {
    // Create a Column with main content and panels
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...panels,
        main,
      ],
    );
  }
  
  /// Builds a layout with sidebar next to main content
  static Widget _buildWithSidebar(
    Widget main, 
    Widget sidebar, 
    SidebarPosition position, 
    BoxConstraints constraints
  ) {
    // Calculate sidebar width as percentage of screen width
    final sidebarWidth = constraints.maxWidth * 0.25;
    
    // Create a Row with main content and sidebar in specified position
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: position == SidebarPosition.left
        ? [
            SizedBox(width: sidebarWidth, child: sidebar),
            Expanded(child: main),
          ]
        : [
            Expanded(child: main),
            SizedBox(width: sidebarWidth, child: sidebar),
          ],
    );
  }
  
  /// Builds a layout with header above main content
  static Widget _buildWithHeader(
    Widget main, 
    Widget header, 
    BoxConstraints constraints
  ) {
    // Create a Column with header and main content
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header,
        main,
      ],
    );
  }
}