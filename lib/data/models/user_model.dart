// data/models/user_model.dart
import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime? lastLogin;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    required this.createdAt,
    this.lastLogin,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String?,
      photoUrl: map['photoUrl'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      lastLogin: map['lastLogin'] != null
          ? DateTime.parse(map['lastLogin'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  User toDomain() {
    return User(
      id: id,
      email: email,
      name: name,
      photoUrl: photoUrl,
      createdAt: createdAt,
      lastLogin: lastLogin,
    );
  }

  factory UserModel.fromDomain(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      photoUrl: user.photoUrl,
      createdAt: user.createdAt,
      lastLogin: user.lastLogin,
    );
  }
}