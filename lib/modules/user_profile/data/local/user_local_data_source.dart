// Path: lib/modules/user_profile/data/local/user_local_data_source.dart

// Author: Dycoh Gacheri (https://github.com/Dycoh)
// Description: Local data source for user profile data using secure storage.
// Responsible for persistence of user information on the device.

// Last Modified: Tuesday, 25 February 2025 16:35

// Core/Framework imports
import 'dart:convert';

// Project imports - Models
import '../../models/user_profile.dart';
import 'secure_storage_service.dart';

/// Keys for secure storage
class StorageKeys {
  // User data keys
  static const String userProfile = 'user_profile';
  static const String userPreferences = 'user_preferences';
  
  // Session keys
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
}

/// Local data source for user profile operations
class UserLocalDataSource {
  // Service instances
  final SecureStorageService _secureStorage;
  
  UserLocalDataSource({required SecureStorageService secureStorage})
      : _secureStorage = secureStorage;
  
  /// Retrieve user profile from secure storage
  Future<UserProfile?> getProfile() async {
    try {
      final profileJson = await _secureStorage.read(StorageKeys.userProfile);
      if (profileJson == null) {
        // No profile found in storage
        return null;
      }
      
      // Parse JSON string to Map and then to UserProfile
      final profileMap = jsonDecode(profileJson) as Map<String, dynamic>;
      return UserProfile.fromMap(profileMap);
    } catch (e) {
      // Log error for debugging
      print('Error reading profile from storage: $e');
      return null;
    }
  }
  
  /// Save user profile to secure storage
  Future<void> saveProfile(UserProfile profile) async {
    try {
      // Convert profile to Map, then to JSON string
      final profileMap = profile.toMap();
      final profileJson = jsonEncode(profileMap);
      
      // Store in secure storage
      await _secureStorage.write(StorageKeys.userProfile, profileJson);
    } catch (e) {
      print('Error saving profile to storage: $e');
      throw Exception('Failed to save profile: $e');
    }
  }
  
  /// Delete user profile from secure storage
  Future<void> deleteProfile() async {
    try {
      await _secureStorage.delete(StorageKeys.userProfile);
    } catch (e) {
      print('Error deleting profile from storage: $e');
      throw Exception('Failed to delete profile: $e');
    }
  }
  
  /// Check if a user profile exists in storage
  Future<bool> hasProfile() async {
    final profile = await getProfile();
    return profile != null;
  }
}
