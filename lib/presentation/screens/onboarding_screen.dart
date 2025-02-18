import 'package:flutter/material.dart';
import '../../app/theme/theme.dart';
import '../../app/routes.dart';

class AssetPaths {
  static const String nameBot = 'assets/gifs/onboarding_name_bot.gif';
  static const String genderBot = 'assets/gifs/onboarding_gender_bot.gif';
  static const String ageBot = 'assets/gifs/onboarding_age_bot.gif';
}

class OnboardingPage {
  final String title;
  final String? subtitle;
  final String gifPath;
  final String buttonText;
  final Widget Function(BuildContext) inputBuilder;

  OnboardingPage({
    required this.title,
    this.subtitle,
    required this.gifPath,
    required this.buttonText,
    required this.inputBuilder,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _contentPageController = PageController();
  final PageController _gifPageController = PageController();
  
  String? _userName;
  String? _selectedGender;
  double _selectedAge = 25; // Default age
  bool _showNameError = false;
  int _lastVisitedPage = 0;
  bool _hasNavigatedBack = false;
  String? _previousName;
  TextEditingController _nameController = TextEditingController();
  
  late final List<OnboardingPage> pages;

  @override
  void initState() {
    super.initState();
    _initializePages();
    _contentPageController.addListener(_handlePageChange);
  }

  void _handlePageChange() {
    if (!_contentPageController.hasClients) return;
    
    final currentPage = _contentPageController.page?.round() ?? 0;
    
    // Sync gif page controller with content page controller
    if (_gifPageController.hasClients && _gifPageController.page?.round() != currentPage) {
      _gifPageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 150), // Quicker transition
        curve: Curves.easeInOut,
      );
    }
    
    // Reset data when user goes back
    if (currentPage < _lastVisitedPage) {
      setState(() {
        _hasNavigatedBack = true;
        
        // Reset gender selection if user goes back to page 0 from any page
        if (currentPage == 0) {
          _selectedGender = null;
          _selectedAge = 25;
          _previousName = _userName;
          
          // Check if the name field is empty when returning to the first page and show error if needed
          if (_userName == null || _userName!.isEmpty) {
            _showNameError = true;
          }
        }
        
        // Reset age selection if user goes back to page 1 from page 2
        if (currentPage == 1 && _lastVisitedPage == 2) {
          _selectedAge = 25;
        }
      });
    }
    
    _lastVisitedPage = currentPage;
  }

