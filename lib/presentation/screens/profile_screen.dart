import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sereni_app/app/theme.dart';
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
  Map<String, bool> passwordVisibility = {
    'current': false,
    'new': false,
    'confirm': false,
  };
  int _selectedIndex = 3;
  String? _imagePath;
  String selectedAreaCode = '+254';
  
  // Controllers
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emergencyNameController = TextEditingController();
  final TextEditingController _emergencyPhoneController = TextEditingController();

  // Emergency contacts list
  List<Map<String, String>> emergencyContacts = [];

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

  void _showSuccessDialog() {
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
                'Password Updated Successfully!',
                style: Theme.of(context).textTheme.headlineMedium,
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

  void _addEmergencyContact() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Emergency Contact', style: Theme.of(context).textTheme.headlineMedium),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _emergencyNameController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
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
                      child: TextField(
                        controller: _emergencyPhoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  emergencyContacts.add({
                    'name': _emergencyNameController.text,
                    'phone': '$selectedAreaCode ${_emergencyPhoneController.text}',
                  });
                });
                _emergencyNameController.clear();
                _emergencyPhoneController.clear();
                Navigator.pop(context);
              },
              child: const Text('Add Contact'),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Change Password', style: Theme.of(context).textTheme.headlineMedium),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _currentPasswordController,
                      obscureText: !passwordVisibility['current']!,
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisibility['current']! ? Icons.visibility_off : Icons.visibility,
                            color: AppTheme.kTextBrown,
                          ),
                          onPressed: () => setState(() => 
                            passwordVisibility['current'] = !passwordVisibility['current']!
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _newPasswordController,
                      obscureText: !passwordVisibility['new']!,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisibility['new']! ? Icons.visibility_off : Icons.visibility,
                            color: AppTheme.kTextBrown,
                          ),
                          onPressed: () => setState(() => 
                            passwordVisibility['new'] = !passwordVisibility['new']!
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: !passwordVisibility['confirm']!,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisibility['confirm']! ? Icons.visibility_off : Icons.visibility,
                            color: AppTheme.kTextBrown,
                          ),
                          onPressed: () => setState(() => 
                            passwordVisibility['confirm'] = !passwordVisibility['confirm']!
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_newPasswordController.text == _confirmPasswordController.text) {
                      Navigator.pop(context);
                      _showSuccessDialog();
                      _currentPasswordController.clear();
                      _newPasswordController.clear();
                      _confirmPasswordController.clear();
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

                Text(
                  'emergencyContacts'.tr(),
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.kLightGreenContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(50),
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
                      if (emergencyContacts.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ...emergencyContacts.map((contact) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  
                                  Text(contact['name']!),
                                  Text(contact['phone']!, style: theme.textTheme.bodySmall),
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
                        )).toList(),
                      ],
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  'password'.tr(),
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.kLightGreenContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: GestureDetector(
                    onTap: _showChangePasswordDialog,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Change Password', style: theme.textTheme.bodyLarge),
                        const Icon(Icons.arrow_forward_ios, color: AppTheme.kTextBrown),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: AppTheme.kSpacing3x),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement logout logic here
                    },
                    style: theme.elevatedButtonTheme.style,
                    child: Text('logout'.tr()),
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