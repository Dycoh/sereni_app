// Path: lib/shared/layout/app_background.dart

// Author: Dycoh Gacheri (https://github.com/Dycoh)
// Description: A widget that adds decorative background elements to the app's
// screens. Creates circular decorations that adapt to screen size and orientation
// to maintain a consistent visual identity across the app.

// Last Modified: Monday, 24 February 2025 16:35

// Core/Framework imports
import 'package:flutter/material.dart';

// Project imports - UI Components
import '../../app/theme.dart';

/// A widget that adds decorative background elements to the app's screens.
/// Creates circular decorations that adapt to screen size and orientation.
class AppBackground extends StatelessWidget {
  // Core properties
  final Widget child;
  
  // Customization properties
  final Color? primaryColor;
  final double opacity;
  final bool showSmallCircle;
  
  // Configuration constants
  static const double _mainCircleSizeFactor = 0.6;
  static const double _smallCircleSizeFactor = 0.33;
  static const double _mainCircleTopOffset = 0.075;
  static const double _mainCircleRightOffset = 0.25;
  static const double _smallCircleBottomOffset = 0.5;
  static const double _smallCircleLeftOffset = 0.25;
  static const double _mobileScaleFactor = 0.5;
  
  /// Creates an AppBackground widget that adds decorative elements behind child content.
  /// 
  /// The [child] parameter is required and represents the main content to display.
  /// [primaryColor] allows overriding the default app primary color for the decorations.
  /// [opacity] controls the transparency of the main decoration elements.
  /// [showSmallCircle] determines whether to show the smaller decorative circle.
  const AppBackground({
    Key? key,
    required this.child,
    this.primaryColor,
    this.opacity = 1.0,
    this.showSmallCircle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and orientation
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape ||
        screenSize.width > 600;
    
    // Use provided color or default to theme primary color
    final Color effectiveColor = primaryColor ?? AppTheme.kPrimaryGreen;

    // Calculate circle sizes based on screen dimensions
    // Main circle: 60% of screen width/height depending on orientation
    double mainCircleSize = isLandscape
        ? screenSize.height * _mainCircleSizeFactor
        : screenSize.width * _mainCircleSizeFactor;

    // Adjust main circle size for smaller screens
    if (!isLandscape && screenSize.width <= 600) {
      mainCircleSize *= _mobileScaleFactor;
    }

    // Small circle: 1/3 of main circle size
    final double smallCircleSize = mainCircleSize * _smallCircleSizeFactor;

    return Container(
      // Ensure background covers entire available space
      width: double.infinity,
      height: double.infinity,
      // Use Stack for layering background elements and main content
      child: Stack(
        fit: StackFit.expand, // Ensures stack fills all available space
        children: [
          // Main circle in top-right corner
          Positioned(
            top: screenSize.height * _mainCircleTopOffset,  // Offset from top
            right: -mainCircleSize * _mainCircleRightOffset, // Partially off-screen
            child: Container(
              width: mainCircleSize,
              height: mainCircleSize,
              decoration: BoxDecoration(
                // Adjust opacity based on screen size and parameter
                color: effectiveColor.withOpacity(
                  (isLandscape ? 0.1 : 0.025) * opacity
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Small circle in bottom-left corner (only on larger screens or when enabled)
          if ((isLandscape || screenSize.width > 600) && showSmallCircle)
            Positioned(
              bottom: -smallCircleSize * _smallCircleBottomOffset, // Partially off-screen
              left: -smallCircleSize * _smallCircleLeftOffset,     // Partially off-screen
              child: Container(
                width: smallCircleSize,
                height: smallCircleSize,
                decoration: BoxDecoration(
                  color: effectiveColor.withOpacity(0.3 * opacity),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
          // Main content on top of background
          child,
        ],
      ),
    );
  }
}