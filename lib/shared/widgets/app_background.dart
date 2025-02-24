// lib/shared/widgets/app_background.dart

import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// A widget that adds decorative background elements to the app's screens.
/// Creates circular decorations that adapt to screen size and orientation.
class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and orientation
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape ||
        screenSize.width > 600;

    // Calculate circle sizes based on screen dimensions
    // Main circle: 60% of screen width/height depending on orientation
    double mainCircleSize = isLandscape
        ? screenSize.height * 0.6
        : screenSize.width * 0.6;

    // Adjust main circle size for smaller screens
    if (!isLandscape && screenSize.width <= 600) {
      mainCircleSize *= 0.5;
    }

    // Small circle: 1/3 of main circle size
    final double smallCircleSize = mainCircleSize * 0.33;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Main circle in top-right corner
        Positioned(
          top: screenSize.height * 0.075,  // Offset from top by 7.5% of screen height
          right: -mainCircleSize / 4,      // Partially off-screen
          child: Container(
            width: mainCircleSize,
            height: mainCircleSize,
            decoration: BoxDecoration(
              // Adjust opacity based on screen size
              color: AppTheme.kPrimaryGreen.withOpacity(isLandscape ? 0.1 : 0.025),
              shape: BoxShape.circle,
            ),
          ),
        ),
        
        // Small circle in bottom-left corner (only on larger screens)
        if (isLandscape || screenSize.width > 600)
          Positioned(
            bottom: -smallCircleSize / 2,  // Partially off-screen
            left: -smallCircleSize / 4,    // Partially off-screen
            child: Container(
              width: smallCircleSize,
              height: smallCircleSize,
              decoration: BoxDecoration(
                color: AppTheme.kPrimaryGreen.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
        // Main content on top of background
        child,
      ],
    );
  }
}