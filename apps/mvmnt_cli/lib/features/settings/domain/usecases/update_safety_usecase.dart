import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/settings/domain/entities/safety_settings_entity.dart';
import 'package:mvmnt_cli/features/settings/domain/repository/safety_repository.dart';

class UpdateSafetyUsecase {
  final SafetyRepository safetyRepository;

  UpdateSafetyUsecase({required this.safetyRepository});

  Future<DataState<SafetySettingsEntity>> call(
    String id,
    Map<String, bool> setting,
  ) {
    return safetyRepository.updateSafetySettings(id, setting);
  }
}
