import 'package:dio/dio.dart';
import 'package:mvmnt_cli/features/support/data/models/support_session_model.dart';
import 'package:mvmnt_cli/features/support/domain/entities/support_session_entity.dart';

class SupportSessionRemoteDataSource {
  final Dio dio;

  SupportSessionRemoteDataSource({required this.dio});

  Future<List<SupportSessionModel>> getAll() async {
    final response = await dio.get('/orders/support');

    if (response.statusCode == 200) {
      if (response.data != null && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map(
              (json) =>
                  SupportSessionModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      }
    }

    throw response.data['message'];
  }

  Future<SupportSessionEntity> create(String orderId) async {
    final response = await dio.post(
      '/orders/support/',
      data: {'order_id': orderId, 'locale': 'en'},
    );

    if (response.statusCode == 200) {
      if (response.data != null && response.data['data'] != null) {
        return SupportSessionModel.fromJson(response.data['data']);
      }
    }

    throw response.data['message'];
  }
}
