// data/models/chat_model.dart
import '../../domain/entities/chat.dart';

class ChatModel {
  final String id;
  final String userId;
  final String message;
  final DateTime timestamp;
  final bool isAiResponse;

  ChatModel({
    required this.id,
    required this.userId,
    required this.message,
    required this.timestamp,
    this.isAiResponse = false,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      message: map['message'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      isAiResponse: map['isAiResponse'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isAiResponse': isAiResponse,
    };
  }

  Chat toDomain() {
    return Chat(
      id: id,
      userId: userId,
      message: message,
      timestamp: timestamp,
      isAiResponse: isAiResponse,
    );
  }

  factory ChatModel.fromDomain(Chat chat) {
    return ChatModel(
      id: chat.id,
      userId: chat.userId,
      message: chat.message,
      timestamp: chat.timestamp,
      isAiResponse: chat.isAiResponse,
    );
  }
}