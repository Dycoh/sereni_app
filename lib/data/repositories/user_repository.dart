import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/entities/user.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromMap(doc.data()!).toDomain();
  }

  Future<void> createUserProfile(firebase_auth.User user) async {
    final userModel = UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      createdAt: DateTime.now(),
    );

    await _firestore.collection('users').doc(user.uid).set(
      userModel.toMap(),
      SetOptions(merge: true),
    );
  }

  Future<void> updateUser(User user) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('No authenticated user');

    await _firestore.collection('users').doc(currentUser.uid).set(
      UserModel.fromDomain(user).toMap(),
      SetOptions(merge: true),
    );
  }

  Future<void> deleteUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('No authenticated user');

    await _firestore.collection('users').doc(currentUser.uid).delete();
    await currentUser.delete();
  }

  Stream<User?> get userStream {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return Stream.value(null);

    return _firestore.collection('users').doc(currentUser.uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data()!).toDomain();
    });
  }
}