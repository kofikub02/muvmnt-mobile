import 'package:equatable/equatable.dart';

enum EmailAuthStatus {
  initial,
  loading,
  success,
  resetSuccess,
  verificationSent,
  verificationConfirmed,
  error,
}

class EmailAuthState extends Equatable {
  final EmailAuthStatus status;
  final String? errorMessage;

  const EmailAuthState({
    this.status = EmailAuthStatus.initial,
    this.errorMessage,
  });

  EmailAuthState copyWith({EmailAuthStatus? status, String? errorMessage}) {
    return EmailAuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
