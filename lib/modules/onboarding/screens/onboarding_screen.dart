// Path: lib/modules/onboarding/screens/onboarding_screen.dart
// Author: Dycoh Gacheri (https://github.com/Dycoh)
// Description: Onboarding screen that guides users through the initial setup process
// with animated GIFs and a multi-page form flow for collecting user information.
// Last Modified: Tuesday, 25 February 2025 16:35

// Core/Framework imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports - BLoC
import '../bloc/onboarding_bloc.dart';

// Project imports - UI Components
import '../widgets/onboarding_page_view.dart';
import '../widgets/onboarding_gif_view.dart';

// Project imports - Layout
import '../../../app/scaffold.dart';
import '../../../app/theme.dart';
import '../../../app/routes.dart';
import '../../../shared/layout/app_layout.dart'; // Added import for LayoutType

/// Main onboarding screen that orchestrates the flow and provides BLoC provider
class OnboardingScreen extends StatelessWidget {
  // Asset paths - centralized for easier maintenance
  static const String nameGifPath = 'assets/gifs/onboarding_name_bot.gif';
  static const String genderGifPath = 'assets/gifs/onboarding_gender_bot.gif';
  static const String ageGifPath = 'assets/gifs/onboarding_age_bot.gif';
  
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingBloc(),
      child: _OnboardingView(),
    );
  }
}

/// Private implementation of the onboarding view
class _OnboardingView extends StatefulWidget {
  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  // Controllers for synchronized page transitions
  final PageController _contentPageController = PageController();
  final PageController _gifPageController = PageController();
  
  @override
  void initState() {
    super.initState();
    // Listen for page changes to synchronize animations
    _contentPageController.addListener(_syncGifPageController);
  }
  
  /// Synchronizes the GIF page controller with the content page controller
  /// to ensure animations stay aligned with the current page
  void _syncGifPageController() {
    if (!_contentPageController.hasClients) return;
    
    final currentPage = _contentPageController.page?.round() ?? 0;
    
    // Only animate gif page controller if needed
    if (_gifPageController.hasClients && _gifPageController.page?.round() != currentPage) {
      _gifPageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
      );
    }
    
    // Notify BLoC about page changes
    context.read<OnboardingBloc>().add(PageChanged(currentPage));
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listenWhen: (previous, current) => 
          current is OnboardingSubmitSuccess ||
          (current is OnboardingValidationError && previous.currentPage != current.currentPage),
      listener: (context, state) {
        if (state is OnboardingSubmitSuccess) {
          // Navigate to post-onboarding screen
          RouteManager.handlePostOnboardingNavigation(context);
        } else if (state is OnboardingValidationError) {
          // Show error snackbar for validation errors that prevent navigation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: AppTheme.kErrorRed,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        // Handle page sync when state changes page
        if (_contentPageController.hasClients && 
            _contentPageController.page?.round() != state.currentPage) {
          _contentPageController.animateToPage(
            state.currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        
        return AppScaffold(
          currentRoute: 'onboarding',
          showNavigation: false, // Hide navigation during onboarding
          floatingActionButton: null, // Explicitly set to null to prevent layout issues
          layoutType: LayoutType.contentOnly, // Explicitly use contentOnly layout type
          useBackgroundDecorator: true, // Enable background decoration for consistent styling
          contentWidthFraction: 0.9, // Use more screen space for onboarding
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppTheme.kSpacing4x,
            vertical: AppTheme.kSpacing2x,
          ),
          body: _buildResponsiveLayout(context),
        );
      },
    );
  }
  
