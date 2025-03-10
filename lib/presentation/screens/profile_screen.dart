// Path: lib/presentation/screens/profile_screen.dart

// Author: Dycoh Gacheri (https://github.com/Dycoh)
// Description: Profile screen that allows users to manage personal settings,
// emergency contacts, and security preferences. Implements responsive layout
// with consistent UI patterns.

// Last Modified: Sunday, 09 March 2025 12:30

// Core/Framework imports
import 'package:flutter/material.dart';
import 'dart:io';

// External package imports
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

// Project imports - Theme & routes
import 'package:sereni_app/app/theme.dart';
import '../../../app/routes.dart';


// Project imports - Layout
import '../../shared/layout/app_layout.dart';
import '../../app/scaffold.dart';
import '../screens/signin_screen.dart';

// Project imports - Services
//import '../../data/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // User preferences
  bool notificationsEnabled = true;
  bool darkModeEnabled = true;
  String selectedLanguage = 'English';
  
  // Password visibility toggles
  Map<String, bool> passwordVisibility = {
    'current': false,
    'new': false,
    'confirm': false,
  };
  
  // Navigation index
  int _selectedIndex = 3;
  
  // Profile image
  String? _imagePath;
  
  // Phone settings
  String selectedAreaCode = '+254';
  
  // Mock user data - in production, this would come from a user service
  final String _mockCurrentPassword = 'Password123';
  
  // Text editing controllers
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emergencyNameController = TextEditingController();
  final TextEditingController _emergencyPhoneController = TextEditingController();

  // Form keys for validation
  final _emergencyContactFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  // Emergency contacts list
  List<Map<String, String>> emergencyContacts = [];

  // Available language options
  final List<String> languages = [
    'English',
    'Mandarin',
    'Spanish',
    'Hindi',
    'Arabic',
    'French',
    'Portuguese',
    'Bengali',
    'Russian',
    'Japanese'
  ];

  // Available area codes
  final List<String> areaCodes = [
    '+254',
    '+1',
    '+44',
    '+86',
    '+91',
    '+81',
    '+55',
    '+7',
    '+33',
    '+49'
  ];

  // Select profile image from gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  // Show success dialog for password update
  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎊 🎉 🎈', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Show error dialog for validation failures
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
          ),
          title: Text(title, style: Theme.of(context).textTheme.headlineMedium),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Add emergency contact with validation
  void _addEmergencyContact() {
    // Reset form controllers
    _emergencyNameController.clear();
    _emergencyPhoneController.clear();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Emergency Contact', style: Theme.of(context).textTheme.headlineMedium),
          content: Form(
            key: _emergencyContactFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _emergencyNameController,
                    decoration: const InputDecoration(
                      labelText: 'Contact Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.kLightGreenContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: DropdownButton<String>(
                          value: selectedAreaCode,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() => selectedAreaCode = newValue);
                            }
                          },
                          items: areaCodes.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          underline: Container(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _emergencyPhoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            prefixIcon: Icon(Icons.phone_outlined),
                            hintText: '123456789',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone number is required';
                            }
                            
                            // Check if it has exactly 9 digits
                            if (value.replaceAll(RegExp(r'[^0-9]'), '').length != 9) {
                              return 'Phone number must be 9 digits';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate the form
                if (_emergencyContactFormKey.currentState!.validate()) {
                  setState(() {
                    emergencyContacts.add({
                      'name': _emergencyNameController.text.trim(),
                      'phone': '$selectedAreaCode ${_emergencyPhoneController.text.trim()}',
                    });
                  });
                  Navigator.pop(context);
                  _showSuccessDialog(
                    'Contact Added Successfully',
                    'Emergency contact has been added to your profile'
                  );
                }
              },
              child: const Text('Add Contact'),
            ),
          ],
        );
      },
    );
  }

  // Show password change dialog with validation
  void _showChangePasswordDialog() {
    // Reset password form
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    
    // Reset password visibility
    setState(() {
      passwordVisibility = {
        'current': false,
        'new': false,
        'confirm': false,
      };
    });
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Change Password', style: Theme.of(context).textTheme.headlineMedium),
              content: Form(
                key: _passwordFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _currentPasswordController,
                        obscureText: !passwordVisibility['current']!,
                        decoration: InputDecoration(
                          labelText: 'Current Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisibility['current']! ? Icons.visibility_off : Icons.visibility,
                              color: AppTheme.kTextBrown,
                            ),
                            onPressed: () => setDialogState(() => 
                              passwordVisibility['current'] = !passwordVisibility['current']!
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your current password';
                          }
                          if (value != _mockCurrentPassword) {
                            return 'Current password is incorrect';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: !passwordVisibility['new']!,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisibility['new']! ? Icons.visibility_off : Icons.visibility,
                              color: AppTheme.kTextBrown,
                            ),
                            onPressed: () => setDialogState(() => 
                              passwordVisibility['new'] = !passwordVisibility['new']!
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !passwordVisibility['confirm']!,
                        decoration: InputDecoration(
                          labelText: 'Confirm New Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisibility['confirm']! ? Icons.visibility_off : Icons.visibility,
                              color: AppTheme.kTextBrown,
                            ),
                            onPressed: () => setDialogState(() => 
                              passwordVisibility['confirm'] = !passwordVisibility['confirm']!
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your new password';
                          }
                          if (value != _newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validate form
                    if (_passwordFormKey.currentState!.validate()) {
                      Navigator.pop(context);
                      // In a real app, we would update the password in a secure way
                      _showSuccessDialog(
                        'Password Updated Successfully!',
                        'Your password has been changed. Please use your new password the next time you log in.'
                      );
                    }
                  },
                  child: const Text('Update Password'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Logout functionality
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout', style: Theme.of(context).textTheme.headlineMedium),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                
                // In a real app, we would use AuthService to handle logout
                // AuthService.logout();
                
                // Navigate to login screen
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/sign-in', 
                  (Route<dynamic> route) => false
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(204, 228, 30, 40),
              ),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  // Build a settings container with consistent styling
  Widget _buildSettingContainer({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.kSpacing2x,
        vertical: AppTheme.kSpacing,
      ),
      decoration: BoxDecoration(
        color: AppTheme.kLightGreenContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.kTextBrown, size: 20),
              SizedBox(width: AppTheme.kSpacing2x),
              Text(title),
            ],
          ),
          trailing,
        ],
      ),
    );
  }

  // Map language names to locale codes
  String _getLocaleCode(String language) {
    switch (language.toLowerCase()) {
      case 'english': return 'en';
      case 'spanish': return 'es';
      case 'french': return 'fr';
      case 'mandarin': return 'zh';
      case 'arabic': return 'ar';
      case 'hindi': return 'hi';
      case 'portuguese': return 'pt';
      case 'bengali': return 'bn';
      case 'russian': return 'ru';
      case 'japanese': return 'ja';
      default: return 'en';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Create the profile screen content
    Widget profileContent = SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: AppTheme.kSpacing2x,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header with avatar and name
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: AppTheme.kLightGreenContainer,
                          backgroundImage: _imagePath != null
                              ? FileImage(File(_imagePath!))
                              : null,
                          child: _imagePath == null
                              ? Icon(Icons.person, size: 60, color: AppTheme.kTextBrown)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppTheme.kAccentBrown,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppTheme.kSpacing2x),
                  Text(
                    'Peter Sconl',
                    style: theme.textTheme.headlineMedium,
                  ),
                  Text(
                    'Member since January 2025',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppTheme.kSpacing3x),

            // General settings section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'general'.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  SizedBox(height: AppTheme.kSpacing),
                  
                  _buildSettingContainer(
                    icon: Icons.notifications_none,
                    title: 'notifications'.tr(),
                    trailing: Switch(
                      value: notificationsEnabled,
                      onChanged: (value) => setState(() => notificationsEnabled = value),
                      activeColor: AppTheme.kAccentBrown,
                    ),
                  ),
                  SizedBox(height: AppTheme.kSpacing2x),
                  
                  _buildSettingContainer(
                    icon: Icons.dark_mode_outlined,
                    title: 'darkMode'.tr(),
                    trailing: Switch(
                      value: darkModeEnabled,
                      onChanged: (value) => setState(() => darkModeEnabled = value),
                      activeColor: AppTheme.kAccentBrown,
                    ),
                  ),
                  SizedBox(height: AppTheme.kSpacing2x),
                  
                  _buildSettingContainer(
                    icon: Icons.language,
                    title: 'language'.tr(),
                    trailing: DropdownButton<String>(
                      value: selectedLanguage,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() => selectedLanguage = newValue);
                          context.setLocale(Locale(_getLocaleCode(newValue)));
                        }
                      },
                      items: languages.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      underline: Container(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppTheme.kSpacing3x),
            
            // Privacy and security section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'privacySecurity'.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  SizedBox(height: AppTheme.kSpacing),

                  // Emergency contacts section
                  Text(
                    'emergencyContacts'.tr(),
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.kLightGreenContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Emergency Contacts',
                              style: theme.textTheme.bodyLarge,
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: _addEmergencyContact,
                              color: AppTheme.kAccentBrown,
                            ),
                          ],
                        ),
                        if (emergencyContacts.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'No emergency contacts added yet',
                              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                            ),
                          ),
                        if (emergencyContacts.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          ...emergencyContacts.map((contact) => Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            elevation: 0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 16,
                                        backgroundColor: AppTheme.kLightGreenContainer,
                                        child: Icon(Icons.person, size: 16, color: AppTheme.kTextBrown),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(contact['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                          Text(contact['phone']!, style: theme.textTheme.bodySmall),
                                        ],
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () {
                                      setState(() {
                                        emergencyContacts.remove(contact);
                                      });
                                    },
                                    color: AppTheme.kErrorRed,
                                  ),
                                ],
                              ),
                            ),
                          )).toList(),
                        ],
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Password section
                  Text(
                    'password'.tr(),
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _showChangePasswordDialog,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.kLightGreenContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lock_outline, size: 20, color: AppTheme.kTextBrown),
                              const SizedBox(width: 12),
                              Text('Change Password', style: theme.textTheme.bodyLarge),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_ios, color: AppTheme.kTextBrown, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppTheme.kSpacing3x),
            
            // Logout button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _handleLogout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 139, 69, 19),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: Text(
                  'logout'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            // Logo at bottom
            Center(
              child: Padding(
                padding: EdgeInsets.all(AppTheme.kSpacing2x),
                child: Image.asset(
                  'assets/logos/sereni_logo.png',
                  height: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    
    // Use AppScaffold to wrap the profile content
    return AppScaffold(
      title: 'Profile',
      currentRoute: '/profile',
      layoutType: LayoutType.contentOnly,
      contentWidthFraction: 0.92, // Slightly wider content area for profile
      useBackgroundDecorator: true,
      body: profileContent,
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }
}