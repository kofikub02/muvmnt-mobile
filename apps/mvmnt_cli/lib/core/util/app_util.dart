import 'package:geolocator/geolocator.dart';

Future<bool> openAppSettings() async {
  return await Geolocator.openAppSettings();
}
