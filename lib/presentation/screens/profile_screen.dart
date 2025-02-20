import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sereni_app/app/theme/theme.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/navigation_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = true;
  String selectedLanguage = 'English';
  bool isPasswordVisible = false;
  String emergencyContact = '';
  int _selectedIndex = 3;
  String? _imagePath;
  String selectedAreaCode = '+254';
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password', style: Theme.of(context).textTheme.headlineMedium),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPasswordField(
                  controller: _currentPasswordController,
                  label: 'Current Password',
                ),
                SizedBox(height: AppTheme.kSpacing2x),
                _buildPasswordField(
                  controller: _newPasswordController,
                  label: 'New Password',
                ),
                SizedBox(height: AppTheme.kSpacing2x),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Confirm New Password',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement password change logic here
                Navigator.pop(context);
              },
              child: Text('Update Password'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: AppTheme.kTextBrown,
          ),
          onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return CustomScaffold(
      currentRoute: '/profile',
      title: 'Profile',
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: AppTheme.kSpacing2x,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image and Name section remains the same
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: AppTheme.kLightGreenContainer,
                          backgroundImage: _imagePath != null
                              ? FileImage(File(_imagePath!))
                              : null,
                          child: _imagePath == null
                              ? Icon(Icons.person, size: 50, color: AppTheme.kTextBrown)
                              : null,
                        ),
                      ),
                      SizedBox(height: AppTheme.kSpacing2x),
                      Text(
                        'Peter',
                        style: theme.textTheme.headlineMedium,
                      ),
                      Text(
                        'Sconl',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppTheme.kSpacing3x),

                Text(
                  'general'.tr(),
                  style: theme.textTheme.displayMedium,
                ),
                SizedBox(height: AppTheme.kSpacing2x),
                
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
                SizedBox(height: AppTheme.kSpacing3x),
                
                Text(
                  'privacySecurity'.tr(),
                  style: theme.textTheme.displayMedium,
                ),
                SizedBox(height: AppTheme.kSpacing2x),
                
                // Emergency Contacts section remains the same
                Text(
                  'emergencyContacts'.tr(),
                  style: theme.textTheme.bodyLarge,
                ),
                SizedBox(height: AppTheme.kSpacing),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppTheme.kSpacing2x),
                      decoration: BoxDecoration(
                        color: AppTheme.kLightGreenContainer,
                        borderRadius: BorderRadius.circular(AppTheme.kRadiusMedium),
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
                    SizedBox(width: AppTheme.kSpacing),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.kLightGreenContainer,
                          borderRadius: BorderRadius.circular(AppTheme.kRadiusMedium),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(AppTheme.kSpacing2x),
                          ),
                          onChanged: (value) => setState(() => emergencyContact = value),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.kSpacing2x),
                
                // Modified Password section
                Text(
                  'password'.tr(),
                  style: theme.textTheme.bodyLarge,
                ),
                SizedBox(height: AppTheme.kSpacing),
                GestureDetector(
                  onTap: _showChangePasswordDialog,
                  child: Container(
                    padding: EdgeInsets.all(AppTheme.kSpacing2x),
                    decoration: BoxDecoration(
                      color: AppTheme.kLightGreenContainer,
                      borderRadius: BorderRadius.circular(AppTheme.kRadiusMedium),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Change Password', style: theme.textTheme.bodyLarge),
                        Icon(Icons.arrow_forward_ios, color: AppTheme.kTextBrown),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: AppTheme.kSpacing3x),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('logout'.tr()),
                    style: theme.elevatedButtonTheme.style,
                  ),
                ),
                
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
        ),
      ),
    );
  }

  String _getLocaleCode(String language) {
    // Language code mapping remains the same
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

  Widget _buildSettingContainer({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.kSpacing2x,
        vertical: AppTheme.kSpacing, // Reduced height
      ),
      decoration: BoxDecoration(
        color: AppTheme.kLightGreenContainer.withOpacity(0.3), // Adjusted opacity
        borderRadius: BorderRadius.circular(50.0), // Pill shape
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.kTextBrown, size: 20), // Slightly smaller icon
              SizedBox(width: AppTheme.kSpacing2x),
              Text(title),
            ],
          ),
          trailing,
        ],
      ),
    );
  }
}