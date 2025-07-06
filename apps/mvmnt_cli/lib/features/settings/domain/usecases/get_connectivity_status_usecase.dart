import 'package:mvmnt_cli/features/settings/domain/entities/connectivity_entity.dart';
import 'package:mvmnt_cli/features/settings/domain/repository/connectivity_repository.dart';

class GetConnectivityStatusUseCase {
  final ConnectivityRepository connectivityRepository;

  GetConnectivityStatusUseCase({required this.connectivityRepository});

  Stream<ConnectivityEntity> call() {
    return connectivityRepository.connectivityStatusStream;
  }
}
