// lib/configuration/config.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';

class EnvironmentConfig {
  static final Logger _logger = Logger('EnvironmentConfig');

  // Getter for Gemini API key
  static String get geminiApiKey {
    // Get the API key from .env file, return empty string if not found
    return dotenv.env['GEMINI_API_KEY'] ?? '';
  }

  // Error checking method
  static bool validateConfig() {
    if (geminiApiKey.isEmpty) {
      _logger.warning('GEMINI_API_KEY is not set in .env file');
      return false;
    }
    return true;
  }
}