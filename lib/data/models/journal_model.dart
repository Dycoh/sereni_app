// data/models/journal_model.dart
import '../../domain/entities/journal.dart';

class JournalModel {
  final String id;
  final String userId;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String>? tags;
  final Map<String, dynamic>? metadata;

  JournalModel({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.tags,
    this.metadata,
  });

  factory JournalModel.fromMap(Map<String, dynamic> map) {
    return JournalModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      tags: (map['tags'] as List?)?.cast<String>(),
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'tags': tags,
      'metadata': metadata,
    };
  }

  Journal toDomain() {
    return Journal(
      id: id,
      userId: userId,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
      tags: tags,
      metadata: metadata,
    );
  }

  factory JournalModel.fromDomain(Journal journal) {
    return JournalModel(
      id: journal.id,
      userId: journal.userId,
      content: journal.content,
      createdAt: journal.createdAt,
      updatedAt: journal.updatedAt,
      tags: journal.tags,
      metadata: journal.metadata,
    );
  }
}