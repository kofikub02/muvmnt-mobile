import 'package:dio/dio.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/data/datasources/local/payment_methods_local_datasource.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/payment_methods_repository.dart';

class PaymentMethodsRepositoryImpl extends PaymentMethodsRepository {
  final PaymentMethodsLocalDatasource localDatasource;

  PaymentMethodsRepositoryImpl({required this.localDatasource});

  @override
  Future<DataState<List<PaymentMethodType>>> getActivePaymentMethods() async {
    try {
      final methods = await localDatasource.getSavedPaymentMethodTypes();
      return DataSuccess(methods);
    } catch (error) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: error.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<void>> removePaymentMethod(
    PaymentMethodType paymentMethod,
  ) async {
    try {
      await localDatasource.removePaymentMethod(paymentMethod);
      return DataSuccess(null);
    } catch (error) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: error.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<void>> savePaymentMethod(
    PaymentMethodType paymentMethod,
  ) async {
    try {
      await localDatasource.savePaymentMethod(paymentMethod);
      return DataSuccess(null);
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
