import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';

abstract class CurrentPaymentRepository {
  Future<DataState<void>> setDefaultPaymentMethod(
    PaymentMethodEntity paymentMethodId,
  );
  Future<DataState<PaymentMethodEntity?>> getDefaultPaymentMethod();
}
