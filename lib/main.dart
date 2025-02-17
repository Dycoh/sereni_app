import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';  // Import for web plugins

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

/// Custom BLoC observer for logging state changes
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
    // Use URL path strategy for web routing 
    // (removes # from URLs in browser address bar)
    setUrlStrategy(PathUrlStrategy());
  }
}

/// Main entry point of the application
void main() {
  // Set this flag to make zone errors fatal during development
  // BindingBase.debugZoneErrorsAreFatal = true;
  
  // Run everything in the same zone
  runZonedGuarded(() async {
    // Ensure Flutter bindings are initialized in the same zone as runApp
    WidgetsFlutterBinding.ensureInitialized();
    
    // Configure web-specific settings (must be after binding initialization)
    configureWebSettings();
    
    // Set up error handling
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      debugPrint(details.toString());
    };
    
    // Initialize services with error handling
    try {
      // Initialize Firebase with platform-specific options
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      
      // Web-safe Hive initialization
      await Hive.initFlutter();
      
      // Open Hive boxes
      await Hive.openBox('settings');
      await Hive.openBox('user_data');
      await Hive.openBox('journals');
    } catch (e) {
      debugPrint('Failed to initialize some services: $e');
      // Continue anyway - graceful degradation
    }
    
    // Set up BLoC observer
    Bloc.observer = AppBlocObserver();
    
    // Run the app in the same zone where binding was initialized
    runApp(
      MultiRepositoryProvider(
        providers: [
          // Repository Providers
          RepositoryProvider<AuthRepository>(
            create: (context) => AuthRepository(),
          ),
          RepositoryProvider<UserRepository>(
            create: (context) => UserRepository(),
          ),
          RepositoryProvider<JournalRepository>(
            create: (context) => JournalRepository(),
          ),
          RepositoryProvider<ChatRepository>(
            create: (context) => ChatRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            // BLoC Providers
            BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(
                authRepository: context.read<AuthRepository>(),
              ),
            ),
            BlocProvider<ProfileBloc>(
              create: (context) => ProfileBloc(
                userRepository: context.read<UserRepository>(),
              ),
            ),
            BlocProvider<JournalBloc>(
              create: (context) => JournalBloc(
                journalRepository: context.read<JournalRepository>(),
              ),
            ),
            BlocProvider<ChatBloc>(
              create: (context) => ChatBloc(
                chatRepository: context.read<ChatRepository>(),
              ),
            ),
          ],
          child: const SereniApp(),
        ),
      ),
    );
  }, (error, stack) {
    debugPrint('Uncaught error: $error');
    debugPrint('Stack trace: $stack');
    // Here you could add error reporting service like Firebase Crashlytics
  });
}