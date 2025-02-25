// Path: lib/modules/user_profile/data/local/secure_storage_service.dart

// Author: Dycoh Gacheri (https://github.com/Dycoh)
// Description: Service for securely storing sensitive user data on the device.
// Provides encryption and protection against unauthorized access.

// Last Modified: Tuesday, 25 February 2025 16:35

// Core/Framework imports
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service handling secure storage operations
class SecureStorageService {
  // Asset paths
  static const String _androidEncryption = 'true';
  
  // Configuration parameters
  static const KeychainAccessibility _iosAccessibility = KeychainAccessibility.first_unlock;
  
  final FlutterSecureStorage _secureStorage;
  
  /// Creates a secure storage service with optional configuration
  SecureStorageService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? 
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
              iOptions: IOSOptions(
                accessibility: _iosAccessibility,
              ),
            );
  
  /// Read a value from secure storage
  Future<String?> read(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      // Log error for debugging while maintaining privacy
      print('Error reading from secure storage: $e');
      return null;
    }
  }
  
  /// Write a value to secure storage
  Future<void> write(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (e) {
      print('Error writing to secure storage: $e');
      throw Exception('Failed to write to secure storage: $e');
    }
  }
  
  /// Delete a value from secure storage
  Future<void> delete(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e) {
      print('Error deleting from secure storage: $e');
      throw Exception('Failed to delete from secure storage: $e');
    }
  }
  
  /// Delete all values from secure storage
  ///
  /// This is a destructive operation and should be used with caution,
  /// typically only during account deletion or app reset
  Future<void> deleteAll() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      print('Error deleting all data from secure storage: $e');
      throw Exception('Failed to delete all data from secure storage: $e');
    }
  }
}
