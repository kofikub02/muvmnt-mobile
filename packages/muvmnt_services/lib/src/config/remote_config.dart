import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfig {

  RemoteConfig({required this.remoteConfig});
  final FirebaseRemoteConfig remoteConfig;

  Future<void> initialize() async {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
  }
}
