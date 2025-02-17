import 'package:flutter/material.dart';
import '../../app/theme/theme.dart';

class AssetPaths {
  static const String sereniBot = 'assets/gifs/sereni_chatbot_animation.gif';
  static const String genderBot = 'assets/gifs/gender_identity_robot.gif';
  static const String ageBot = 'assets/gifs/onboarding_age_bot.gif';
}

class OnboardingPage {
  final String title;
  final String? subtitle;
  final String gifPath;
  final String buttonText;
  final Widget? input;

  OnboardingPage({
    required this.title,
    this.subtitle,
    required this.gifPath,
    required this.buttonText,
    this.input,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Separate controllers for each PageView
  final PageController _gifPageController = PageController();
  final PageController _contentPageController = PageController();
  
  String? _userName;
  String? _selectedGender;
  int? _selectedAge;
  
  late final List<OnboardingPage> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      OnboardingPage(
        title: 'Hello,\nI\'m Sereni...',
        subtitle: 'What\'s your name?',
        gifPath: AssetPaths.sereniBot,
        buttonText: 'Continue',
        input: TextField(
          onChanged: (value) => setState(() => _userName = value),
          decoration: InputDecoration(
            hintText: 'Enter your name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.kRadiusMedium),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.kRadiusMedium),
              borderSide: const BorderSide(color: AppTheme.kPrimaryGreen),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.kRadiusMedium),
              borderSide: const BorderSide(color: AppTheme.kGray200),
            ),
            filled: true,
            fillColor: AppTheme.kWhite,
            contentPadding: const EdgeInsets.all(AppTheme.kSpacing2x),
          ),
        ),
      ),
      OnboardingPage(
        title: 'Whats your\nGender?',
        gifPath: AssetPaths.genderBot,
        buttonText: 'Continue',
        input: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _GenderButton(
              label: 'Male',
              isSelected: _selectedGender == 'Male',
              onTap: () => setState(() => _selectedGender = 'Male'),
            ),
            SizedBox(width: AppTheme.kSpacing2x),
            _GenderButton(
              label: 'Female',
              isSelected: _selectedGender == 'Female',
              onTap: () => setState(() => _selectedGender = 'Female'),
            ),
          ],
        ),
      ),
      OnboardingPage(
        title: 'Whats your\nAge?',
        gifPath: AssetPaths.ageBot,
        buttonText: 'Sign in',
        input: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _AgeButton(
              age: '18',
              isSelected: _selectedAge == 18,
              onTap: () => setState(() => _selectedAge = 18),
            ),
            SizedBox(width: AppTheme.kSpacing2x),
            _AgeButton(
              age: '25',
              isSelected: _selectedAge == 25,
              onTap: () => setState(() => _selectedAge = 25),
            ),
            SizedBox(width: AppTheme.kSpacing2x),
            _AgeButton(
              age: '60',
              isSelected: _selectedAge == 60,
              onTap: () => setState(() => _selectedAge = 60),
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWideScreen = constraints.maxWidth > 800;
            
            if (isWideScreen) {
              return Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Center(
                          child: SizedBox(
                            height: constraints.maxHeight * 0.8,
                            child: _buildGifSection(),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppTheme.kSpacing6x,
                            vertical: AppTheme.kSpacing4x, // Added vertical padding
                          ),
                          child: Center( // Ensures vertical centering
                            child: SizedBox(
                              height: constraints.maxHeight * 0.55, // Reduced height to ensure content fits
                              child: Align(
                                alignment: Alignment.center, // Center alignment on vertical axis
                                child: _buildContentSection(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Back button (top left)
                  _buildBackButton(),
                ],
              );
            }
            
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(AppTheme.kSpacing4x),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Center alignment for mobile view
                      children: [
                        SizedBox(height: AppTheme.kSpacing4x), // Added extra top padding
                        SizedBox(
                          height: constraints.maxHeight * 0.4,
                          child: _buildGifSection(),
                        ),
                        SizedBox(height: AppTheme.kSpacing4x),
                        SizedBox(
                          height: constraints.maxHeight * 0.5,
                          child: _buildContentSection(),
                        ),
                      ],
                    ),
                  ),
                ),
                // Back button (top left)
                _buildBackButton(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    // Only show back button if not on first page
    final currentPageIndex = _contentPageController.hasClients 
        ? _contentPageController.page?.round() ?? 0 
        : 0;
        
    if (currentPageIndex == 0) {
      return const SizedBox.shrink(); // Don't show back button on first page
    }
    
    return Positioned(
      top: AppTheme.kSpacing2x,
      left: AppTheme.kSpacing2x,
      child: ElevatedButton(
        onPressed: _handleBackNavigation,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.kAccentBrown,
          foregroundColor: AppTheme.kWhite,
          shape: const CircleBorder(),
          padding: EdgeInsets.all(AppTheme.kSpacing2x),
          elevation: 4,
        ),
        child: const Icon(
          Icons.arrow_back,
          color: AppTheme.kWhite,
          size: 24,
        ),
      ),
    );
  }

  void _handleBackNavigation() {
    if (!_contentPageController.hasClients) return;
    
    final currentPage = _contentPageController.page?.round() ?? 0;
    if (currentPage > 0) {
      // Animate both PageViews together to previous page
      _gifPageController.animateToPage(
        currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _contentPageController.animateToPage(
        currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildGifSection() {
    return PageView.builder(
      controller: _gifPageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return Center(
          child: Image.asset(
            pages[index].gifPath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.kGray200,
                  borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
                ),
                child: const Center(
                  child: Icon(Icons.image_not_supported, size: 48),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildContentSection() {
    // Using _contentPageController instead of _pageController
    final currentPageIndex = _contentPageController.hasClients 
        ? _contentPageController.page?.round() ?? 0 
        : 0;
    
    return PageView.builder(
      controller: _contentPageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pages.length,
      itemBuilder: (context, index) {
        // Wrap the Column in SingleChildScrollView to handle overflow
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start, // Left alignment for content
            children: [
              // Updated text weight by one level down
              Text(
                pages[index].title,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppTheme.kTextGreen,
                  fontWeight: FontWeight.w800, // Changed from w900 to w800
                  fontSize: 48, // Kept the font size as 48
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: AppTheme.kSpacing2x),
              
              // Separator line - kept as is
              Container(
                width: 180,
                height: 4,
                color: AppTheme.kAccentBrown,
              ),
              SizedBox(height: AppTheme.kSpacing3x),
              
              if (pages[index].subtitle != null) ...[
                Text(
                  pages[index].subtitle!,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.kGray700,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: AppTheme.kSpacing3x),
              ],
              
              if (pages[index].input != null) ...[
                SizedBox(
                  width: double.infinity,
                  child: pages[index].input!,
                ),
                SizedBox(height: AppTheme.kSpacing4x),
              ],
              
              Align(
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
                    textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
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
                        const SizedBox(width: 8), // Fixed width
                        // Icon color set to white
                        const Icon(Icons.arrow_forward, size: 18, color: AppTheme.kWhite),
                      ],
                    ),
                  ),
                ),
              ),
              // Add some bottom padding to ensure content is visible
              SizedBox(height: AppTheme.kSpacing3x),
            ],
          ),
        );
      },
    );
  }

  bool _canProceed(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return _userName != null && _userName!.isNotEmpty;
      case 1:
        return _selectedGender != null;
      case 2:
        return _selectedAge != null;
      default:
        return false;
    }
  }

  void _handleNavigation(int currentIndex) {
    if (!_canProceed(currentIndex)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in the required information'),
          duration: const Duration(seconds: 2),
          backgroundColor: AppTheme.kErrorRed,
        ),
      );
      return;
    }

    if (currentIndex < pages.length - 1) {
      // Animate both PageViews together
      _gifPageController.animateToPage(
        currentIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _contentPageController.animateToPage(
        currentIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to home screen or handle sign in
      debugPrint('Onboarding Complete with:');
      debugPrint('Name: $_userName');
      debugPrint('Gender: $_selectedGender');
      debugPrint('Age: $_selectedAge');
      // TODO: Add navigation to home screen
    }
  }

  @override
  void dispose() {
    // Dispose both controllers
    _gifPageController.dispose();
    _contentPageController.dispose();
    super.dispose();
  }
}

class _GenderButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.kSpacing3x,
          vertical: AppTheme.kSpacing2x,
        ),
        decoration: BoxDecoration(
          color: isSelected 
            ? AppTheme.kPrimaryGreen.withOpacity(0.2)
            : Colors.transparent,
          border: Border.all(
            color: isSelected 
              ? AppTheme.kPrimaryGreen
              : AppTheme.kGray200,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isSelected 
              ? AppTheme.kPrimaryGreen
              : AppTheme.kTextGreen,
            fontWeight: isSelected 
              ? FontWeight.bold
              : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _AgeButton extends StatelessWidget {
  final String age;
  final bool isSelected;
  final VoidCallback onTap;

  const _AgeButton({
    required this.age,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppTheme.kSpacing2x),
        decoration: BoxDecoration(
          color: isSelected 
            ? AppTheme.kPrimaryGreen.withOpacity(0.2)
            : Colors.transparent,
          border: Border.all(
            color: isSelected 
              ? AppTheme.kPrimaryGreen
              : AppTheme.kGray200,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              age,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: isSelected 
                  ? AppTheme.kPrimaryGreen
                  : AppTheme.kTextGreen,
                fontWeight: isSelected 
                  ? FontWeight.bold
                  : FontWeight.normal,
              ),
            ),
            Text(
              'Years',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected 
                  ? AppTheme.kPrimaryGreen
                  : AppTheme.kTextGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}