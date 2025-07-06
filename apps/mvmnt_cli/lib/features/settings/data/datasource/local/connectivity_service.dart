import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mvmnt_cli/features/settings/domain/entities/connectivity_entity.dart';

class ConnectivityService {
  final Connectivity connectivity;

  ConnectivityService({required this.connectivity});

  Stream<ConnectivityEntity> get connectivityStream {
    return connectivity.onConnectivityChanged.map(_mapConnectivityResult);
  }

  Future<ConnectivityEntity> getCurrentConnectivityStatus() async {
    final connectivityResult = await connectivity.checkConnectivity();
    return _mapConnectivityResult(connectivityResult);
  }

  ConnectivityEntity _mapConnectivityResult(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none)) {
      return ConnectivityEntity(status: ConnectivityStatus.disconnected);
    } else if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet) ||
        result.contains(ConnectivityResult.bluetooth) ||
        result.contains(ConnectivityResult.vpn)) {
      return ConnectivityEntity(status: ConnectivityStatus.connected);
    }

    return ConnectivityEntity(status: ConnectivityStatus.unknown);
  }
}
