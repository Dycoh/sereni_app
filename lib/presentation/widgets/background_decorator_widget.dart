// lib/presesntation/widgets/background_decorator_widget.dart

import 'package:flutter/material.dart';
import '../../app/theme/theme.dart';

class BackgroundDecorator extends StatelessWidget {
  final Widget child;

  const BackgroundDecorator({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape ||
        screenSize.width > 600;

    // Calculate main circle size
    double mainCircleSize = isLandscape
        ? screenSize.height * 0.6
        : screenSize.width * 0.6;

    // Adjust size for smaller screens (reduce to half or 3/4)
    if (!isLandscape && screenSize.width <= 600) {
      mainCircleSize *= 0.5; // Reduce to half for small screens
    }
    
    // Make the bottom circle about 1/3 the size of the main circle
    final double smallCircleSize = mainCircleSize * 0.33;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Main circle background at top-right (moved down by 7.5% of screen height)
        Positioned(
          top: screenSize.height * 0.075,
          right: -mainCircleSize / 4,
          child: Container(
            width: mainCircleSize,
            height: mainCircleSize,
            decoration: BoxDecoration(
              color: AppTheme.kPrimaryGreen.withOpacity(isLandscape ? 0.1 : 0.025),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Small circle at bottom-left (only visible on larger screens)
        if (isLandscape || screenSize.width > 600)
          Positioned(
            bottom: -smallCircleSize / 2,
            left: -smallCircleSize / 4,
            child: Container(
              width: smallCircleSize,
              height: smallCircleSize,
              decoration: BoxDecoration(
                color: AppTheme.kPrimaryGreen.withOpacity(0.3), // Slightly less transparent
                shape: BoxShape.circle,
              ),
            ),
          ),
        // Main content
        child,
      ],
    );
  }
}
