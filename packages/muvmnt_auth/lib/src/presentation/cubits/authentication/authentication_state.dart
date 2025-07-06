import 'package:equatable/equatable.dart';
import 'package:muvmnt_auth/src/domain/entities/auth_entity.dart';

enum AuthenticationStatus {
  initial,
  loading,
  authenticated,
  failure,
  unauthenticated,
}

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final String? errorMessage;
  final AuthEntity? authEntity;

  const AuthenticationState._({
    required this.status,
    this.errorMessage,
    this.authEntity,
  });

  factory AuthenticationState.initial() =>
      AuthenticationState._(status: AuthenticationStatus.initial);

  AuthenticationState copyWith({
    AuthenticationStatus? status,
    String? errorMessage,
    AuthEntity? authEntity,
  }) => AuthenticationState._(
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    authEntity: authEntity ?? this.authEntity,
  );

  @override
  List<Object?> get props => [status, errorMessage, authEntity];
}
