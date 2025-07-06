import 'package:dio/dio.dart';
import 'package:mvmnt_cli/features/settings/data/models/safety_settings_model.dart';

class SafetyRemoteDatasource {
  final Dio dio;

  SafetyRemoteDatasource({required this.dio});

  Future<SafetySettingsModel> getOption() async {
    var response = await dio.get('/orders/settings');

    if (response.statusCode == 200) {
      if (response.data != null && response.data['data'] != null) {
        return SafetySettingsModel.fromJson(response.data['data']);
      }
    }

    throw response.data['message'];
  }

  Future<SafetySettingsModel> updateOption(
    String id,
    Map<String, bool> setting,
  ) async {
    var response = await dio.patch('/orders/settings/$id', data: setting);

    if (response.statusCode == 200) {
      if (response.data != null && response.data['data'] != null) {
        return SafetySettingsModel.fromJson(response.data['data']);
      }
    }

    throw response.data['message'];
  }
}
