import 'package:dio/dio.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/referral/data/datasources/remote/referral_remote_datasource.dart';
import 'package:mvmnt_cli/features/referral/domain/entities/referral_code_entity.dart';
import 'package:mvmnt_cli/features/referral/domain/entities/referral_entity.dart';
import 'package:mvmnt_cli/features/referral/domain/repository/referral_repository.dart';

class ReferralRepositoryImpl extends ReferralRepository {
  final ReferralRemoteDatasource remoteDatasource;

  ReferralRepositoryImpl({required this.remoteDatasource});

  @override
  Future<DataState<List<ReferralEntity>>> getIssuedReferrals() async {
    try {
      final result = await remoteDatasource.getReferrals();
      return DataSuccess(result);
    } catch (error) {
      print(error);
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: error.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<ReferralCodeEntity>> getReferralCode() async {
    try {
      return DataSuccess((await remoteDatasource.getCode()).toEntity());
    } catch (error) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: error.toString(),
        ),
      );
    }
  }
}
