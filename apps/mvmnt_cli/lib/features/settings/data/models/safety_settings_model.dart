import '../../domain/entities/safety_settings_entity.dart';

class SafetySettingsModel extends SafetySettingsEntity {
  const SafetySettingsModel({required super.id, required super.codeEnabled});

  factory SafetySettingsModel.fromJson(Map<String, dynamic> json) {
    return SafetySettingsModel(
      id: json['_id'],
      codeEnabled: json['code_enabled'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'code_enabled': codeEnabled};
  }

  factory SafetySettingsModel.fromEntity(SafetySettingsEntity entity) {
    return SafetySettingsModel(id: entity.id, codeEnabled: entity.codeEnabled);
  }

  SafetySettingsEntity toEntity() {
    return SafetySettingsEntity(id: id, codeEnabled: codeEnabled);
  }
}
