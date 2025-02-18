import 'package:flutter/material.dart';
import '../../app/theme/theme.dart';
import '../screens/onboarding_screen.dart';
import '../screens/signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isSigningUp = false;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      // Email validation
      if (_emailController.text.isEmpty) {
        _emailError = 'Email cannot be empty';
      } else if (!_emailController.text.contains('@') || !_emailController.text.contains('.')) {
        _emailError = 'Please enter a valid email';
      } else {
        _emailError = null;
      }

      // Password validation
      if (_passwordController.text.isEmpty) {
        _passwordError = 'Password cannot be empty';
      } else if (_passwordController.text.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
      } else {
        _passwordError = null;
      }

      // Confirm password validation
      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = 'Please confirm your password';
      } else if (_confirmPasswordController.text != _passwordController.text) {
        _confirmPasswordError = 'Passwords do not match';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  void _handleSignUp() {
    _validateInputs();
    
    if (_emailError == null && _passwordError == null && _confirmPasswordError == null) {
      setState(() => _isSigningUp = true);
      
      // Here you would typically call your authentication service
      // For now, we'll simulate a delay and then navigate to onboarding
      Future.delayed(const Duration(seconds: 1), () {
        setState(() => _isSigningUp = false);
        
        // Navigate to onboarding screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.kBackgroundColor,
      body: Stack(
        children: [
          // Green circular background at top-right
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                color: AppTheme.kPrimaryGreen,
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.kSpacing4x),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hamburger menu (just for UI, functionality to be added)
                    const Align(
                      alignment: Alignment.topRight,
                      child: Icon(Icons.menu, size: 28),
                    ),
                    
                    // Title and welcome message
                    Text(
                      'Sign up',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppTheme.kTextGreen,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    
                    const SizedBox(height: AppTheme.kSpacing),
                    
                    const Divider(
                      color: AppTheme.kAccentBrown,
                      thickness: 2,
                      endIndent: 150,
                    ),
                    
                    const SizedBox(height: AppTheme.kSpacing),
                    
                    Text(
                      'Welcome to Sereni',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.kTextGreen,
                      ),
                    ),
                    
                    const SizedBox(height: AppTheme.kSpacing6x),
                    
                    // Email input
                    Text(
                      'Email Address',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.kTextGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(height: AppTheme.kSpacing),
                    
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: AppTheme.kPrimaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.email_outlined,
                            color: AppTheme.kWhite,
                          ),
                        ),
                        
                        const SizedBox(width: AppTheme.kSpacing),
                        
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'enter email address',
                              fillColor: AppTheme.kLightGreenContainer,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppTheme.kRadiusMedium),
                                borderSide: BorderSide.none,
                              ),
                              errorText: _emailError,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.kSpacing3x),
                    
                    // Password input
                    Text(
                      'Password',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.kTextGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(height: AppTheme.kSpacing),
                    
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: AppTheme.kPrimaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.key,
                            color: AppTheme.kWhite,
                          ),
                        ),
                        
                        const SizedBox(width: AppTheme.kSpacing),
                        
                        Expanded(
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'enter valid password',
                              fillColor: AppTheme.kLightGreenContainer,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppTheme.kRadiusMedium),
                                borderSide: BorderSide.none,
                              ),
                              errorText: _passwordError,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.kSpacing3x),
                    
                    // Confirm Password input
                    Text(
                      'Confirm Password',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.kTextGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(height: AppTheme.kSpacing),
                    
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: AppTheme.kPrimaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.key,
                            color: AppTheme.kWhite,
                          ),
                        ),
                        
                        const SizedBox(width: AppTheme.kSpacing),
                        
                        Expanded(
                          child: TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'enter valid password',
                              fillColor: AppTheme.kLightGreenContainer,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppTheme.kRadiusMedium),
                                borderSide: BorderSide.none,
                              ),
                              errorText: _confirmPasswordError,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.kSpacing6x),
                    
                    // Sign up button
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSigningUp ? null : _handleSignUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.kAccentBrown,
                            foregroundColor: AppTheme.kWhite,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppTheme.kSpacing2x,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: _isSigningUp
                              ? const CircularProgressIndicator(color: AppTheme.kWhite)
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Sign up',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: AppTheme.kSpacing),
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: AppTheme.kWhite,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward,
                                        color: AppTheme.kAccentBrown,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppTheme.kSpacing4x),
                    
                    // Sign in link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Have an account? ',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => const SignInScreen()),
                              );
                            },
                            child: Text(
                              'Sign in',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.kPrimaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: AppTheme.kSpacing6x),
                    
                    // Sereni logo
                    Center(
                      child: Image.asset(
                        'assets/images/sereni_logo.png', // Make sure you have this asset
                        height: 45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}