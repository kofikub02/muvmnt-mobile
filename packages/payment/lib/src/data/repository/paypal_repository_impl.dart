import 'package:dio/dio.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/data/datasources/remote/paypal_remote_datasouce.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/paypal_repository.dart';

class PaypalRepositoryImpl extends PaypalRepository {

  PaypalRepositoryImpl({required this.remoteDatasouce});
  final PaypalRemoteDatasouce remoteDatasouce;

  @override
  Future<DataState<List<PaymentMethodEntity>>> getMethods() async {
    try {
      final result = await remoteDatasouce.getMethods();
      return DataSuccess(result.map((c) => c.toEntity()).toList());
    } catch (error) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(),
          error: error.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<Map<String, dynamic>>> setupPaymentToken() async {
    try {
      return DataSuccess(await remoteDatasouce.createSetupToken());
    } catch (error) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(),
          error: error.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<PaymentMethodEntity>> createPaymentToken(
    String setupTokenId,
  ) async {
    try {
      return DataSuccess(
        await remoteDatasouce.createPaymentToken(setupTokenId),
      );
    } catch (error) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(),
          error: error.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<void>> removeMethod(String methodId) async {
    try {
      return DataSuccess(await remoteDatasouce.removePaypalMethod(methodId));
    } catch (error) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(),
          error: error.toString(),
        ),
      );
    }
  }
}
