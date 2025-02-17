// journal_repository.dart
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
    if (!doc.exists) return null;
    return JournalModel.fromMap(doc.data()!).toDomain();
  }

  @override
  Future<List<Journal>> getAll() async {
    final snapshot = await _journalsCollection.get();
    return snapshot.docs
        .map((doc) => JournalModel.fromMap(doc.data()).toDomain())
        .toList();
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

  Future<List<Journal>> getJournalsByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await _journalsCollection
        .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
        .where('createdAt', isLessThan: endOfDay)
        .get();

    return snapshot.docs
        .map((doc) => JournalModel.fromMap(doc.data()).toDomain())
        .toList();
  }

  Future<List<Journal>> getJournalsByDateRange(DateTime start, DateTime end) async {
    final snapshot = await _journalsCollection
        .where('createdAt', isGreaterThanOrEqualTo: start)
        .where('createdAt', isLessThan: end)
        .get();

    return snapshot.docs
        .map((doc) => JournalModel.fromMap(doc.data()).toDomain())
        .toList();
  }

  Stream<List<Journal>> get journalStream {
    return _journalsCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => JournalModel.fromMap(doc.data()).toDomain())
        .toList());
  }
}