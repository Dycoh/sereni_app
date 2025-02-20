import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:easy_localization/easy_localization.dart';

// Firebase configuration import
import 'configuration/firebase_options.dart';

// App entry point
import 'app/app.dart';

// Repository imports
import 'data/repositories/auth_repository.dart';
import 'data/repositories/journal_repository.dart';
import 'data/repositories/chat_repository.dart';
import 'data/repositories/user_repository.dart';

// BLoC imports
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/journal/journal_bloc.dart';
import 'presentation/blocs/chat/chat_bloc.dart';
import 'presentation/blocs/profile/profile_bloc.dart';

/// Custom BLoC observer for logging state changes and errors during development
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('${bloc.runtimeType} $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}

/// Configure web-specific settings and plugins
void configureWebSettings() {
  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy());
  }
}

/// Initialize all required services and dependencies
Future<void> initializeServices() async {
  try {
    // Initialize Firebase with platform-specific options
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Initialize Hive for local storage
    await Hive.initFlutter();
    
    // Open all required Hive boxes concurrently for better performance
    await Future.wait([
      Hive.openBox('settings'),
      Hive.openBox('user_data'),
      Hive.openBox('journals'),
    ]);
  } catch (e) {
    debugPrint('Service initialization error: $e');
    rethrow;
  }
}

/// Main entry point of the application
void main() {
  // Run everything in a guarded zone to catch all errors
  runZonedGuarded(() async {
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize EasyLocalization
    await EasyLocalization.ensureInitialized();
    
    // Configure web-specific settings
    configureWebSettings();
    
    // Set up global error handling for Flutter errors
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      debugPrint(details.toString());
    };
    
    // Initialize core services with error handling
    try {
      await initializeServices();
    } catch (e) {
      debugPrint('Failed to initialize some services: $e');
      // Continue anyway - graceful degradation
    }
    
    // Set up BLoC observer for state management debugging
    Bloc.observer = AppBlocObserver();
    
    // Initialize repositories
    final authRepository = AuthRepository();
    final userRepository = UserRepository();
    final journalRepository = JournalRepository();
    final chatRepository = ChatRepository();
    
    // Run the app with all providers and EasyLocalization
    runApp(
      EasyLocalization(
        supportedLocales: const [
          Locale('en'), // English
          // Add other locales as needed, e.g.:
          // Locale('es'), // Spanish
          // Locale('fr'), // French
        ],
        path: 'lib/core/utils/translations', // Make sure this matches your asset path
        fallbackLocale: const Locale('en'),
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<AuthRepository>.value(
              value: authRepository,
            ),
            RepositoryProvider<UserRepository>.value(
              value: userRepository,
            ),
            RepositoryProvider<JournalRepository>.value(
              value: journalRepository,
            ),
            RepositoryProvider<ChatRepository>.value(
              value: chatRepository,
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(
                create: (context) => AuthBloc(
                  authRepository: authRepository,
                )..add(InitializeAuth()),
              ),
              BlocProvider<ProfileBloc>(
                create: (context) => ProfileBloc(
                  userRepository: userRepository,
                )..add(LoadProfile()),
              ),
              BlocProvider<JournalBloc>(
                create: (context) => JournalBloc(
                  journalRepository: journalRepository,
                )..add(LoadJournals()),
              ),
              BlocProvider<ChatBloc>(
                create: (context) => ChatBloc(
                  chatRepository: chatRepository,
                )..add(InitializeChat()),
              ),
            ],
            child: const SereniApp(),
          ),
        ),
      ),
    );
  }, (error, stack) {
    // Global error handler for uncaught errors
    debugPrint('Uncaught error: $error');
    debugPrint('Stack trace: $stack');
  });
}