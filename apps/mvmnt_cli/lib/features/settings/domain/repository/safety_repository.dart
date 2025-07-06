import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/settings/domain/entities/safety_settings_entity.dart';

abstract class SafetyRepository {
  Future<DataState<SafetySettingsEntity>> getSafetySettings();
  Future<DataState<SafetySettingsEntity>> updateSafetySettings(
    String id,
    Map<String, bool> setting,
  );
}
