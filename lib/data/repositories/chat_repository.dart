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

  DocumentReference<Map<String, dynamic>> get _currentChatDoc =>
      _chatsCollection.doc('current_chat');

  Future<List<ChatMessage>> getChatHistory() async {
    try {
      final docSnapshot = await _currentChatDoc.get();
      
      if (!docSnapshot.exists) {
        // Create a new chat if none exists
        await _currentChatDoc.set(ChatModel(
          id: 'current_chat',
          messages: [],
          createdAt: DateTime.now(),
        ).toMap());
        return [];
      }

      final chatModel = ChatModel.fromMap(docSnapshot.data()!);
      return chatModel.messages.map((msg) => msg.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to get chat history: $e');
    }
  }

  Future<void> addMessage(ChatMessage message) async {
    try {
      final docSnapshot = await _currentChatDoc.get();
      
      if (!docSnapshot.exists) {
        // Create new chat with the message
        await _currentChatDoc.set(ChatModel(
          id: 'current_chat',
          messages: [ChatMessageModel.fromDomain(message)],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ).toMap());
        return;
      }

      // Add message to existing chat
      final chatModel = ChatModel.fromMap(docSnapshot.data()!);
      final updatedMessages = [...chatModel.messages, ChatMessageModel.fromDomain(message)];
      
      await _currentChatDoc.update({
        'messages': updatedMessages.map((msg) => msg.toMap()).toList(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to add message: $e');
    }
  }

  Future<String> generateAIResponse(String userMessage) async {
    try {
      // Get AI response using the AI service
      final response = await _aiService.generateResponse(userMessage);
      return response;
    } catch (e) {
      throw Exception('Failed to generate AI response: $e');
    }
  }

  Future<void> clearChat() async {
    try {
      await _currentChatDoc.set(ChatModel(
        id: 'current_chat',
        messages: [],
        createdAt: DateTime.now(),
      ).toMap());
    } catch (e) {
      throw Exception('Failed to clear chat: $e');
    }
  }
}