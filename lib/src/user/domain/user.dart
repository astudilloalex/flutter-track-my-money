class User {
  const User({
    this.code = '',
    required this.createdAt,
    this.displayName = '',
    required this.email,
    this.id = 0,
    this.photoURL,
    required this.updatedAt,
  });

  final String code;
  final DateTime createdAt;
  final String displayName;
  final String email;
  final int id;
  final String? photoURL;
  final DateTime updatedAt;

  User copyWith({
    String? code,
    DateTime? createdAt,
    String? displayName,
    String? email,
    int? id,
    String? photoURL,
    DateTime? updatedAt,
  }) {
    return User(
      code: code ?? this.code,
      createdAt: createdAt ?? this.createdAt,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      id: id ?? this.id,
      photoURL: photoURL ?? this.photoURL,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
