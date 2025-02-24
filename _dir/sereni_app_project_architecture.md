# Sereni Mental Health App - Project Structure

## High-Level Requirements

### Authentication & User Management
- Firebase Authentication integration
- User profile management (including emergency contact)
- Profile image management
- Onboarding flow (name, gender, age)
- Secure data storage

### Core Features
1. Mood Tracking
   - Emoji-based mood selection
   - Historical mood data storage
   - Mood analytics

2. Journaling System
   - Rich text editor
   - Timestamp management
   - Journal streak tracking
   - Local & cloud storage sync

3. AI Integration
   - Gemini API integration
   - Chat interface
   - Voice input support
   - Sentiment analysis
   - Mental health insights generation

4. Analytics & Reporting
   - Psychological score calculation
   - Mood pattern analysis
   - Journal entry analysis
   - PDF report generation
   - Data visualization
   - Share functionality

### Technical Requirements
- Flutter BLoC state management
- Eight-point spacing system
- Firebase backend integration
- Offline capability
- Theme consistency
- Animation system
- Navigation management

## Project Folder Structure

```
lib/
├── app/
│   ├── app.dart
│   ├── routes.dart
│   └── theme/
│       ├── theme.dart
│       ├── colors.dart
│       ├── spacing.dart
│       ├── typography.dart
│       └── animations.dart
│
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   ├── app_constants.dart
│   │   └── assets_constants.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   └── utils/
│       ├── analytics_helper.dart
│       ├── date_formatter.dart
│       └── validators.dart
│
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   │   ├── hive_storage.dart
│   │   │   └── secure_storage.dart
│   │   └── remote/
│   │       ├── firebase_auth.dart
│   │       ├── firebase_storage.dart
│   │       └── gemini_api.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── journal_model.dart
│   │   ├── mood_model.dart
│   │   ├── profile_model.dart
│   │   └── chat_model.dart
│   └── repositories/
│       ├── auth_repository.dart
│       ├── journal_repository.dart
│       ├── chat_repository.dart
│       ├── profile_repository.dart
│       └── user_repository.dart
│
├── domain/
│   ├── entities/
│   │   ├── user.dart
│   │   ├── journal.dart
│   │   ├── mood.dart
│   │   ├── profile.dart
│   │   └── chat.dart
│   ├── repositories/
│   │   ├── i_auth_repository.dart
│   │   ├── i_journal_repository.dart
│   │   ├── i_profile_repository.dart
│   │   └── i_chat_repository.dart
│   └── usecases/
│       ├── auth/
│       ├── journal/
│       ├── profile/
│       └── chat/
│
├── presentation/
│   ├── blocs/
│   │   ├── auth/
│   │   ├── journal/
│   │   ├── chat/
│   │   └── profile/
│   ├── screens/
│   │   ├── splash/
│   │   ├── onboarding/
│   │   ├── auth/
│   │   ├── home/
│   │   ├── journal/
│   │   ├── chat/
│   │   ├── insights/
│   │   ├── reports/
│   │   └── profile/
│   │       ├── profile_screen.dart
│   │       ├── edit_profile_image.dart
│   │       ├── edit_emergency_contact.dart
│   │       └── profile_settings.dart
│   └── widgets/
│       ├── common/
│       │   ├── custom_app_bar.dart
│       │   ├── nav_drawer.dart
│       │   └── bottom_nav.dart
│       ├── journal/
│       ├── chat/
│       ├── profile/
│       │   ├── profile_header.dart
│       │   ├── settings_tile.dart
│       │   └── language_selector.dart
│       └── insights/
│
└── services/
    ├── analytics_service.dart
    ├── navigation_service.dart
    ├── storage_service.dart
    └── ai_service.dart
```

## Theme Configuration (theme.dart)

```dart
// Color constants
const kBackgroundColor = Color(0xFFFDFDEE);
const kPrimaryGreen = Color(0xFF0FB400);
const kAccentBrown = Color(0xFF8B4513);
const kTextGreen = Color(0xFF2A2A09);
const kLightGreenContainer = Color(0x400FB400); // 25% opacity
const kLightBrownContainer = Color(0x408B4513); // 25% opacity

// Spacing constants (8-point system)
const double kSpacing = 8.0;
const double kSpacing2x = 16.0;
const double kSpacing3x = 24.0;
const double kSpacing4x = 32.0;
```

## Key Architectural Decisions

1. **Clean Architecture**
   - Separation of concerns
   - Dependencies flow inward
   - Domain layer is independent
   - Repository pattern implementation

2. **State Management**
   - BLoC pattern for all features
   - Separate BLoCs for distinct features
   - Global app state management

3. **Data Flow**
   - Repository pattern
   - Local data caching
   - Real-time sync with Firebase
   - Offline-first approach

4. **Security**
   - Secure storage for sensitive data
   - Firebase Authentication
   - Data encryption
   - Input validation
   - Emergency contact storage

5. **Performance**
   - Lazy loading
   - Image optimization
   - Efficient state management
   - Memory management

## Profile Screen Features
1. User Information
   - Profile image (editable)
   - Name
   - Gender
   - Age

2. General Settings
   - Notifications toggle
   - Dark mode toggle
   - Language selection

3. Privacy & Security
   - Emergency contact management
   - Password management
   - Logout functionality

## Next Steps
1. Initialize project with provided structure
2. Set up Firebase configuration
3. Implement theme system
4. Create base widgets
5. Begin feature implementation
   - Focus on comprehensive profile management
   - Implement image upload functionality
   - Add emergency contact management within profile