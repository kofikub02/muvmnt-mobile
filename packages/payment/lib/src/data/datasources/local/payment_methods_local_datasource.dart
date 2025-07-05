import 'dart:convert';

import 'package:mvmnt_cli/core/storage/local_storage/user_local_storage.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';

class PaymentMethodsLocalDatasource {
  static const _savedMethods = 'PAYMENT_METHODS';

  final UserLocalStorage localStorage;

  PaymentMethodsLocalDatasource({required this.localStorage});

  Future<List<PaymentMethodType>> getSavedPaymentMethodTypes() async {
    final savedMethodsJson = localStorage.get(_savedMethods);
    if (savedMethodsJson == null) return [];

    final List<dynamic> savedList = jsonDecode(savedMethodsJson);
    return savedList.map((methodString) {
      return PaymentMethodType.values.firstWhere(
        (type) => type.toString() == methodString,
        orElse: () => PaymentMethodType.unknown,
      );
    }).toList();
  }

  Future<void> savePaymentMethod(PaymentMethodType methodType) async {
    final methods = await getSavedPaymentMethodTypes();

    if (!methods.contains(methodType)) {
      final updated = [...methods, methodType];
      final jsonList = jsonEncode(updated.map((e) => e.toString()).toList());
      await localStorage.set(_savedMethods, jsonList);
    }
  }

  Future<void> removePaymentMethod(PaymentMethodType methodType) async {
    final methods = await getSavedPaymentMethodTypes();

    final updated = methods.where((m) => m != methodType).toList();
    final jsonList = jsonEncode(updated.map((e) => e.toString()).toList());
    await localStorage.set(_savedMethods, jsonList);
  }
}