  void _initializePages() {
    pages = [
      OnboardingPage(
        title: 'What\'s your name?',
        subtitle: 'So I can greet you properly each time we meet, what name would you prefer?',
        gifPath: AssetPaths.nameBot,
        buttonText: 'Continue',
        inputBuilder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              onChanged: (value) {
                setState(() {
                  _userName = value;
                  // Only hide error when user types something
                  if (value.isNotEmpty) {
                    _showNameError = false;
                  }
                  
                  // If user changes name and previously navigated back, reset inputs for next pages
                  if (_hasNavigatedBack && _previousName != value) {
                    _selectedGender = null;
                    _selectedAge = 25;
                  }
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter your name',
                border: _showNameError ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0), // Fully rounded edges
                  borderSide: const BorderSide(color: Colors.red),
                ) : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0), // Fully rounded edges
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0), // Fully rounded edges
                  borderSide: const BorderSide(color: AppTheme.kPrimaryGreen),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0), // Fully rounded edges
                  borderSide: const BorderSide(color: AppTheme.kGray200),
                ),
                filled: true,
                fillColor: AppTheme.kWhite,
                contentPadding: const EdgeInsets.all(AppTheme.kSpacing2x),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0), // Fully rounded edges
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
            ),
            if (_showNameError) ...[
              SizedBox(height: AppTheme.kSpacing),
              Text(
                'Please enter your name',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
      OnboardingPage(
        title: 'What\'s your\nGender?',
        subtitle: 'This information helps me provide more relevant content based on mental health patterns across different groups.',
        gifPath: AssetPaths.genderBot,
        buttonText: 'Continue',
        inputBuilder: (context) => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _GenderButton(
              label: 'Male',
              isSelected: _selectedGender == 'Male',
              isEnabled: _selectedGender == null || _selectedGender == 'Male',
              onTap: () => setState(() => _selectedGender = 'Male'),
            ),
            SizedBox(width: AppTheme.kSpacing2x),
            _GenderButton(
              label: 'Female',
              isSelected: _selectedGender == 'Female',
              isEnabled: _selectedGender == null || _selectedGender == 'Female',
              onTap: () => setState(() => _selectedGender = 'Female'),
            ),
          ],
        ),
      ),
      OnboardingPage(
        title: 'What\'s your\nAge?',
        subtitle: 'Understanding your life stage helps me tailor suggestions that resonate with your experiences.',
        gifPath: AssetPaths.ageBot,
        buttonText: 'Sign in',
        inputBuilder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_selectedAge.round()} years',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.kTextBrown,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppTheme.kSpacing2x),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppTheme.kPrimaryGreen,
                inactiveTrackColor: AppTheme.kGray200,
                thumbColor: AppTheme.kPrimaryGreen,
                overlayColor: const Color.fromRGBO(15, 180, 0, 0.2),
                trackHeight: 4.0,
              ),
              child: Slider(
                value: _selectedAge,
                min: 18,
                max: 75,
                divisions: 57,
                onChanged: (value) => setState(() => _selectedAge = value),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('18', style: Theme.of(context).textTheme.bodySmall),
                Text('75', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.kBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1), // 10% padding
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWideScreen = constraints.maxWidth > 800;
                  
                  if (isWideScreen) {
                    return Row(
                      children: [
                        Expanded(
                          flex: 6, // Changed from 8 to 6
                          child: Center(
                            child: SizedBox(
                              height: constraints.maxHeight * 0.8,
                              child: _buildGifSection(),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6, // Changed from 5 to 6
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppTheme.kSpacing6x,
                              vertical: AppTheme.kSpacing2x,
                            ),
                            child: Center(
                              child: SizedBox(
                                height: constraints.maxHeight * 0.7,
                                child: _buildContentSection(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(AppTheme.kSpacing4x),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: AppTheme.kSpacing2x),
                          SizedBox(
                            height: constraints.maxHeight * 0.4,
                            child: _buildGifSection(),
                          ),
                          SizedBox(height: AppTheme.kSpacing2x),
                          SizedBox(
                            height: constraints.maxHeight * 0.6,
                            child: _buildContentSection(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              _buildBackButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGifSection() {
    return PageView.builder(
      controller: _gifPageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return Image.asset(
          pages[index].gifPath,
          fit: BoxFit.contain,
        );
      },
    );
  }

    Widget _buildBackButton() {
      final currentPage = _contentPageController.hasClients
          ? (_contentPageController.page ?? 0).round()
          : 0;
      
      if (currentPage == 0) return const SizedBox.shrink();
      
      return Positioned(
        top: AppTheme.kSpacing2x,
        left: 16, // Fixed 16px from left edge
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _contentPageController.previousPage(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
            );
          },
        ),
      );
    }

  Widget _buildProgressIndicator() {
    final currentPage = _contentPageController.hasClients
        ? (_contentPageController.page ?? 0).round()
        : 0;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // Align to start/left
      children: List.generate(
        pages.length,
        (index) {
          return Container(
            width: 24,
            height: 8, // Changed from 4 to 8 to make the indicator twice as thick
            margin: EdgeInsets.only(left: index > 0 ? AppTheme.kSpacing : 0),
            decoration: BoxDecoration(
              color: index <= currentPage
                  ? AppTheme.kPrimaryGreen
                  : AppTheme.kGray200,
              borderRadius: BorderRadius.circular(4), // Increased from 2 to 4 to maintain proportions
            ),
          );
        },
      ),
    );
  }

  Widget _buildContentSection() {
    return Stack(
      children: [
        PageView.builder(
          controller: _contentPageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pages.length,
          itemBuilder: (context, index) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pages[index].title,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppTheme.kTextBrown,
                      fontWeight: FontWeight.w800,
                      fontSize: 48,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: AppTheme.kSpacing2x),
                  
                  Container(
                    width: 180,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppTheme.kPrimaryGreen.withOpacity(0.5), // Primary green with 50% opacity
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                  SizedBox(height: AppTheme.kSpacing3x),
                  
                  if (pages[index].subtitle != null) ...[
                    Text(
                      pages[index].subtitle!,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.kTextBrown,
                        fontWeight: FontWeight.w300, // Light font weight for subtitles
                        fontSize: 16, // Smaller font size for subtitles (12px)
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: AppTheme.kSpacing3x),
                  ],
                  
                  SizedBox(
                    width: double.infinity,
                    child: pages[index].inputBuilder(context),
                  ),
                  SizedBox(height: AppTheme.kSpacing4x),
                  
                  _buildNavigationButton(index),
                  SizedBox(height: AppTheme.kSpacing6x), // Additional space for the floating indicator
                ],
              ),
            );
          },
        ),
        // Floating progress indicator positioned even lower
        Positioned(
          bottom: AppTheme.kSpacing,
          left: 0,
          child: _buildProgressIndicator(),
        ),
      ],
    );
  }

  Widget _buildNavigationButton(int index) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ElevatedButton(
        onPressed: () => _handleNavigation(index),
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
              Text(pages[index].buttonText),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 18, color: AppTheme.kWhite),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNavigation(int currentIndex) {
    // Always validate name on the first page
    if (currentIndex == 0) {
      if (_userName == null || _userName!.isEmpty) {
        setState(() {
          _showNameError = true;
        });
        return; // Don't proceed if name is empty
      }
    }
    
    if (_canProceed(currentIndex)) {
      if (currentIndex < pages.length - 1) {
        // Reset the "has navigated back" flag when proceeding forward normally
        _hasNavigatedBack = false;
        
        _contentPageController.nextPage(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
        );
      } else {
        // Handle completion - Navigate to sign in screen
        RouteManager.handlePostOnboardingNavigation(context);
      }
    }
  }
  bool _canProceed(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return _userName != null && _userName!.isNotEmpty;
      case 1:
        return _selectedGender != null;
      case 2:
        return true; // Age always has a value due to slider
      default:
        return false;
    }
  }

  @override
  void dispose() {
    _contentPageController.removeListener(_handlePageChange);
    _contentPageController.dispose();
    _gifPageController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}

class _GenderButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;

  const _GenderButton({
    required this.label,
    required this.isSelected,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.kSpacing3x,
          vertical: AppTheme.kSpacing2x,
        ),
        decoration: BoxDecoration(
          color: isSelected 
            ? AppTheme.kPrimaryGreen
            : Colors.transparent,
          border: Border.all(
            color: isEnabled
              ? (isSelected ? AppTheme.kPrimaryGreen : AppTheme.kGray200)
              : AppTheme.kGray400,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(50.0), // Fully rounded edges
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isSelected 
              ? AppTheme.kWhite
              : (isEnabled ? AppTheme.kTextBrown : AppTheme.kGray400),
            fontWeight: isSelected 
              ? FontWeight.bold
              : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}