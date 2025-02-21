// lib/data/repositories/journal_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/journal.dart';
import '../models/journal_model.dart';
import '../../domain/repositories/base_repository.dart';

class JournalRepository with BaseRepository<Journal> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _journalsCollection =>
      _firestore.collection('users').doc(_auth.currentUser?.uid).collection('journals');

  @override
  Future<Journal?> getById(String id) async {
    final doc = await _journalsCollection.doc(id).get();
    return doc.exists ? JournalModel.fromMap(doc.data()!).toDomain() : null;
  }

  @override
  Future<List<Journal>> getAll() async {
    final snapshot = await _journalsCollection.get();
    return snapshot.docs.map((doc) => JournalModel.fromMap(doc.data()).toDomain()).toList();
  }

  @override
  Future<void> create(Journal journal) async {
    final model = JournalModel.fromDomain(journal);
    await _journalsCollection.doc(model.id).set(model.toMap());
  }

  @override
  Future<void> update(Journal journal) async {
    final model = JournalModel.fromDomain(journal);
    await _journalsCollection.doc(model.id).update(model.toMap());
  }

  @override
  Future<void> delete(String id) async {
    await _journalsCollection.doc(id).delete();
  }

  Stream<List<Journal>> get journalStream {
    return _journalsCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => JournalModel.fromMap(doc.data()).toDomain())
        .toList());
  }
}
