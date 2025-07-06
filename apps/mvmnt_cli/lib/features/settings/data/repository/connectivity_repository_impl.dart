import 'package:mvmnt_cli/features/settings/data/datasource/local/connectivity_service.dart';
import 'package:mvmnt_cli/features/settings/domain/entities/connectivity_entity.dart';
import 'package:mvmnt_cli/features/settings/domain/repository/connectivity_repository.dart';

class ConnectivityRepositoryImpl implements ConnectivityRepository {
  final ConnectivityService connectionDataSource;

  ConnectivityRepositoryImpl({required this.connectionDataSource});

  @override
  Stream<ConnectivityEntity> get connectivityStatusStream {
    return connectionDataSource.connectivityStream;
  }

  @override
  Future<ConnectivityEntity> checkConnectivity() {
    return connectionDataSource.getCurrentConnectivityStatus();
  }
}
