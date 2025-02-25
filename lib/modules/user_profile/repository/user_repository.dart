// Path: lib/modules/user_profile/repository/user_repository.dart

// Author: Dycoh Gacheri (https://github.com/Dycoh)
// Description: Repository for managing user profile data. Coordinates between local
// and remote data sources while providing a clean API for the application.

// Last Modified: Tuesday, 25 February 2025 16:35

// Core/Framework imports
import 'dart:async';

// Project imports - Models
import '../models/user_profile.dart';
import '../data/local/user_local_data_source.dart';
import '../data/remote/user_remote_data_source.dart';

/// Repository handling all user profile operations
class UserRepository {
  // Data sources
  final UserLocalDataSource _localDataSource;
  final UserRemoteDataSource? _remoteDataSource;
  
  // Stream controller for broadcasting profile changes
  final _profileController = StreamController<UserProfile>.broadcast();
  
  // Cached profile data
  UserProfile? _cachedProfile;
  
  /// Creates a repository with the required data sources
  ///
  /// The [remoteDataSource] is optional, allowing the repository to work in offline mode
  UserRepository({
    required UserLocalDataSource localDataSource,
    UserRemoteDataSource? remoteDataSource,
  }) : 
    _localDataSource = localDataSource, 
    _remoteDataSource = remoteDataSource;

  /// Stream of user profile updates
  Stream<UserProfile> get profileStream => _profileController.stream;
  
  /// Get the current user profile
  Future<UserProfile?> getCurrentProfile() async {
    // Return cached profile if available
    if (_cachedProfile != null) {
      return _cachedProfile;
    }
    
    try {
      // Try to get from local storage first
      final localProfile = await _localDataSource.getProfile();
      
      // If we have a remote data source and are online, sync with server
      if (_remoteDataSource != null && localProfile != null) {
        try {
          final remoteProfile = await _remoteDataSource!.getProfile(localProfile.id!);
          if (remoteProfile != null) {
            // Update local storage with latest from server
            await _localDataSource.saveProfile(remoteProfile);
            
            // Update cache
            _cachedProfile = remoteProfile;
            
            return remoteProfile;
          }
        } catch (e) {
          // If remote fetch fails, still return local data
          print('Failed to sync profile with server: $e');
        }
      }
      
      // Update cache with local profile
      _cachedProfile = localProfile;
      
      return localProfile;
    } catch (e) {
      print('Error getting current profile: $e');
      return null;
    }
  }
  
  /// Save or update user profile
  Future<bool> saveProfile(UserProfile profile) async {
    try {
      // Save locally
      await _localDataSource.saveProfile(profile);
      
      // Update cache
      _cachedProfile = profile;
      
      // Sync with server if available
      if (_remoteDataSource != null) {
        try {
          if (profile.id != null) {
            // Update existing profile
            await _remoteDataSource!.updateProfile(profile);
          } else {
            // Create new profile
            final remoteProfile = await _remoteDataSource!.createProfile(profile);
            if (remoteProfile != null) {
              // Update with server-generated ID and timestamps
              await _localDataSource.saveProfile(remoteProfile);
              _cachedProfile = remoteProfile;
              _profileController.add(remoteProfile);
              return true;
            }
          }
        } catch (e) {
          print('Failed to sync profile with server: $e');
          // Continue even if server sync fails
        }
      }
      
      // Broadcast the change
      _profileController.add(profile);
      
      return true;
    } catch (e) {
      print('Error saving profile: $e');
      return false;
    }
  }
  
  /// Update specific fields in the user profile
  Future<bool> updateProfileFields({
    String? name,
    String? email,
    String? phoneNumber,
    String? gender,
    double? age,
    DateTime? dateOfBirth,
    String? bio,
    String? avatarUrl,
    bool? isOnboardingComplete,
  }) async {
    try {
      final currentProfile = await getCurrentProfile();
      if (currentProfile == null) {
        return false;
      }
      
      final updatedProfile = currentProfile.copyWith(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        gender: gender,
        age: age,
        dateOfBirth: dateOfBirth,
        bio: bio,
        avatarUrl: avatarUrl,
        isOnboardingComplete: isOnboardingComplete,
        lastActive: DateTime.now(),
      );
      
      return saveProfile(updatedProfile);
    } catch (e) {
      print('Error updating profile fields: $e');
      return false;
    }
  }
  
  /// Create a new user profile from onboarding data
  Future<bool> createProfileFromOnboarding(UserProfile profile) async {
    return saveProfile(profile.copyWith(
      isOnboardingComplete: true,
      createdAt: DateTime.now(),
      lastActive: DateTime.now(),
    ));
  }
  
  /// Delete the user profile
  Future<bool> deleteProfile() async {
    try {
      // Get current profile for the ID
      final currentProfile = await getCurrentProfile();
      
      // Delete locally
      await _localDataSource.deleteProfile();
      
      // Clear cache
      _cachedProfile = null;
      
      // Delete from server if available
      if (_remoteDataSource != null && currentProfile?.id != null) {
        try {
          await _remoteDataSource!.deleteProfile(currentProfile!.id!);
        } catch (e) {
          print('Failed to delete profile from server: $e');
          // Continue even if server deletion fails
        }
      }
      
      return true;
    } catch (e) {
      print('Error deleting profile: $e');
      return false;
    }
  }
  
  /// Check if a profile exists
  Future<bool> hasProfile() async {
    if (_cachedProfile != null) {
      return true;
    }
    return _localDataSource.hasProfile();
  }
  
  /// Clear cached profile data
  void clearCache() {
    _cachedProfile = null;
  }
  
  /// Dispose of resources
  void dispose() {
    _profileController.close();
  }
}