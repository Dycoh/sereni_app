import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sereni_app/app/theme/theme.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.kBackgroundColor,
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
                // Profile Image and Name
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
                  style: theme.textTheme.headlineMedium,
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
                  style: theme.textTheme.headlineMedium,
                ),
                SizedBox(height: AppTheme.kSpacing2x),
                
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
                
                Text(
                  'password'.tr(),
                  style: theme.textTheme.bodyLarge,
                ),
                SizedBox(height: AppTheme.kSpacing),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.kLightGreenContainer,
                    borderRadius: BorderRadius.circular(AppTheme.kRadiusMedium),
                  ),
                  child: TextField(
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(AppTheme.kSpacing2x),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                          color: AppTheme.kTextBrown,
                        ),
                        onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
                      ),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.kSpacing2x,
              vertical: AppTheme.kSpacing,
            ),
            child: GNav(
              rippleColor: AppTheme.kLightGreenContainer,
              hoverColor: AppTheme.kLightGreenContainer,
              gap: 8,
              activeColor: AppTheme.kPrimaryGreen,
              iconSize: 24,
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.kSpacing2x,
                vertical: AppTheme.kSpacing,
              ),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: AppTheme.kLightGreenContainer,
              color: AppTheme.kGray600,
              tabs: [
                GButton(icon: Icons.home, text: 'home'.tr()),
                GButton(icon: Icons.favorite, text: 'likes'.tr()),
                GButton(icon: Icons.search, text: 'search'.tr()),
                GButton(icon: Icons.person, text: 'profile'.tr()),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() => _selectedIndex = index);
              },
            ),
          ),
        ),
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

  Widget _buildSettingContainer({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return Container(
      padding: EdgeInsets.all(AppTheme.kSpacing2x),
      decoration: BoxDecoration(
        color: AppTheme.kLightGreenContainer,
        borderRadius: BorderRadius.circular(AppTheme.kRadiusMedium),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.kTextBrown),
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