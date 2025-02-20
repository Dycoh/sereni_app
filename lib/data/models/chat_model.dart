// lib/data/models/chat_model.dart

import '../../domain/entities/chat.dart';

class ChatMessageModel {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isUser;

  ChatMessageModel({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isUser,
  });

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      id: map['id'] as String,
      content: map['content'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      isUser: map['isUser'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isUser': isUser,
    };
  }

  ChatMessage toDomain() {
    return ChatMessage(
      id: id,
      content: content,
      timestamp: timestamp,
      isUser: isUser,
    );
  }

  factory ChatMessageModel.fromDomain(ChatMessage message) {
    return ChatMessageModel(
      id: message.id,
      content: message.content,
      timestamp: message.timestamp,
      isUser: message.isUser,
    );
  }
}

class ChatModel {
  final String id;
  final List<ChatMessageModel> messages;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ChatModel({
    required this.id,
    required this.messages,
    required this.createdAt,
    this.updatedAt,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] as String,
      messages: (map['messages'] as List<dynamic>)
          .map((msg) => ChatMessageModel.fromMap(msg as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'messages': messages.map((msg) => msg.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Chat toDomain() {
    return Chat(
      id: id,
      messages: messages.map((msg) => msg.toDomain()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ChatModel.fromDomain(Chat chat) {
    return ChatModel(
      id: chat.id,
      messages: chat.messages
          .map((msg) => ChatMessageModel.fromDomain(msg))
          .toList(),
      createdAt: chat.createdAt,
      updatedAt: chat.updatedAt,
    );
  }
}