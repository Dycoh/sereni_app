import 'dart:async';  // Added for TimeoutException
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class AIService {
  static const String _modelName = 'gemini-pro';
  static const int _maxRetries = 2;  // Reduced retries for rate limiting
  
  late final GenerativeModel _model;
  late ChatSession _chat;
  
  final List<Content> _history = [];
  bool _isInitialized = false;
  
  AIService() {
    _initializeModel();
  }
  
  void _initializeModel() {
    try {
      if (!dotenv.isInitialized) {
        throw Exception('Environment variables not initialized. Call dotenv.load() first.');
      }
      
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('GEMINI_API_KEY not found in environment variables. Please check your .env file.');
      }

      _model = GenerativeModel(
        model: _modelName,
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 2048,  // Adjusted for free tier
        ),
      );

      _chat = _model.startChat(history: _history);
      _isInitialized = true;
      
      debugPrint('AI Service initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('Failed to initialize AI Service: $e');
      debugPrint('Stack trace: $stackTrace');
      _isInitialized = false;
      rethrow;
    }
  }

  Future<String> generateResponse(String userMessage) async {
    if (!_isInitialized) {
      throw Exception('AI Service not properly initialized');
    }
    
    if (userMessage.trim().isEmpty) {
      throw ArgumentError('User message cannot be empty');
    }

    // Check history length and clear if needed to prevent token limit issues
    if (_history.length > 10) {
      await clearHistory();
    }

    int attempts = 0;
    while (attempts < _maxRetries) {
      try {
        final userContent = Content.text(userMessage);
        _history.add(userContent);

        // Using a shorter timeout for free tier
        final response = await _chat.sendMessage(userContent)
            .timeout(
              const Duration(seconds: 15),
              onTimeout: () => throw TimeoutException('Response generation timed out'),
            );
        
        final responseText = response.text ?? 'I apologize, but I was unable to generate a response.';
        
        if (responseText.trim().isEmpty) {
          throw Exception('Empty response received from AI');
        }
        
        _history.add(Content.text(responseText));
        
        return responseText;
      } catch (e) {
        attempts++;
        debugPrint('AI response generation attempt $attempts failed: $e');
        
        if (e.toString().contains('429') || e.toString().contains('rate limit')) {
          // Rate limit hit - wait longer before retry
          await Future.delayed(Duration(seconds: 5 * attempts));
        }
        
        if (attempts >= _maxRetries) {
          if (e.toString().contains('429')) {
            return "I'm receiving too many requests right now. Please try again in a few moments.";
          }
          throw Exception('Failed to generate AI response: $e');
        }
        
        // Standard retry delay
        await Future.delayed(Duration(seconds: attempts));
      }
    }
    
    throw Exception('Failed to generate response after $attempts attempts');
  }

  Future<void> clearHistory() async {
    if (!_isInitialized) {
      throw Exception('AI Service not properly initialized');
    }
    
    try {
      _history.clear();
      _chat = _model.startChat(history: _history);
      debugPrint('Chat history cleared successfully');
    } catch (e) {
      debugPrint('Failed to clear chat history: $e');
      rethrow;
    }
  }
  
  bool get isInitialized => _isInitialized;
  
  int get historyLength => _history.length;
}

// Extension to help with response handling
extension ContentHelpers on Content {
  String? get text => parts
      .whereType<TextPart>()
      .map((part) => part.text)
      .join(' ');
}