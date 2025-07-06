import 'package:equatable/equatable.dart';

class SafetySettingsEntity extends Equatable {
  final String id;
  final bool codeEnabled;

  const SafetySettingsEntity({required this.id, required this.codeEnabled});

  @override
  List<Object?> get props => [id, codeEnabled];
}
