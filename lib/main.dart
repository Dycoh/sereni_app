import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    // Load environment variables first
    await dotenv.load(fileName: ".env");
    debugPrint('Environment variables loaded successfully');

 // Initialize Easy Localization
    await EasyLocalization.ensureInitialized();
    debugPrint('Easy Localization initialized successfully');


    // Initialize Firebase with platform-specific options
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
    
    // Initialize Hive for local storage
    await Hive.initFlutter();
    debugPrint('Hive initialized successfully');
    
    // Open all required Hive boxes concurrently
    await Future.wait([
      Hive.openBox('settings'),
      Hive.openBox('user_data'),
      Hive.openBox('journals'),
    ]);
    debugPrint('Hive boxes opened successfully');
  } catch (e) {
    debugPrint('Service initialization error: $e');
    rethrow;
  }
}

/// Main entry point of the application
void main() {
  runZonedGuarded(() async {
    debugPrint('Starting application initialization...');
    
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint('Flutter bindings initialized');
    
    // Configure web-specific settings
    configureWebSettings();
    
    // Set up global error handling
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      debugPrint('Flutter error: ${details.toString()}');
    };
    
    // Initialize core services
    try {
      await initializeServices();
    } catch (e) {
      debugPrint('Failed to initialize services: $e');
      // Continue with graceful degradation
    }
    
    // Set up BLoC observer
    Bloc.observer = AppBlocObserver();
    
    // Initialize repositories
    final authRepository = AuthRepository();
    final userRepository = UserRepository();
    final journalRepository = JournalRepository();
    final chatRepository = ChatRepository();
    
    debugPrint('All repositories initialized');
    
    // Run the app with dependency injection
    runApp(
      EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          // Add other locales as needed
        ],
        path: 'lib/core/utils/translations',
        fallbackLocale: const Locale('en', 'US'),
        child:  MultiRepositoryProvider(
         providers: [
          RepositoryProvider<AuthRepository>.value(value: authRepository),
          RepositoryProvider<UserRepository>.value(value: userRepository),
          RepositoryProvider<JournalRepository>.value(value: journalRepository),
          RepositoryProvider<ChatRepository>.value(value: chatRepository),
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
    ));
  }, (error, stack) {
    debugPrint('Uncaught error: $error');
    debugPrint('Stack trace: $stack');
  });
}