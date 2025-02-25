// Path: lib/modules/onboarding/widgets/onboarding_page_view.dart

// Author: Dycoh Gacheri (https://github.com/Dycoh)
// Description: Page view component for onboarding screens. Contains pages for
// name input, gender selection, and age selection with appropriate input widgets
// and validation.

// Last Modified: Tuesday, 25 February 2025 16:35

// Core/Framework imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports - BLoC
import '../bloc/onboarding_bloc.dart';

// Project imports - Components
import 'onboarding_input_widgets.dart';

// Project imports - Theme
import '../../../app/theme.dart';

/// Widget that manages the content pages for the onboarding flow
class OnboardingPageView extends StatelessWidget {
  // Controllers and callbacks
  final PageController pageController;
  final VoidCallback onSubmit;
  final int currentPage;
  
  // Page titles and subtitles
  static const List<Map<String, String>> _pageContent = [
    {
      'title': 'What\'s your name?',
      'subtitle': 'So I can greet you properly each time we meet, what name would you prefer?',
      'buttonText': 'Continue',
    },
    {
      'title': 'What\'s your\nGender?',
      'subtitle': 'This information helps me provide more relevant content based on mental health patterns across different groups.',
      'buttonText': 'Continue',
    },
    {
      'title': 'What\'s your\nAge?',
      'subtitle': 'Understanding your life stage helps me tailor suggestions that resonate with your experiences.',
      'buttonText': 'Sign in',
    },
  ];

  const OnboardingPageView({
    super.key,
    required this.pageController,
    required this.onSubmit,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page title
              Text(
                _pageContent[index]['title']!,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppTheme.kTextBrown,
                  fontWeight: FontWeight.w800,
                  fontSize: 48,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: AppTheme.kSpacing2x),
              
              // Decorative line
              Container(
                width: 180,
                height: 3,
                decoration: BoxDecoration(
                  color: AppTheme.kPrimaryGreen.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
              SizedBox(height: AppTheme.kSpacing3x),
              
              // Page subtitle
              Text(
                _pageContent[index]['subtitle']!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.kTextBrown,
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: AppTheme.kSpacing3x),
              
              // Page-specific input widget
              SizedBox(
                width: double.infinity,
                child: _buildInputWidget(context, index),
              ),
              SizedBox(height: AppTheme.kSpacing4x),
              
              // Navigation button
              _buildNavigationButton(context, index),
              SizedBox(height: AppTheme.kSpacing3x),
              
              // Progress indicator - moved to below the button
              Align(
                alignment: Alignment.centerLeft,
                child: _buildProgressIndicator(context),
              ),
              SizedBox(height: AppTheme.kSpacing3x),
            ],
          ),
        );
      },
    );
  }

  // Builds the appropriate input widget based on page index
  Widget _buildInputWidget(BuildContext context, int index) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        switch (index) {
          case 0:
            return NameInputField(
              initialValue: state.userData.name,
              showError: state is OnboardingValidationError && state.fieldName == 'name',
              onChanged: (value) {
                context.read<OnboardingBloc>().add(NameUpdated(value));
              },
            );
          case 1:
            return GenderSelector(
              selectedGender: state.userData.gender,
              onGenderChanged: (gender) {
                context.read<OnboardingBloc>().add(GenderSelected(gender));
              },
            );
          case 2:
            return AgeSelector(
              selectedAge: state.userData.age,
              onAgeChanged: (age) {
                context.read<OnboardingBloc>().add(AgeUpdated(age));
              },
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  // Builds the navigation button with appropriate text
  Widget _buildNavigationButton(BuildContext context, int index) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        final bool isLastPage = index == 2;
        final String buttonText = _pageContent[index]['buttonText']!;
        
        return Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: () => _handleNavigation(context, index, isLastPage),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.kAccentBrown,
              foregroundColor: AppTheme.kWhite,
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.kSpacing4x,
                vertical: AppTheme.kSpacing2x,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.kSpacing,
                vertical: AppTheme.kSpacing,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(buttonText),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18, color: AppTheme.kWhite),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  /// Progress indicator showing current page in the onboarding flow
  Widget _buildProgressIndicator(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.kSpacing * 1.5, // Increased horizontal padding
        vertical: AppTheme.kSpacing / 2,
      ),
      decoration: BoxDecoration(
        color: AppTheme.kWhite.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        // Adding slight shadow for better visibility against varying backgrounds
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Ensure it takes only the space it needs
        mainAxisAlignment: MainAxisAlignment.center, // Center the indicators
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
      ),
    );
  }

  // Handles navigation based on current page and validation
  void _handleNavigation(BuildContext context, int currentIndex, bool isLastPage) {
    final bloc = context.read<OnboardingBloc>();
    
    // Validate if we can proceed to the next page
    if (bloc.canProceedToNextPage(currentIndex, bloc.state.userData)) {
      if (isLastPage) {
        // Submit if on last page
        onSubmit();
      } else {
        // Navigate to next page
        pageController.nextPage(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
        );
      }
    } else {
      // Trigger validation error
      String errorMessage;
      String? fieldName;
      
      switch (currentIndex) {
        case 0:
          errorMessage = 'Please enter your name';
          fieldName = 'name';
          break;
        case 1:
          errorMessage = 'Please select your gender';
          fieldName = 'gender';
          break;
        default:
          errorMessage = 'Invalid input';
          break;
      }
      
      bloc.add(PageChanged(currentIndex)); // This will trigger validation in the bloc
    }
  }
}