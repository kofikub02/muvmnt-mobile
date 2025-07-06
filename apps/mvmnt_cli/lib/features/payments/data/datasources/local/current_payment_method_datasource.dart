import 'dart:convert';

import 'package:mvmnt_cli/core/storage/local_storage/user_local_storage.dart';
import 'package:mvmnt_cli/features/payments/data/models/payment_method_model.dart';

class CurrentPaymentMethodDatasource {
  static const _currentKey = 'CURRENT_PAYMENT_METHOD';

  final UserLocalStorage localStorage;

  CurrentPaymentMethodDatasource({required this.localStorage});

  Future<void> setDefaultPaymentMethod(PaymentMethodModel method) async {
    await localStorage.set(_currentKey, jsonEncode(method.toJson()));
  }

  Future<PaymentMethodModel?> getDefaultPaymentMethod() async {
    final String? methodJson = localStorage.get(_currentKey);
    if (methodJson == null) return null;

    return PaymentMethodModel.fromJson(jsonDecode(methodJson));
  }
}
