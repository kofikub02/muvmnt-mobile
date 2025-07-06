enum PhoneAuthStatus { initial, loading, codeSent, verified, failure, timeout }

class PhoneAuthState {
  final PhoneAuthStatus status;
  final String? errorMessage;
  final String? verificationId;
  final int? resendToken;

  const PhoneAuthState({
    this.status = PhoneAuthStatus.initial,
    this.errorMessage,
    this.verificationId,
    this.resendToken,
  });

  PhoneAuthState copyWith({
    PhoneAuthStatus? status,
    String? errorMessage,
    String? verificationId,
    int? resendToken,
  }) {
    return PhoneAuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      verificationId: verificationId ?? this.verificationId,
      resendToken: resendToken ?? this.resendToken,
    );
  }
}
