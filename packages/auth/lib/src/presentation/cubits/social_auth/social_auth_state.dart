enum SocialAuthStatus { initial, loading, success, failure }

class SocialAuthState {
  final SocialAuthStatus status;
  final String? errorMessage;

  const SocialAuthState({
    this.status = SocialAuthStatus.initial,
    this.errorMessage,
  });

  SocialAuthState copyWith({SocialAuthStatus? status, String? errorMessage}) {
    return SocialAuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
