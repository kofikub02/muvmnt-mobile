import 'package:equatable/equatable.dart';
import 'package:mvmnt_cli/features/settings/domain/entities/safety_settings_entity.dart';

enum SafetyStatus { initial, loading, success, error }

class SafetyState extends Equatable {
  final SafetyStatus status;
  final String? errorMessage;
  final SafetySettingsEntity? settings;

  const SafetyState._({required this.status, this.errorMessage, this.settings});

  factory SafetyState.initial() => SafetyState._(status: SafetyStatus.initial);

  SafetyState copyWith({
    SafetyStatus? status,
    String? errorMessage,
    SafetySettingsEntity? settings,
  }) => SafetyState._(
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    settings: settings ?? this.settings,
  );

  @override
  List<Object?> get props => [status, errorMessage, settings];
}
