// Path: lib/modules/onboarding/widgets/onboarding_gif_view.dart

// Author: Dycoh Gacheri (https://github.com/Dycoh)
// Description: Widget for displaying animated GIFs that correspond to each page of the onboarding flow.
// Handles proper transitions, error states, and visual styling for a smooth user experience.

// Last Modified: Tuesday, 25 February 2025 16:35

// Core/Framework imports
import 'package:flutter/material.dart';

// Project imports - Theme
import '../../../app/theme.dart';

/// Widget for displaying animated GIFs that correspond to each page of the onboarding flow
class OnboardingGifView extends StatelessWidget {
  // Controllers and assets
  final PageController pageController;
  final List<String> gifPaths;
 
  /// Creates an [OnboardingGifView] for displaying animated GIFs during onboarding
  ///
  /// [pageController] should be synchronized with the main content page controller
  /// [gifPaths] is a list of asset paths for the GIFs corresponding to each page
  const OnboardingGifView({
    super.key,
    required this.pageController,
    required this.gifPaths,
  }) : assert(gifPaths.length > 0, 'Must provide at least one GIF path');
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Using app background color
        color: AppTheme.kBackgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
        // Removed shadow
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
        child: PageView.builder(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(), // Don't allow manual swiping
          itemCount: gifPaths.length,
          itemBuilder: (context, index) {
            return _buildGifContainer(gifPaths[index]);
          },
        ),
        // Removed the Stack and the Positioned green strip
      ),
    );
  }
  
  // Builds the container for an individual GIF with proper styling
  Widget _buildGifContainer(String gifPath) {
    return Container(
      decoration: BoxDecoration(
        // Using app background color
        color: AppTheme.kBackgroundColor,
      ),
      child: Center(
        child: Image.asset(
          gifPath,
          fit: BoxFit.contain,
          // Adding a fade-in animation for smoother transitions
          frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            }
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: child,
            );
          },
          // Error handling for missing assets
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported_outlined,
                    size: 48,
                    color: AppTheme.kGray400,
                  ),
                  SizedBox(height: AppTheme.kSpacing),
                  Text(
                    'Image not available',
                    style: TextStyle(
                      color: AppTheme.kGray400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}