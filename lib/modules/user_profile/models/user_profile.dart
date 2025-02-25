// Path: lib/modules/user_profile/models/user_profile.dart

// Author: Dycoh Gacheri (https://github.com/Dycoh)
// Description: Comprehensive user profile model that includes personal information
// and serves as the central source of truth for user identity data.

// Last Modified: Tuesday, 25 February 2025 16:35

// Core/Framework imports
import 'package:equatable/equatable.dart';

// Project imports - Models
import '../../onboarding/models/onboarding_data.dart';

/// Represents a user's complete profile information
class UserProfile extends Equatable {
  // Personal identifiers
  final String? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  
  // Demographics
  final String? gender;
  final double age;
  final DateTime? dateOfBirth;
  
  // Profile data
  final String? avatarUrl;
  final String? bio;
  
  // Status information
  final DateTime? lastActive;
  final DateTime createdAt;
  final bool isOnboardingComplete;

  /// Creates an immutable [UserProfile] instance
  const UserProfile({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.gender,
    this.age = 25.0,
    this.dateOfBirth,
    this.avatarUrl,
    this.bio,
    this.lastActive,
    DateTime? createdAt,
    this.isOnboardingComplete = false,
  }) : createdAt = createdAt ?? DateTime.now();
  
  /// Creates a copy of this [UserProfile] with the given fields replaced with new values
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? gender,
    double? age,
    DateTime? dateOfBirth,
    String? avatarUrl,
    String? bio,
    DateTime? lastActive,
    DateTime? createdAt,
    bool? isOnboardingComplete,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      lastActive: lastActive ?? this.lastActive,
      createdAt: createdAt ?? this.createdAt,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
    );
  }
  
  /// Returns whether essential profile information is complete
  bool get isProfileComplete =>
      name != null &&
      name!.isNotEmpty &&
      gender != null;
  
  /// Factory method to create a UserProfile from OnboardingData
  factory UserProfile.fromOnboardingData(OnboardingData data) {
    return UserProfile(
      name: data.name,
      gender: data.gender,
      age: data.age,
      isOnboardingComplete: data.isComplete,
    );
  }
  
  /// Map representation of the profile for serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'age': age,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'avatarUrl': avatarUrl,
      'bio': bio,
      'lastActive': lastActive?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'isOnboardingComplete': isOnboardingComplete,
    };
  }
  
  /// Factory constructor to create a UserProfile from a map
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      gender: map['gender'],
      age: map['age'] ?? 25.0,
      dateOfBirth: map['dateOfBirth'] != null 
          ? DateTime.parse(map['dateOfBirth']) 
          : null,
      avatarUrl: map['avatarUrl'],
      bio: map['bio'],
      lastActive: map['lastActive'] != null 
          ? DateTime.parse(map['lastActive']) 
          : null,
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
      isOnboardingComplete: map['isOnboardingComplete'] ?? false,
    );
  }
  
  @override
  List<Object?> get props => [
    id, name, email, phoneNumber, gender, age, 
    dateOfBirth, avatarUrl, bio, lastActive, 
    createdAt, isOnboardingComplete
  ];
  
  @override
  String toString() => 'UserProfile(id: $id, name: $name, email: $email, '
      'gender: $gender, age: $age, isOnboardingComplete: $isOnboardingComplete)';
}