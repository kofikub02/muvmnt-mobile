import 'package:dio/dio.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/data/datasources/local/current_payment_method_datasource.dart';
import 'package:mvmnt_cli/features/payments/data/models/payment_method_model.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/current_payment_repository.dart';

class CurrentPaymentRepositoryImpl extends CurrentPaymentRepository {

  CurrentPaymentRepositoryImpl({required this.localDatasource});
  final CurrentPaymentMethodDatasource localDatasource;

  @override
  Future<DataState<PaymentMethodEntity?>> getDefaultPaymentMethod() async {
    try {
      final defaultPayment = await localDatasource.getDefaultPaymentMethod();
      return DataSuccess(defaultPayment);
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
  Future<DataState<void>> setDefaultPaymentMethod(
    PaymentMethodEntity paymentMethod,
  ) async {
    try {
      await localDatasource.setDefaultPaymentMethod(
        PaymentMethodModel.fromEntity(paymentMethod),
      );
      return DataSuccess(null);
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
