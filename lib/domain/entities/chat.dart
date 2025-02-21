// lib/domain/entities/chat.dart
import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isUser;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isUser,
  });

  @override
  List<Object> get props => [id, content, timestamp, isUser];

  ChatMessage copyWith({
    String? id,
    String? content,
    DateTime? timestamp,
    bool? isUser,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isUser: isUser ?? this.isUser,
    );
  }
}

class Chat extends Equatable {
  final String id;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Chat({
    required this.id,
    required this.messages,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, messages, createdAt, updatedAt];

  Chat copyWith({
    String? id,
    List<ChatMessage>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Chat(
      id: id ?? this.id,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}