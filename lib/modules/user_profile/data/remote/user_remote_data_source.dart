// Path: lib/modules/user_profile/data/remote/user_remote_data_source.dart

// Author: Dycoh Gacheri (https://github.com/Dycoh)
// Description: Remote data source for user profile data. Manages API communication
// for fetching and updating user information on the backend.

// Last Modified: Tuesday, 25 February 2025 16:35

// Core/Framework imports
import 'dart:convert';
import 'package:http/http.dart' as http;

// Project imports - Models
import '../../models/user_profile.dart';

/// Remote data source for user profile operations
class UserRemoteDataSource {
  // API endpoints
  static const String _baseUrl = 'https://api.sereni.app';
  static const String _profileEndpoint = '/users/profile';
  
  // HTTP client
  final http.Client _client;
  
  // Authentication token getter
  final Future<String?> Function() _getAuthToken;
  
  /// Creates a remote data source with the required dependencies
  UserRemoteDataSource({
    required http.Client client,
    required Future<String?> Function() getAuthToken,
  }) : 
    _client = client,
    _getAuthToken = getAuthToken;

  /// Get user profile from the server
  Future<UserProfile?> getProfile(String userId) async {
    try {
      // Get auth token
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('Authentication token not available');
      }
      
      // Prepare request
      final uri = Uri.parse('$_baseUrl$_profileEndpoint/$userId');
      final response = await _client.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      // Handle response
      if (response.statusCode == 200) {
        final profileMap = jsonDecode(response.body) as Map<String, dynamic>;
        return UserProfile.fromMap(profileMap);
      } else {
        throw Exception('Failed to fetch profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting profile from server: $e');
      return null;
    }
  }
  
  /// Update user profile on the server
  Future<bool> updateProfile(UserProfile profile) async {
    try {
      // Get auth token
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('Authentication token not available');
      }
      
      // Ensure profile ID exists
      if (profile.id == null) {
        throw Exception('Profile ID is required for updating');
      }
      
      // Prepare request
      final uri = Uri.parse('$_baseUrl$_profileEndpoint/${profile.id}');
      final response = await _client.put(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(profile.toMap()),
      );
      
      // Handle response
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating profile on server: $e');
      return false;
    }
  }
  
  /// Create a new user profile on the server
  Future<UserProfile?> createProfile(UserProfile profile) async {
    try {
      // Get auth token
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('Authentication token not available');
      }
      
      // Prepare request
      final uri = Uri.parse('$_baseUrl$_profileEndpoint');
      final response = await _client.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(profile.toMap()),
      );
      
      // Handle response
      if (response.statusCode == 201) {
        final profileMap = jsonDecode(response.body) as Map<String, dynamic>;
        return UserProfile.fromMap(profileMap);
      } else {
        throw Exception('Failed to create profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating profile on server: $e');
      return null;
    }
  }
  
  /// Delete user profile from the server
  Future<bool> deleteProfile(String userId) async {
    try {
      // Get auth token
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('Authentication token not available');
      }
      
      // Prepare request
      final uri = Uri.parse('$_baseUrl$_profileEndpoint/$userId');
      final response = await _client.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      // Handle response
      return response.statusCode == 204;
    } catch (e) {
      print('Error deleting profile from server: $e');
      return false;
    }
  }
}
