// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sereni_app/app/theme/theme.dart';

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
  int _selectedIndex = 3; // Assuming Profile is the last tab

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.kBackgroundColor,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.kLightGreenContainer,
              child: Text(
                'P',
                style: theme.textTheme.titleMedium,
              ),
            ),
            SizedBox(width: AppTheme.kSpacing2x),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Peter',
                  style: theme.textTheme.bodyLarge,
                ),
                Text(
                  'Sconl',
                  style: theme.textTheme.headlineMedium,
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: AppTheme.kTextBrown),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppTheme.kSpacing2x),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General',
              style: theme.textTheme.headlineMedium,
            ),
            SizedBox(height: AppTheme.kSpacing2x),
            
            // Notifications Toggle
            _buildSettingContainer(
              icon: Icons.notifications_none,
              title: 'notifications',
              trailing: Switch(
                value: notificationsEnabled,
                onChanged: (value) => setState(() => notificationsEnabled = value),
                activeColor: AppTheme.kAccentBrown,
              ),
            ),
            SizedBox(height: AppTheme.kSpacing2x),
            
            // Dark Mode Toggle
            _buildSettingContainer(
              icon: Icons.dark_mode_outlined,
              title: 'Dark mode',
              trailing: Switch(
                value: darkModeEnabled,
                onChanged: (value) => setState(() => darkModeEnabled = value),
                activeColor: AppTheme.kAccentBrown,
              ),
            ),
            SizedBox(height: AppTheme.kSpacing2x),
            
            // Language Dropdown
            _buildSettingContainer(
              icon: Icons.language,
              title: 'Language',
              trailing: DropdownButton<String>(
                value: selectedLanguage,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => selectedLanguage = newValue);
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
              'Privacy & Security',
              style: theme.textTheme.headlineMedium,
            ),
            SizedBox(height: AppTheme.kSpacing2x),
            
            // Emergency Contact
            Text(
              'Emergency contacts',
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
                  child: Text('+254'),
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
            
            // Password Field
            Text(
              'Password',
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
            
            Spacer(),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('log out'),
                style: theme.elevatedButtonTheme.style,
              ),
            ),
            
            // Logo
            Center(
              child: Padding(
                padding: EdgeInsets.all(AppTheme.kSpacing2x),
                child: Text(
                  'Sereni',
                  style: TextStyle(
                    color: AppTheme.kPrimaryGreen,
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
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
                GButton(icon: Icons.home, text: 'Home'),
                GButton(icon: Icons.favorite, text: 'Likes'),
                GButton(icon: Icons.search, text: 'Search'),
                GButton(icon: Icons.person, text: 'Profile'),
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