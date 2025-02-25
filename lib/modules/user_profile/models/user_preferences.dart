// Path: lib/modules/user_profile/models/user_preferences.dart

// Author: Dycoh Gacheri (https://github.com/Dycoh)
// Description: Model for storing all user configurable preferences including
// app appearance, notification settings, and feature preferences.

// Last Modified: Tuesday, 25 February 2025 16:35

// Core/Framework imports
import 'package:equatable/equatable.dart';

/// Represents all user-configurable preferences in the application
class UserPreferences extends Equatable {
  // Theme preferences
  final String themeMode; // 'light', 'dark', 'system'
  final bool useHighContrast;
  final String accentColor;
  
  // Notification preferences
  final bool enablePushNotifications;
  final bool enableEmailNotifications;
  final bool enableSoundEffects;
  final bool enableVibration;
  
  // Privacy preferences
  final bool shareUsageData;
  final bool allowLocationTracking;
  
  // App behavior preferences
  final String defaultLanguage;
  final bool enableAutoSave;
  final int dataRefreshInterval; // in minutes
  
  // Feature preferences
  final Map<String, bool> featureToggles;

  /// Creates an immutable [UserPreferences] instance with default values
  const UserPreferences({
    this.themeMode = 'system',
    this.useHighContrast = false,
    this.accentColor = 'green',
    this.enablePushNotifications = true,
    this.enableEmailNotifications = true,
    this.enableSoundEffects = true,
    this.enableVibration = true,
    this.shareUsageData = false,
    this.allowLocationTracking = false,
    this.defaultLanguage = 'en',
    this.enableAutoSave = true,
    this.dataRefreshInterval = 15,
    this.featureToggles = const {},
  });

  /// Creates a copy of this [UserPreferences] with the given fields replaced
  UserPreferences copyWith({
    String? themeMode,
    bool? useHighContrast,
    String? accentColor,
    bool? enablePushNotifications,
    bool? enableEmailNotifications,
    bool? enableSoundEffects,
    bool? enableVibration,
    bool? shareUsageData,
    bool? allowLocationTracking,
    String? defaultLanguage,
    bool? enableAutoSave,
    int? dataRefreshInterval,
    Map<String, bool>? featureToggles,
  }) {
    return UserPreferences(
      themeMode: themeMode ?? this.themeMode,
      useHighContrast: useHighContrast ?? this.useHighContrast,
      accentColor: accentColor ?? this.accentColor,
      enablePushNotifications: enablePushNotifications ?? this.enablePushNotifications,
      enableEmailNotifications: enableEmailNotifications ?? this.enableEmailNotifications,
      enableSoundEffects: enableSoundEffects ?? this.enableSoundEffects,
      enableVibration: enableVibration ?? this.enableVibration,
      shareUsageData: shareUsageData ?? this.shareUsageData,
      allowLocationTracking: allowLocationTracking ?? this.allowLocationTracking,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      enableAutoSave: enableAutoSave ?? this.enableAutoSave,
      dataRefreshInterval: dataRefreshInterval ?? this.dataRefreshInterval,
      featureToggles: featureToggles ?? this.featureToggles,
    );
  }
  
  /// Map representation of preferences for serialization
  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode,
      'useHighContrast': useHighContrast,
      'accentColor': accentColor,
      'enablePushNotifications': enablePushNotifications,
      'enableEmailNotifications': enableEmailNotifications,
      'enableSoundEffects': enableSoundEffects,
      'enableVibration': enableVibration,
      'shareUsageData': shareUsageData,
      'allowLocationTracking': allowLocationTracking,
      'defaultLanguage': defaultLanguage,
      'enableAutoSave': enableAutoSave,
      'dataRefreshInterval': dataRefreshInterval,
      'featureToggles': featureToggles,
    };
  }
  
  /// Factory constructor to create UserPreferences from a map
  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      themeMode: map['themeMode'] ?? 'system',
      useHighContrast: map['useHighContrast'] ?? false,
      accentColor: map['accentColor'] ?? 'green',
      enablePushNotifications: map['enablePushNotifications'] ?? true,
      enableEmailNotifications: map['enableEmailNotifications'] ?? true,
      enableSoundEffects: map['enableSoundEffects'] ?? true,
      enableVibration: map['enableVibration'] ?? true,
      shareUsageData: map['shareUsageData'] ?? false,
      allowLocationTracking: map['allowLocationTracking'] ?? false,
      defaultLanguage: map['defaultLanguage'] ?? 'en',
      enableAutoSave: map['enableAutoSave'] ?? true,
      dataRefreshInterval: map['dataRefreshInterval'] ?? 15,
      featureToggles: map['featureToggles'] != null
          ? Map<String, bool>.from(map['featureToggles'])
          : {},
    );
  }
  
  @override
  List<Object?> get props => [
    themeMode, useHighContrast, accentColor,
    enablePushNotifications, enableEmailNotifications,
    enableSoundEffects, enableVibration,
    shareUsageData, allowLocationTracking,
    defaultLanguage, enableAutoSave, dataRefreshInterval,
    featureToggles,
  ];
}