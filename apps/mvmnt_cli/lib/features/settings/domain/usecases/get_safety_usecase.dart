import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/settings/domain/entities/safety_settings_entity.dart';
import 'package:mvmnt_cli/features/settings/domain/repository/safety_repository.dart';

class GetSafetyUsecase {
  final SafetyRepository safetyRepository;

  GetSafetyUsecase({required this.safetyRepository});

  Future<DataState<SafetySettingsEntity>> call() {
    return safetyRepository.getSafetySettings();
  }
}
