import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:track_my_money/src/user/domain/user.dart';

class UserMapper {
  const UserMapper._();

  static User fromFirebaseUser(firebase_auth.User firebaseUser) {
    return User(
      code: firebaseUser.uid,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
      displayName: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      photoURL: firebaseUser.photoURL,
      updatedAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );
  }

  static User fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> data = doc.data()!;
    return User(
      code: doc.id,
      createdAt: DateTime.parse(data['createdAt'].toString()),
      displayName: data['displayName'] as String,
      email: data['email'] as String,
      photoURL: data['photoURL'] as String?,
      updatedAt: DateTime.parse(data['updatedAt'].toString()),
    );
  }

  static Map<String, dynamic> toJson(User user) {
    return <String, dynamic>{
      'code': user.code,
      'createdAt': user.createdAt.toIso8601String(),
      'displayName': user.displayName,
      'email': user.email,
      'id': user.id,
      'photoURL': user.photoURL,
      'updatedAt': user.updatedAt.toIso8601String(),
    };
  }
}
