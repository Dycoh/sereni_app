import 'package:flutter/material.dart';
import '../../app/theme/theme.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';
import 'signin_screen.dart';
import '../widgets/custom_appbar_widget.dart';
import '../widgets/background_decorator_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isSigningUp = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  double _passwordStrength = 0.0;
  Color _passwordStrengthColor = Colors.grey;
  String _passwordFeedback = 'Type something magical...';

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updatePasswordStrength);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength() {
    String password = _passwordController.text;
    double strength = 0.0;
    
    if (password.isEmpty) {
      strength = 0.0;
      _passwordStrengthColor = Colors.grey;
      _passwordFeedback = 'Type something magical...';
    } else {
      // Calculate strength based on length (up to 0.4)
      if (password.length >= 8) {
        strength += 0.4;
      } else if (password.length >= 6) {
        strength += 0.2;
      } else {
        strength += 0.1;
      }
      
      // Check for uppercase (0.2)
      if (password.contains(RegExp(r'[A-Z]'))) {
        strength += 0.2;
      }
      
      // Check for numbers (0.2)
      if (password.contains(RegExp(r'[0-9]'))) {
        strength += 0.2;
      }
      
      // Check for special characters (0.2)
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        strength += 0.2;
      }
      
      // Set color and feedback based on strength
      if (strength < 0.3) {
        _passwordStrengthColor = Colors.red;
        _passwordFeedback = 'Even my grandma could crack this one!';
      } else if (strength < 0.7) {
        _passwordStrengthColor = Colors.orange;
        _passwordFeedback = 'Getting warmer, but hackers are still laughing';
      } else {
        _passwordStrengthColor = Colors.green;
        _passwordFeedback = 'Fort Knox would be jealous of this security!';
      }
    }
    
    setState(() {
      _passwordStrength = strength;
    });
  }

  void _validateInputs() {
    setState(() {
      // Name validation
      if (_nameController.text.isEmpty) {
        _nameError = 'Name cannot be empty';
      } else if (_nameController.text.length < 2) {
        _nameError = 'Name must be at least 2 characters';
      } else {
        _nameError = null;
      }

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
    
    if (_nameError == null && _emailError == null && 
        _passwordError == null && _confirmPasswordError == null) {
      setState(() => _isSigningUp = true);

      // Here you would typically call your authentication service
      // For now, we'll simulate a delay and then navigate to home screen
      Future.delayed(const Duration(seconds: 1), () {
        setState(() => _isSigningUp = false);
        _showSuccessDialog();
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.kRadiusMedium),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.kSpacing4x),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/logos/sereni_logo.png',
                  height: 60,
                ),
                const SizedBox(height: AppTheme.kSpacing2x),
                Text(
                  'Welcome to Sereni!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.kTextGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.kSpacing),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🎉', style: TextStyle(fontSize: 24)),
                    Text('🌟', style: TextStyle(fontSize: 24)),
                    Text('🎉', style: TextStyle(fontSize: 24)),
                  ],
                ),
                const SizedBox(height: AppTheme.kSpacing),
                const Divider(),
                const SizedBox(height: AppTheme.kSpacing),
                Text(
                  'Account Created Successfully!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppTheme.kSpacing),
                Text(
                  'Your wellness journey begins now...',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.kSpacing3x),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    // Navigate to home screen
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                  child: const Text('Get Started'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLandscape = 
        MediaQuery.of(context).orientation == Orientation.landscape &&
        MediaQuery.of(context).size.width >= 600;
        
    final formContent = _buildFormContent(context);
    
    return Scaffold(
      backgroundColor: AppTheme.kBackgroundColor,
      appBar: CustomAppBar(
        leadingWidgets: [
          Image.asset(
            'assets/logos/sereni_logo.png',
            height: 30,
          ),
          const SizedBox(width: 16),
          const SizedBox(
            height: 50,
            child: VerticalDivider(
              color: AppTheme.kTextBrown,
              thickness: 1,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Sign Up',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppTheme.kTextBrown,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      body: BackgroundDecorator(
        child: SafeArea(
          child: isLandscape
              ? _buildLandscapeLayout(context, formContent)
              : _buildPortraitLayout(context, formContent),
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, Widget formContent) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double horizontalMargin = screenWidth * 0.1;
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalMargin,
        vertical: AppTheme.kSpacing2x,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 45,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
                child: Image.asset(
                  'assets/gifs/sign_up.gif',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: AppTheme.kSpacing4x),
          
          Expanded(
            flex: 55,
            child: Center(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppTheme.kSpacing4x),
                  child: formContent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, Widget formContent) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.kSpacing2x,
        vertical: AppTheme.kSpacing2x,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.kSpacing4x),
          child: formContent,
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Join Sereni',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: AppTheme.kTextBrown,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: AppTheme.kSpacing),

        Text(
          'Create your account to start your wellness journey',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.kTextBrown.withOpacity(0.7),
          ),
        ),

        const SizedBox(height: AppTheme.kSpacing2x),

        const Divider(
          color: AppTheme.kAccentBrown,
          thickness: 2,
          endIndent: 150,
        ),

        const SizedBox(height: AppTheme.kSpacing3x),

        // Name input
        Text(
          'Full Name',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppTheme.kTextBrown,
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
                Icons.person_outline,
                color: AppTheme.kWhite,
              ),
            ),
            
            const SizedBox(width: AppTheme.kSpacing),
            
            Expanded(
              child: TextFormField(
                controller: _nameController,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.kTextBrown,
                ),
                decoration: InputDecoration(
                  hintText: 'enter your full name',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.kTextBrown.withAlpha(153),
                  ),
                  fillColor: AppTheme.kPrimaryGreen.withOpacity(0.1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide.none,
                  ),
                  errorText: _nameError,
                  errorStyle: TextStyle(color: AppTheme.kErrorRed),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.kSpacing2x,
                    vertical: AppTheme.kSpacing2x,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppTheme.kSpacing3x),
        
        // Email input
        Text(
          'Email Address',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppTheme.kTextBrown,
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.kTextBrown,
                ),
                decoration: InputDecoration(
                hintText: 'enter email address',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.kTextBrown.withAlpha(153),
                  ),
                  fillColor: AppTheme.kPrimaryGreen.withOpacity(0.1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide.none,
                  ),
                  errorText: _emailError,
                  errorStyle: TextStyle(color: AppTheme.kErrorRed),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.kSpacing2x,
                    vertical: AppTheme.kSpacing2x,
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppTheme.kSpacing3x),
        
        // Password input
        Text(
          'Password',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppTheme.kTextBrown,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.kTextBrown,
                    ),
                    decoration: InputDecoration(
                      hintText: 'enter password',
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.kTextBrown.withAlpha(153),
                      ),
                      fillColor: AppTheme.kPrimaryGreen.withOpacity(0.1),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide.none,
                      ),
                      errorText: _passwordError,
                      errorStyle: TextStyle(color: AppTheme.kErrorRed),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.kSpacing2x,
                        vertical: AppTheme.kSpacing2x,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword ? Icons.visibility_off : Icons.visibility,
                          color: AppTheme.kTextBrown,
                        ),
                        onPressed: () => setState(() => _showPassword = !_showPassword),
                      ),
                    ),
                  ),
                  if (_passwordController.text.isNotEmpty) ...[
                    const SizedBox(height: AppTheme.kSpacing2x),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _passwordStrength,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(_passwordStrengthColor),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: AppTheme.kSpacing),
                    Text(
                      _passwordFeedback,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.kTextBrown,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: AppTheme.kSpacing3x),
        
        // Confirm Password input
        Text(
          'Confirm Password',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppTheme.kTextBrown,
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
                Icons.lock_outline,
                color: AppTheme.kWhite,
              ),
            ),
            
            const SizedBox(width: AppTheme.kSpacing),
            
            Expanded(
              child: TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_showConfirmPassword,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.kTextBrown,
                ),
                decoration: InputDecoration(
                  hintText: 'confirm your password',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.kTextBrown.withAlpha(153),
                  ),
                  fillColor: AppTheme.kPrimaryGreen.withOpacity(0.1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide.none,
                  ),
                  errorText: _confirmPasswordError,
                  errorStyle: TextStyle(color: AppTheme.kErrorRed),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.kSpacing2x,
                    vertical: AppTheme.kSpacing2x,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      color: AppTheme.kTextBrown,
                    ),
                    onPressed: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                  ),
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
              child: _isSigningUp
                  ? const CircularProgressIndicator(color: AppTheme.kWhite)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Create Account',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppTheme.kWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: AppTheme.kSpacing),
                        const Icon(
                          Icons.arrow_forward,
                          color: AppTheme.kWhite,
                          size: 20,
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
                'Already have an account? ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.kTextBrown,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                  );
                },
                child: Text(
                  'Sign In',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.kPrimaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}