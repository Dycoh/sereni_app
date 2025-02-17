// presentation/blocs/profile/profile_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/user_repository.dart';

// Events
abstract class ProfileEvent {}
class LoadProfile extends ProfileEvent {}
class UpdateProfile extends ProfileEvent {
  final Map<String, dynamic> data;
  UpdateProfile(this.data);
}

// States
abstract class ProfileState {}
class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> data;
  ProfileLoaded(this.data);
}
class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;

  ProfileBloc({required this.userRepository}) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    // Implementation
  }

  Future<void> _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    // Implementation
  }
}
