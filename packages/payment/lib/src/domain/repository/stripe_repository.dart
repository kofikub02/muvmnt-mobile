import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';

abstract class StripeRepository {
  Future<DataState<List<PaymentMethodEntity>>> retrieveCardMethods();
  Future<DataState<void>> saveCardMethod();
  Future<DataState<void>> removeCardMethod(String paymentId);
}
