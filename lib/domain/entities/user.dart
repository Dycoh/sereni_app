// domain/entities/user.dart
class User {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime? lastLogin;

  User({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    required this.createdAt,
    this.lastLogin,
  });
}
