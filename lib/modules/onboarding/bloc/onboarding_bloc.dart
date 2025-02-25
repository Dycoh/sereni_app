// Path: lib/modules/onboarding/bloc/onboarding_bloc.dart

// Author: Dycoh Gacheri (https://github.com/Dycoh)
// Description: BLoC implementation for the onboarding flow. Handles state management
// for user information collection including name, gender, and age. Separates business
// logic from presentation layer for better testability and maintainability.

// Last Modified: Tuesday, 25 February 2025 16:35

// Core/Framework imports
// ignore: unused_import
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Project imports - Models
import '../models/onboarding_data.dart';

// Events
abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();
  
  @override
  List<Object?> get props => [];
}

class NameUpdated extends OnboardingEvent {
  final String name;
  
  const NameUpdated(this.name);
  
  @override
  List<Object> get props => [name];
}

class GenderSelected extends OnboardingEvent {
  final String gender;
  
  const GenderSelected(this.gender);
  
  @override
  List<Object> get props => [gender];
}

class AgeUpdated extends OnboardingEvent {
  final double age;
  
  const AgeUpdated(this.age);
  
  @override
  List<Object> get props => [age];
}

class PageChanged extends OnboardingEvent {
  final int pageIndex;
  
  const PageChanged(this.pageIndex);
  
  @override
  List<Object> get props => [pageIndex];
}

class OnboardingSubmitted extends OnboardingEvent {}

// States
abstract class OnboardingState extends Equatable {
  final OnboardingData userData;
  final int currentPage;
  
  const OnboardingState({
    required this.userData,
    required this.currentPage,
  });
  
  @override
  List<Object?> get props => [userData, currentPage];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial()
      : super(userData: const OnboardingData(), currentPage: 0);
}

class OnboardingDataUpdated extends OnboardingState {
  const OnboardingDataUpdated({
    required super.userData,
    required super.currentPage,
  });
}

class OnboardingValidationError extends OnboardingState {
  final String errorMessage;
  final String? fieldName;
  
  const OnboardingValidationError({
    required super.userData,
    required super.currentPage,
    required this.errorMessage,
    this.fieldName,
  });
  
  @override
  List<Object?> get props => [...super.props, errorMessage, fieldName];
}

class OnboardingSubmitSuccess extends OnboardingState {
  const OnboardingSubmitSuccess({
    required super.userData,
  }) : super(currentPage: 2);
}

// BLoC
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingInitial()) {
    on<NameUpdated>(_onNameUpdated);
    on<GenderSelected>(_onGenderSelected);
    on<AgeUpdated>(_onAgeUpdated);
    on<PageChanged>(_onPageChanged);
    on<OnboardingSubmitted>(_onSubmitted);
  }

  // Validates if the user can proceed to the next page
  bool canProceedToNextPage(int currentPage, OnboardingData userData) {
    switch (currentPage) {
      case 0:
        return userData.name != null && userData.name!.isNotEmpty;
      case 1:
        return userData.gender != null;
      case 2:
        return true; // Age always has a default value
      default:
        return false;
    }
  }

  void _onNameUpdated(NameUpdated event, Emitter<OnboardingState> emit) {
    final updatedData = state.userData.copyWith(name: event.name);
    
    emit(OnboardingDataUpdated(
      userData: updatedData,
      currentPage: state.currentPage,
    ));
  }

  void _onGenderSelected(GenderSelected event, Emitter<OnboardingState> emit) {
    final updatedData = state.userData.copyWith(gender: event.gender);
    
    emit(OnboardingDataUpdated(
      userData: updatedData,
      currentPage: state.currentPage,
    ));
  }

  void _onAgeUpdated(AgeUpdated event, Emitter<OnboardingState> emit) {
    final updatedData = state.userData.copyWith(age: event.age);
    
    emit(OnboardingDataUpdated(
      userData: updatedData,
      currentPage: state.currentPage,
    ));
  }

  void _onPageChanged(PageChanged event, Emitter<OnboardingState> emit) {
    // Handle backward navigation logic
    final currentPage = event.pageIndex;
    final previousPage = state.currentPage;
    
    // When navigating backwards, we don't need validation
    if (currentPage < previousPage) {
      emit(OnboardingDataUpdated(
        userData: state.userData,
        currentPage: currentPage,
      ));
      return null; // Add null here instead of empty return
    }
    
    // Validate before proceeding to next page
    if (!canProceedToNextPage(previousPage, state.userData)) {
      String errorMessage;
      String? fieldName;
      
      switch (previousPage) {
        case 0:
          errorMessage = 'Please enter your name';
          fieldName = 'name';
          break;
        case 1:
          errorMessage = 'Please select your gender';
          fieldName = 'gender';
          break;
        default:
          errorMessage = 'Invalid input';
          break;
      }
      
      emit(OnboardingValidationError(
        userData: state.userData,
        currentPage: previousPage,
        errorMessage: errorMessage,
        fieldName: fieldName,
      ));
      return null; // Add null here instead of empty return
    }
    
    // If validation passes, update page
    emit(OnboardingDataUpdated(
      userData: state.userData,
      currentPage: currentPage,
    ));
  }

  void _onSubmitted(OnboardingSubmitted event, Emitter<OnboardingState> emit) {
    // Final validation before submission
    if (!canProceedToNextPage(2, state.userData)) {
      emit(OnboardingValidationError(
        userData: state.userData,
        currentPage: 2,
        errorMessage: 'Please complete all required fields',
        fieldName: null,
      ));
      return null; // Add null here instead of empty return
    }
    
    // If everything is valid, emit success state
    emit(OnboardingSubmitSuccess(userData: state.userData));
    
    // Here you would typically save the data to a repository
    // This could be done by injecting a repository and calling it here
  }
}