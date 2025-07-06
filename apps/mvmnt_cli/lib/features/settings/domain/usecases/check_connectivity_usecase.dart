import 'package:mvmnt_cli/features/settings/domain/entities/connectivity_entity.dart';
import 'package:mvmnt_cli/features/settings/domain/repository/connectivity_repository.dart';

class CheckConnectivityUseCase {
  final ConnectivityRepository connectivityRepository;

  CheckConnectivityUseCase({required this.connectivityRepository});

  Future<ConnectivityEntity> call() {
    return connectivityRepository.checkConnectivity();
  }
}
