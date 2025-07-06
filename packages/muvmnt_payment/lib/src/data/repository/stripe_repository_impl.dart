import 'package:dio/dio.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/data/datasources/remote/stripe_remote_datasource.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/stripe_repository.dart';

class StripeRepositoryImpl extends StripeRepository {

  StripeRepositoryImpl({required this.remoteDatasouce});
  final StripeRemoteDatasource remoteDatasouce;

  @override
  Future<DataState<List<PaymentMethodEntity>>> retrieveCardMethods() async {
    try {
      final result = await remoteDatasouce.retrieveCardMethods();
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
  Future<DataState<void>> saveCardMethod() async {
    try {
      return DataSuccess(await remoteDatasouce.saveCardMethod());
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
  Future<DataState<void>> removeCardMethod(String paymentMethodId) async {
    try {
      return DataSuccess(
        await remoteDatasouce.removeCardMethod(paymentMethodId),
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
}
