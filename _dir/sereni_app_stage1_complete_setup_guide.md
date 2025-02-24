# Stage 1: Complete Setup Guide
## Sereni Mental Health App

## Prerequisites Setup

### 1. Development Environment
```bash
# Check Flutter installation
flutter doctor -v

# Update Flutter to latest stable
flutter upgrade
flutter channel stable
```

Required versions:
- Flutter: ≥3.19.0
- Dart: ≥3.3.0
- Java: ≥11
- Android Studio: Latest version
- VS Code: Latest version with Flutter/Dart extensions

### 2. Git & GitHub Setup
```bash
# Configure Git globally
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Create GitHub repository
# Name: sereni-mental-health
# Description: AI-driven mental health companion application for daily emotional support
```

Create `.gitignore`:
```plaintext
# Flutter/Dart specific
**/doc/api/
**/ios/Flutter/.last_build_id
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
/build/
*.lock
*.log

# Android specific
**/android/**/gradle-wrapper.jar
**/android/.gradle
**/android/captures/
**/android/gradlew
**/android/gradlew.bat
**/android/local.properties
**/android/**/GeneratedPluginRegistrant.*

# iOS specific
**/ios/**/*.mode1v3
**/ios/**/*.mode2v3
**/ios/**/*.moved-aside
**/ios/**/*.pbxuser
**/ios/**/*.perspectivev3
**/ios/**/*sync/
**/ios/**/.sconsign.dblite
**/ios/**/.tags*
**/ios/**/.vagrant/
**/ios/**/DerivedData/
**/ios/**/Icon?
**/ios/**/Pods/
**/ios/**/.symlinks/
**/ios/**/profile
**/ios/**/xcuserdata
**/ios/.generated/
**/ios/Flutter/App.framework
**/ios/Flutter/Flutter.framework
**/ios/Flutter/Generated.xcconfig
**/ios/Flutter/app.flx
**/ios/Flutter/app.zip
**/ios/Flutter/flutter_assets/
**/ios/ServiceDefinitions.json
**/ios/Runner/GeneratedPluginRegistrant.*

# IDE specific
.idea/
.vscode/
*.iml
*.iws
.DS_Store
```

## Project Creation & Initial Setup

### 1. Create Flutter Project
```bash
# Create new Flutter project
flutter create \
  --org com.sereni \
  --project-name sereni_app \
  --platforms android,ios,web \
  --description "AI-driven mental health companion" \
  sereni_app

cd sereni_app

git init
git add .
git commit -m "Initial commit: Flutter project creation"
```
### 2. Add Dependencies
Update `pubspec.yaml`:
```yaml
name: sereni
description: AI-driven mental health companion

publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.4
  equatable: ^2.0.5
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2
  
  # UI Components
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  
  # Utilities
  intl: ^0.19.0
  logger: ^2.0.2+1
  url_launcher: ^6.2.4
  path_provider: ^2.1.2
  
  # AI/ML
  google_generative_ai: ^0.2.0
  
  # PDF & Reports
  pdf: ^3.10.7
  printing: ^5.11.1
  
  # Analytics
  firebase_analytics: ^10.8.0
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  build_runner: ^2.4.8
  hive_generator: ^2.0.1
  bloc_test: ^9.1.5
  mockito: ^5.4.4
```

### 3. Project Structure Setup
```bash
# Create directory structure
mkdir -p lib/{app,core,data,domain,presentation,services}
mkdir -p lib/app/theme
mkdir -p lib/core/{constants,errors,utils}
mkdir -p lib/data/{datasources/{local,remote},models,repositories}
mkdir -p lib/domain/{entities,repositories,usecases}
mkdir -p lib/presentation/{blocs,screens,widgets}
mkdir -p lib/services
mkdir -p test/{unit,widget,integration}
```

### 4. Theme Setup
Create `lib/app/theme/theme.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts.dart';

class AppTheme {
  static const kBackgroundColor = Color(0xFFFDFDEE);
  static const kPrimaryGreen = Color(0xFF0FB400);
  static const kAccentBrown = Color(0xFF8B4513);
  static const kTextGreen = Color(0xFF2A2A09);
  
  // Opacity Colors
  static const kLightGreenContainer = Color(0x400FB400);
  static const kLightBrownContainer = Color(0x408B4513);
  
  // Spacing
  static const double kSpacing = 8.0;
  static const double kSpacing2x = 16.0;
  static const double kSpacing3x = 24.0;
  static const double kSpacing4x = 32.0;
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: kPrimaryGreen,
        background: kBackgroundColor,
      ),
      scaffoldBackgroundColor: kBackgroundColor,
      textTheme: GoogleFonts.poppinsTextTheme(),
      // Add more theme configurations
    );
  }
}
```

### 5. Base App Setup
Create `lib/app/app.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme/theme.dart';

class SereniApp extends StatelessWidget {
  const SereniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sereni',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(), // To be created
    );
  }
}
```

### 6. Firebase Setup
```bash
# Install Firebase CLI if not installed
curl -sL https://firebase.tools | bash

# Login to Firebase
firebase login

# Initialize Firebase in project
flutterfire configure \
  --project=sereni-mental-health \
  --out=lib/firebase_options.dart \
  --platforms=android,ios
```

Update `android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

### 7. Git Repository Setup
```bash
# Create development branch
git checkout -b develop

# Add remote repository
git remote add origin https://github.com/your-username/sereni-mental-health.git

# Push to remote
git push -u origin develop
```

### 8. Create Base Files

#### Constants (`lib/core/constants/app_constants.dart`):
```dart
class AppConstants {
  static const String appName = 'Sereni';
  static const String appVersion = '1.0.0';
  
  // API Endpoints
  static const String baseUrl = 'your-api-endpoint';
  
  // Storage Keys
  static const String userDataKey = 'user_data';
  static const String themeKey = 'app_theme';
  
  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
}
```

#### Base Repository (`lib/domain/repositories/base_repository.dart`):
```dart
abstract class BaseRepository {
  Future<void> initialize();
  Future<void> dispose();
}
```

#### Error Handling (`lib/core/errors/failures.dart`):
```dart
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}
```

## Next Steps After Setup

1. **Verify Setup**:
```bash
# Run Flutter doctor
flutter doctor -v

# Check dependencies
flutter pub get

# Run initial build
flutter run
```

2. **Initial Testing**:
```bash
# Create and run tests
flutter test
```

3. **Documentation**:
- Create README.md
- Set up documentation structure
- Define coding guidelines

## Common Issues & Solutions

1. **Dependency Conflicts**
```bash
# Clear pub cache
flutter pub cache clean

# Get dependencies again
flutter pub get
```

2. **Android Build Issues**
```bash
# Clean build
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
```

3. **iOS Build Issues**
```bash
cd ios
pod deintegrate
pod setup
pod install
cd ..
```

## Development Guidelines

1. **Commit Message Format**:
```
type(scope): subject

body

footer
```
Types:
- feat: New feature
- fix: Bug fix
- docs: Documentation
- style: Formatting
- refactor: Code restructure
- test: Adding tests
- chore: Maintenance

2. **Branch Strategy**:
- main: Production-ready code
- develop: Development branch
- feature/*: New features
- bugfix/*: Bug fixes
- release/*: Release preparations

3. **Code Style**:
- Follow Flutter's style guide
- Use meaningful variable names
- Comment complex logic
- Write unit tests for business logic
