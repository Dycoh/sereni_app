// Path: lib/modules/onboarding/models/onboarding_data.dart

// Author: Dycoh Gacheri (https://github.com/Dycoh)
// Description: Data model for user information collected during onboarding.
// Implements value semantics with immutability and equality comparison.

// Last Modified: Tuesday, 25 February 2025 16:35

// Core/Framework imports
import 'package:equatable/equatable.dart';

/// Represents user data collected during the onboarding process
class OnboardingData extends Equatable {
  // Core user information
  final String? name;
  final String? gender;
  final double age;
  
  /// Creates an immutable [OnboardingData] instance
  /// 
  /// Default age is set to 25 as a reasonable starting point
  const OnboardingData({
    this.name,
    this.gender,
    this.age = 25.0,
  });
  
  /// Creates a copy of this [OnboardingData] with the given fields replaced with new values
  OnboardingData copyWith({
    String? name,
    String? gender,
    double? age,
  }) {
    return OnboardingData(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
    );
  }
  
  /// Returns whether this instance is complete with all required fields
  bool get isComplete => 
      name != null && 
      name!.isNotEmpty && 
      gender != null;
  
  @override
  List<Object?> get props => [name, gender, age];
  
  @override
  String toString() => 'OnboardingData(name: $name, gender: $gender, age: $age)';
}

