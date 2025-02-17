import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

// Firebase configuration import
import 'configuration/firebase_options.dart';

// App entry point
import 'app/app.dart';

// Service imports
import 'services/analytics_service.dart';
import 'services/storage_service.dart';
import 'services/navigation_service.dart';
import 'services/ai_service.dart';

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

/// Initialize all services required by the app
Future<void> initializeServices() async {
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize Hive for local storage
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    
    // Register Hive adapters here if needed
    // Hive.registerAdapter(UserAdapter());
    // Hive.registerAdapter(JournalAdapter());
    
    // Open Hive boxes
    await Hive.openBox('settings');
    await Hive.openBox('user_data');
    await Hive.openBox('journals');
  } catch (e) {
    debugPrint('Error initializing services: $e');
    rethrow;
  }
}

/// Main entry point of the application
Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set up error handling
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };

  // Initialize services
  await initializeServices();

  // Set up BLoC observer
  Bloc.observer = AppBlocObserver();

  // Run the app inside a zone to catch all errors
  runZonedGuarded(
    () => runApp(
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
    ),
    (error, stack) {
      debugPrint('Uncaught error: $error');
      debugPrint('Stack trace: $stack');
      // Here you could add error reporting service like Firebase Crashlytics
    },
  );
}