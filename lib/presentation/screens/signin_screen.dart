// signin_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../app/theme.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import '../widgets/background_decorator_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSigningIn = false;
  bool _showPassword = false;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      // Basic email validation
      if (_emailController.text.isEmpty) {
        _emailError = 'Email cannot be empty';
      } else if (!_emailController.text.contains('@') || !_emailController.text.contains('.')) {
        _emailError = 'Please enter a valid email';
      } else {
        _emailError = null;
      }

      // Basic password validation
      if (_passwordController.text.isEmpty) {
        _passwordError = 'Password cannot be empty';
      } else if (_passwordController.text.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
      } else {
        _passwordError = null;
      }
    });
  }

  // Extract username from email
  String _extractUsername(String email) {
    if (email.isEmpty || !email.contains('@')) return '';
    return email.split('@')[0].replaceAll('.', ' ').split('+')[0];
  }

  // Get capitalized username
  String _getCapitalizedUsername(String email) {
    String username = _extractUsername(email);
    if (username.isEmpty) return '';
    
    // Capitalize each word
    List<String> parts = username.split(' ');
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        parts[i] = parts[i][0].toUpperCase() + parts[i].substring(1);
      }
    }
    return parts.join(' ');
  }

  Future<void> _handleSignIn() async {
    _validateInputs();
    
    if (_emailError == null && _passwordError == null) {
      setState(() => _isSigningIn = true);

      try {
        // Attempt to sign in with Firebase

      
        // ignore: unused_local_variable
        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      

        if (!mounted) return;
        
        // If successful, show success dialog and navigate
        setState(() => _isSigningIn = false);
        _showSuccessDialog();
        
      } on FirebaseAuthException catch (e) {
        setState(() => _isSigningIn = false);
        
        String errorCode = e.code;
        _showErrorDialog(errorCode);
      } catch (e) {
        setState(() => _isSigningIn = false);
        _showErrorDialog('unknown-error');
      }
    }
  }

  void _showSuccessDialog() {
    String username = _getCapitalizedUsername(_emailController.text);
    String greeting = username.isNotEmpty ? 'Welcome back, $username!' : 'Welcome Back!';
    
    final dialogWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.kRadiusMedium),
          ),
          insetPadding: EdgeInsets.symmetric(
            horizontal: isLandscape ? dialogWidth * 0.2 : dialogWidth * 0.05,
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
                  greeting,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppTheme.kTextGreen,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.kSpacing),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('✨', style: TextStyle(fontSize: 24)),
                    Text('🌟', style: TextStyle(fontSize: 24)),
                    Text('✨', style: TextStyle(fontSize: 24)),
                  ],
                ),
                const SizedBox(height: AppTheme.kSpacing),
                const Divider(),
                const SizedBox(height: AppTheme.kSpacing),
                Text(
                  'Sign in Successful!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppTheme.kSpacing),
                Text(
                  username.isNotEmpty
                    ? "It's great to see you again, $username! Your wellness journey awaits..."
                    : "Continue your wellness journey...",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.kSpacing3x),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(String errorCode) {
    String username = _getCapitalizedUsername(_emailController.text);
    String title = 'Sign In Issue';
    String message = 'An unexpected error occurred. Please try again.';
    bool showSignUpOption = false;
    
    // Customize error message based on error code
    switch (errorCode) {
      case 'user-not-found':
        title = 'Hmm, Who Goes There?';
        message = username.isNotEmpty
            ? "Looks like we can't find $username in our records. Are you sure you've signed up with us before?"
            : "We couldn't find your account in our records. Perhaps you need to sign up first?";
        showSignUpOption = true;
        break;
      case 'wrong-password':
        title = 'Password Mismatch';
        message = username.isNotEmpty
            ? "That's not the right password for $username's account. Maybe try another one?"
            : "That password doesn't match our records. Want to try again?";
        break;
      case 'invalid-email':
        title = 'Email Confusion';
        message = "That email address doesn't look quite right. Could you double-check it?";
        break;
      case 'user-disabled':
        title = 'Account Locked';
        message = username.isNotEmpty
            ? "We're sorry, but $username's account has been disabled. Please contact support."
            : "This account has been disabled. Please contact our support team for assistance.";
        break;
      case 'too-many-requests':
        title = 'Whoa, Slow Down!';
        message = "You've tried signing in too many times. Please wait a bit before trying again.";
        break;
      case 'unknown-error':
        title = 'Well, This Is Awkward...';
        message = "Something unexpected happened. Our team of digital hamsters are working on it!";
        break;
    }

    final dialogWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.kRadiusMedium),
          ),
          insetPadding: EdgeInsets.symmetric(
            horizontal: isLandscape ? dialogWidth * 0.2 : dialogWidth * 0.05,
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
                  title,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppTheme.kTextBrown,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.kSpacing),
                const Divider(),
                const SizedBox(height: AppTheme.kSpacing),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.kSpacing3x),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.kGray400,
                      ),
                      child: const Text('Try Again'),
                    ),
                    if (showSignUpOption) ...[
                      const SizedBox(width: AppTheme.kSpacing2x),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const SignUpScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.kPrimaryGreen,
                        ),
                        child: const Text('Sign Up Instead'),
                      ),
                    ],
                  ],
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
    
    // Create simple app bar with back button and centered title
    final appBar = PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.kSpacing2x),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppTheme.kTextBrown),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppTheme.kSpacing),
                child: Text(
                  'Sign In',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppTheme.kTextBrown,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              // Empty SizedBox to balance the back button
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
    
    return Scaffold(
      appBar: appBar,
      body: BackgroundDecorator(
        child: SafeArea(
          child: isLandscape
              ? _buildLandscapeLayout(context, formContent)
              : _buildPortraitLayout(context, formContent),
        ),
      ),
      backgroundColor: AppTheme.kBackgroundColor,
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, Widget formContent) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double horizontalMargin = screenWidth * 0.1; // 80% of screen width (10% margins on each side)
    
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
                  'assets/gifs/sign_in.gif',
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double horizontalMargin = screenWidth * 0.05; // 90% of screen width (5% margins on each side)
    
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalMargin,
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
          'Welcome Back',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: AppTheme.kTextBrown,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: AppTheme.kSpacing),

        Text(
          'Enter your credentials to continue your journey',
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
              child: TextFormField(
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
            ),
          ],
        ),

        const SizedBox(height: AppTheme.kSpacing6x),
        
        // Sign in button
        Center(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSigningIn ? null : _handleSignIn,
              child: _isSigningIn
                ? const CircularProgressIndicator(color: AppTheme.kWhite)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text(
                        'Sign in',
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
        
        // Sign up link
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account? ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.kTextBrown,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                },
                child: Text(
                  'Sign Up',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.kPrimaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: AppTheme.kSpacing2x),
        
        // Forgot password link
        Center(
          child: InkWell(
            onTap: () async {
              if (_emailController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter your email address first'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              
              try {
                await FirebaseAuth.instance.sendPasswordResetEmail(
                  email: _emailController.text.trim(),
                );
                
                if (!mounted) return;
                
                String username = _getCapitalizedUsername(_emailController.text);
                String message = username.isNotEmpty
                  ? "We've sent a password reset link to $username's email. Check your inbox!"
                  : "Password reset email sent! Check your inbox";
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: Colors.green,
                  ),
                );
              } on FirebaseAuthException catch (e) {
                String message = 'Could not send reset email';
                if (e.code == 'user-not-found') {
                  message = 'No user found with this email address';
                }
                
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(
              'Forgot Password?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.kTextBrown,
              ),
            ),
          ),
        ),
      ],
    );
  }
}