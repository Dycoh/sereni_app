// chat_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/chat.dart';
import '../models/chat_model.dart';
import '../../domain/repositories/base_repository.dart';

class ChatRepository with BaseRepository<Chat> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _chatsCollection =>
      _firestore.collection('users').doc(_auth.currentUser?.uid).collection('chats');

  @override
  Future<Chat?> getById(String id) async {
    final doc = await _chatsCollection.doc(id).get();
    if (!doc.exists) return null;
    return ChatModel.fromMap(doc.data()!).toDomain();
  }

  @override
  Future<List<Chat>> getAll() async {
    final snapshot = await _chatsCollection.orderBy('timestamp', descending: true).get();
    return snapshot.docs
        .map((doc) => ChatModel.fromMap(doc.data()).toDomain())
        .toList();
  }

  @override
  Future<void> create(Chat chat) async {
    final model = ChatModel.fromDomain(chat);
    await _chatsCollection.doc(model.id).set(model.toMap());
  }

  @override
  Future<void> update(Chat chat) async {
    final model = ChatModel.fromDomain(chat);
    await _chatsCollection.doc(model.id).update(model.toMap());
  }

  @override
  Future<void> delete(String id) async {
    await _chatsCollection.doc(id).delete();
  }

  Future<List<Chat>> getChatHistory() async {
    final snapshot = await _chatsCollection
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();

    return snapshot.docs
        .map((doc) => ChatModel.fromMap(doc.data()).toDomain())
        .toList();
  }

  Future<Chat> sendMessage(String message) async {
    final chat = Chat(
      id: DateTime.now().toIso8601String(),
      userId: _auth.currentUser?.uid ?? '',
      message: message,
      timestamp: DateTime.now(),
      isAiResponse: false,
    );

    await create(chat);
    return chat;
  }
}