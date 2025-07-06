import 'package:mvmnt_cli/features/settings/domain/entities/connectivity_entity.dart';

abstract class ConnectivityRepository {
  Stream<ConnectivityEntity> get connectivityStatusStream;
  Future<ConnectivityEntity> checkConnectivity();
}
