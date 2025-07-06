import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';

List<PaymentMethodEntity> availableLocalPaymentMethods = [
  PaymentMethodEntity(
    id: 'applepay',
    name: 'Apple Pay',
    icon: 'applepay',
    type: PaymentMethodType.applepay,
  ),
  PaymentMethodEntity(
    id: 'googlepay',
    name: 'Google Pay',
    icon: 'googlepay',
    type: PaymentMethodType.googlepay,
  ),
  PaymentMethodEntity(
    id: 'cash',
    name: 'Cash',
    icon: 'cash',
    type: PaymentMethodType.cash,
  ),
];
