import 'package:auth/src/domain/entities/auth_entity.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AuthModel extends AuthEntity {
  const AuthModel({super.id, super.isAnonymous});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(id: json['id'], isAnonymous: json['isAnonymous']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'isAnonymous': isAnonymous};
  }

  // Create an empty auth model for unauthenticated state
  factory AuthModel.empty() {
    return const AuthModel(id: '', isAnonymous: false);
  }

  // Copy with method for immutable updates
  AuthModel copyWith({bool? isAnonymous, String? id}) {
    return AuthModel(
      id: id ?? this.id,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }

  factory AuthModel.fromFirebaseAuthUser(firebase_auth.User firebaseUser) {
    return AuthModel(
      id: firebaseUser.uid,
      isAnonymous: firebaseUser.isAnonymous,
    );
  }
}
