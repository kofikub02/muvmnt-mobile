import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';

abstract class PaypalRepository {
  Future<DataState<List<PaymentMethodEntity>>> getMethods();
  Future<DataState<void>> removeMethod(String methodId);
  Future<DataState<Map<String, dynamic>>> setupPaymentToken();
  Future<DataState<PaymentMethodEntity>> createPaymentToken(
    String setupTokenId,
  );
}
