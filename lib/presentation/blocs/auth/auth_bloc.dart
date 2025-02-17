// presentation/blocs/auth/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/auth_repository.dart';

// Events
abstract class AuthEvent {}
class InitializeAuth extends AuthEvent {}
class SignIn extends AuthEvent {
  final String email;
  final String password;
  SignIn({required this.email, required this.password});
}
class SignOut extends AuthEvent {}

// States
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {}
class AuthUnauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<InitializeAuth>(_onInitializeAuth);
    on<SignIn>(_onSignIn);
    on<SignOut>(_onSignOut);
  }

  Future<void> _onInitializeAuth(InitializeAuth event, Emitter<AuthState> emit) async {
    // Implementation
  }

  Future<void> _onSignIn(SignIn event, Emitter<AuthState> emit) async {
    // Implementation
  }

  Future<void> _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    // Implementation
  }
}
