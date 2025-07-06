import 'package:dio/dio.dart';
import 'package:mvmnt_cli/features/referral/data/models/referral_code_model.dart';
import 'package:mvmnt_cli/features/referral/data/models/referral_model.dart';

class ReferralRemoteDatasource {
  final Dio dio;

  ReferralRemoteDatasource({required this.dio});

  Future<ReferralCodeModel> getCode() async {
    var response = await dio.get('/users/referrals/code');

    if (response.statusCode == 200) {
      if (response.data != null && response.data['data'] != null) {
        return ReferralCodeModel.fromJson(response.data['data']);
      }
    }

    throw response.data['message'];
  }

  Future<List<ReferralModel>> getReferrals() async {
    var response = await dio.get('/users/referrals/issued');

    if (response.statusCode == 200) {
      if (response.data != null && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((json) => ReferralModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    }

    throw response.data['message'];
  }
}
