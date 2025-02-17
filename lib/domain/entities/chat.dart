// domain/entities/chat.dart
class Chat {
  final String id;
  final String userId;
  final String message;
  final DateTime timestamp;
  final bool isAiResponse;

  Chat({
    required this.id,
    required this.userId,
    required this.message,
    required this.timestamp,
    this.isAiResponse = false,
  });
}