  /// Main responsive layout builder function that switches between wide and narrow layouts
  /// based on the available screen width
  Widget _buildResponsiveLayout(BuildContext context) {
    // Use a LayoutBuilder to determine the available screen space
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 800;
        
        if (isWideScreen) {
          return _buildWideLayout(constraints);
        } else {
          return _buildNarrowLayout(constraints);
        }
      },
    );
  }
  
  /// Layout for wider screens (tablets, desktops) with side-by-side content
  Widget _buildWideLayout(BoxConstraints constraints) {
    // Ensure we have finite constraints by using explicit sizing
    final screenSize = MediaQuery.of(context).size;
    
    return Container(
      width: screenSize.width,
      height: screenSize.height,
      // Use a Row for horizontal layout on wide screens
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // GIF section (left side)
          Expanded(
            flex: 6,
            child: Center(
              child: SizedBox(
                height: screenSize.height * 0.7, // Fixed percentage of screen height
                width: constraints.maxWidth * 0.4,
                child: OnboardingGifView(
                  pageController: _gifPageController,
                  gifPaths: [
                    OnboardingScreen.nameGifPath,
                    OnboardingScreen.genderGifPath,
                    OnboardingScreen.ageGifPath,
                  ],
                ),
              ),
            ),
          ),
          
          // Content section (right side)
          Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.kSpacing6x,
                vertical: AppTheme.kSpacing2x,
              ),
              child: Center(
                child: SizedBox(
                  height: screenSize.height * 0.6, // Fixed percentage of screen height
                  width: constraints.maxWidth * 0.4,
                  child: _buildContentSection(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Layout for narrower screens (phones) with vertically stacked content
  /// Fixed to prevent infinite height constraints in SingleChildScrollView
  Widget _buildNarrowLayout(BoxConstraints constraints) {
    // Calculate fixed heights based on device screen size instead of unbounded constraints
    // This prevents the "BoxConstraints forces an infinite height" error
    final double gifHeight = MediaQuery.of(context).size.height * 0.3;
    final double contentHeight = MediaQuery.of(context).size.height * 0.5;
    
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: AppTheme.kSpacing2x),
          
          // GIF section (top) - now with fixed height
          SizedBox(
            height: gifHeight,
            width: constraints.maxWidth * 0.9,
            child: OnboardingGifView(
              pageController: _gifPageController,
              gifPaths: [
                OnboardingScreen.nameGifPath,
                OnboardingScreen.genderGifPath,
                OnboardingScreen.ageGifPath,
              ],
            ),
          ),
          
          SizedBox(height: AppTheme.kSpacing2x),
          
          // Content section (bottom) - now with fixed height
          SizedBox(
            height: contentHeight,
            width: constraints.maxWidth * 0.9,
            child: _buildContentSection(),
          ),
          
          // Add some bottom padding for better spacing
          SizedBox(height: AppTheme.kSpacing4x),
        ],
      ),
    );
  }
  
  /// Content section containing the page view and back button
  Widget _buildContentSection() {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return Stack(
          children: [
            // Onboarding content pages
            Positioned.fill(
              child: OnboardingPageView(
                pageController: _contentPageController,
                onSubmit: () {
                  context.read<OnboardingBloc>().add(OnboardingSubmitted());
                },
              ),
            ),
            
            // Back button (only shown when not on first page)
            if (state.currentPage > 0)
              Positioned(
                top: AppTheme.kSpacing2x,
                left: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.kWhite.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      // Navigate to previous page
                      _contentPageController.previousPage(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ),
            
            // Progress indicator at bottom
            Positioned(
              bottom: AppTheme.kSpacing,
              left: 0,
              child: _buildProgressIndicator(state.currentPage),
            ),
          ],
        );
      },
    );
  }
  
  /// Progress indicator showing current page in the onboarding flow
  Widget _buildProgressIndicator(int currentPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(
        3, // Number of pages
        (index) {
          return Container(
            width: 24,
            height: 8,
            margin: EdgeInsets.only(left: index > 0 ? AppTheme.kSpacing : 0),
            decoration: BoxDecoration(
              color: index <= currentPage
                  ? AppTheme.kPrimaryGreen
                  : AppTheme.kGray200,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        },
      ),
    );
  }
  
  @override
  void dispose() {
    _contentPageController.removeListener(_syncGifPageController);
    _contentPageController.dispose();
    _gifPageController.dispose();
    super.dispose();
  }
}