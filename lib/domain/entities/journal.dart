// domain/entities/journal.dart
class Journal {
  final String id;
  final String userId;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String>? tags;
  final Map<String, dynamic>? metadata;

  Journal({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.tags,
    this.metadata,
  });
}