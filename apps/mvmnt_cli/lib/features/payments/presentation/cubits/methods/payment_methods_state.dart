import 'package:equatable/equatable.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';

enum PaymentMethodsStatus {
  initial,
  loading,
  updated,
  success,
  adding,
  failure,
}

class PaymentMethodsState extends Equatable {
  final PaymentMethodsStatus status;
  final String? selectedMethodId;
  final List<PaymentMethodEntity> activeMethodTypes;
  final List<PaymentMethodEntity> availableMethodTypes;
  final String? errorMessage;

  const PaymentMethodsState({
    this.status = PaymentMethodsStatus.initial,
    this.selectedMethodId,
    this.activeMethodTypes = const [],
    this.availableMethodTypes = const [],
    this.errorMessage,
  });

  PaymentMethodsState copyWith({
    PaymentMethodsStatus? status,
    String? selectedMethodId,
    List<PaymentMethodEntity>? activeMethodTypes,
    List<PaymentMethodEntity>? availableMethodTypes,
    String? errorMessage,
  }) {
    return PaymentMethodsState(
      status: status ?? this.status,
      selectedMethodId: selectedMethodId ?? this.selectedMethodId,
      activeMethodTypes: activeMethodTypes ?? this.activeMethodTypes,
      availableMethodTypes: availableMethodTypes ?? this.availableMethodTypes,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedMethodId,
    activeMethodTypes,
    availableMethodTypes,
    errorMessage,
  ];
}
