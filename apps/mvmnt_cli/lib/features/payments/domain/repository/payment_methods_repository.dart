import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';

abstract class PaymentMethodsRepository {
  Future<DataState<List<PaymentMethodType>>> getActivePaymentMethods();
  Future<DataState<void>> savePaymentMethod(PaymentMethodType paymentMethod);
  Future<DataState<void>> removePaymentMethod(PaymentMethodType paymentMethod);
}
