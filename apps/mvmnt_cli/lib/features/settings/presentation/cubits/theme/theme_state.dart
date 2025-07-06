import 'package:equatable/equatable.dart';
import 'package:mvmnt_cli/features/settings/domain/entities/theme_entity.dart';

enum ThemeStatus { initial, loading, success, error }

class ThemeState extends Equatable {
  final ThemeStatus status;
  final String? errorMessage;
  final ThemeEntity? themeEntity;

  const ThemeState._({
    required this.status,
    this.errorMessage,
    this.themeEntity,
  });

  factory ThemeState.initial() => ThemeState._(status: ThemeStatus.initial);

  ThemeState copyWith({
    ThemeStatus? status,
    String? errorMessage,
    ThemeEntity? themeEntity,
  }) => ThemeState._(
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    themeEntity: themeEntity ?? this.themeEntity,
  );

  @override
  List<Object?> get props => [status, errorMessage, themeEntity];
}
