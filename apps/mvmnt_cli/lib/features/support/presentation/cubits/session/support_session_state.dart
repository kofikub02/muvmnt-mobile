import 'package:equatable/equatable.dart';
import 'package:mvmnt_cli/features/support/domain/entities/support_session_entity.dart';

enum SessionStatus { initial, loading, loaded, created, error }

class SupportSessionState extends Equatable {
  final SessionStatus status;
  final List<SupportSessionEntity> activeSessions;
  final String? errorMessage;

  const SupportSessionState({
    this.status = SessionStatus.initial,
    this.activeSessions = const [],
    this.errorMessage,
  });

  SupportSessionState copyWith({
    SessionStatus? status,
    List<SupportSessionEntity>? activeSessions,
    String? errorMessage,
  }) {
    return SupportSessionState(
      status: status ?? this.status,
      activeSessions: activeSessions ?? this.activeSessions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, activeSessions, errorMessage];
}
