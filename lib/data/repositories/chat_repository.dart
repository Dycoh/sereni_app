// lib/data/repositories/chat_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/chat.dart';
import '../models/chat_model.dart';
import '../services/ai_service.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final AIService _aiService;

  ChatRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    AIService? aiService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _aiService = aiService ?? AIService();

  CollectionReference<Map<String, dynamic>> get _chatsCollection =>
      _firestore.collection('users').doc(_auth.currentUser?.uid).collection('chats');

  Future<void> initializeChat(String chatId) async {
    try {
      final docRef = _chatsCollection.doc(chatId);
      final docSnapshot = await docRef.get();
      
      if (!docSnapshot.exists) {
        await docRef.set({
          'id': chatId,
          'messages': [],
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      throw Exception('Failed to initialize chat: $e');
    }
  }

  Future<List<ChatMessage>> getChatHistory(String chatId) async {
    try {
      final docSnapshot = await _chatsCollection.doc(chatId).get();
      
      if (!docSnapshot.exists) {
        await initializeChat(chatId);
        return [];
      }
      
      final chatModel = ChatModel.fromMap(docSnapshot.data()!);
      return chatModel.messages.map((msg) => msg.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to get chat history: $e');
    }
  }

  Future<void> addMessage(String chatId, ChatMessage message) async {
    try {
      final docRef = _chatsCollection.doc(chatId);
      final docSnapshot = await docRef.get();
      
      if (!docSnapshot.exists) {
        // Create new chat document with initial message
        await docRef.set({
          'id': chatId,
          'messages': [ChatMessageModel.fromDomain(message).toMap()],
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });
      } else {
        // Update existing chat document
        final chatModel = ChatModel.fromMap(docSnapshot.data()!);
        final updatedMessages = [...chatModel.messages, ChatMessageModel.fromDomain(message)];
        
        await docRef.update({
          'messages': updatedMessages.map((msg) => msg.toMap()).toList(),
          'updatedAt': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      throw Exception('Failed to add message: $e');
    }
  }

  Future<String> generateAIResponse(String userMessage) async {
    try {
      return await _aiService.generateResponse(userMessage);
    } catch (e) {
      throw Exception('Failed to generate AI response: $e');
    }
  }

  Future<void> clearChat(String chatId) async {
    try {
      final docRef = _chatsCollection.doc(chatId);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        await initializeChat(chatId);
      }

      await docRef.update({
        'messages': [],
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to clear chat: $e');
    }
  }

  // Helper method to check if user is authenticated
  bool get isUserAuthenticated => _auth.currentUser != null;

  // Helper method to get current user ID
  String? get currentUserId => _auth.currentUser?.uid;
}