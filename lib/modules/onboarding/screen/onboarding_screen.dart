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
import '../../../shared/layout/app_layout.dart';

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
        
        // Create app bar with back button when not on first page
        final PreferredSizeWidget? appBar = state.currentPage > 0 
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.kWhite.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(Icons.arrow_back),
                  ),
                  onPressed: () {
                    // Navigate to previous page
                    _contentPageController.previousPage(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              )
            : null;
        
        return AppScaffold(
          currentRoute: 'onboarding',
          showNavigation: false, // Hide navigation during onboarding
          floatingActionButton: null, // Explicitly set to null to prevent layout issues
          layoutType: LayoutType.contentOnly, // Explicitly use contentOnly layout type
          useBackgroundDecorator: true, // Enable background decoration for consistent styling
          contentWidthFraction: 0.95, // Increased from 0.9 to use more screen space and reduce scrolling
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppTheme.kSpacing3x, // Reduced from 4x to 3x
            vertical: AppTheme.kSpacing, // Reduced from 2x to 1x to minimize vertical space usage
          ),
          appBar: appBar, // Add the dynamic app bar
          body: _buildResponsiveLayout(context, state.currentPage),
        );
      },
    );
  }
  
  /// Main responsive layout builder function that switches between wide and narrow layouts
  /// based on the available screen width
  Widget _buildResponsiveLayout(BuildContext context, int currentPage) {
    // Use a LayoutBuilder to determine the available screen space
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 800;
        
        if (isWideScreen) {
          return _buildWideLayout(constraints, currentPage);
        } else {
          return _buildNarrowLayout(constraints, currentPage);
        }
      },
    );
  }
  
  /// Layout for wider screens (tablets, desktops) with side-by-side content
  Widget _buildWideLayout(BoxConstraints constraints, int currentPage) {
    // Ensure we have finite constraints by using explicit sizing
    final screenSize = MediaQuery.of(context).size;
    
    return Container(
      width: screenSize.width,
      height: screenSize.height,
      // Use a Row for horizontal layout on wide screens
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // GIF section (left side) without progress indicator
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
                horizontal: AppTheme.kSpacing4x, // Reduced from 6x to 4x
                vertical: AppTheme.kSpacing, // Reduced from 2x to 1x
              ),
              child: Center(
                child: SizedBox(
                  height: screenSize.height * 0.65, // Increased from 0.6 to 0.65 for more content space
                  width: constraints.maxWidth * 0.45, // Increased from 0.4 to 0.45 for more content space
                  child: _buildContentSection(currentPage),
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
  Widget _buildNarrowLayout(BoxConstraints constraints, int currentPage) {
    // Calculate fixed heights based on device screen size instead of unbounded constraints
    // This prevents the "BoxConstraints forces an infinite height" error
    final double gifHeight = MediaQuery.of(context).size.height * 0.28; // Reduced from 0.3 to 0.28
    final double contentHeight = MediaQuery.of(context).size.height * 0.55; // Increased from 0.5 to 0.55
    
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: AppTheme.kSpacing), // Reduced from 2x to 1x
          
          // GIF section (top) without progress indicator
          SizedBox(
            height: gifHeight,
            width: constraints.maxWidth * 0.95, // Increased from 0.9 to 0.95
            child: OnboardingGifView(
              pageController: _gifPageController,
              gifPaths: [
                OnboardingScreen.nameGifPath,
                OnboardingScreen.genderGifPath,
                OnboardingScreen.ageGifPath,
              ],
            ),
          ),
          
          SizedBox(height: AppTheme.kSpacing), // Reduced from 2x to 1x
          
          // Content section (bottom)
          SizedBox(
            height: contentHeight,
            width: constraints.maxWidth * 0.95, // Increased from 0.9 to 0.95
            child: _buildContentSection(currentPage),
          ),
          
          // Reduced bottom padding
          SizedBox(height: AppTheme.kSpacing2x), // Reduced from 4x to 2x
        ],
      ),
    );
  }
  
  /// Content section containing the page view with progress indicator
  Widget _buildContentSection(int currentPage) {
    return OnboardingPageView(
      pageController: _contentPageController,
      currentPage: currentPage,
      onSubmit: () {
        context.read<OnboardingBloc>().add(OnboardingSubmitted());
      },
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