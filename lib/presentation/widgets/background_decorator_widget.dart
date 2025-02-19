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

    // Calculate circle size based on screen dimensions
    final double circleSize = isLandscape
        ? screenSize.height * 0.5  // Full height for landscape/desktop
        : screenSize.width * 0.5;  // Full width for portrait/mobile

    return Stack(
      children: [
        // Circle background at top-right
        Positioned(
          // Position adjusted to center the circle at top-right corner
          top: -circleSize / 2,
          right: -circleSize / 2,
          child: Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              color: AppTheme.kPrimaryGreen.withOpacity(0.1),
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