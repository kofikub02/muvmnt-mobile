import 'package:equatable/equatable.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';

enum CurrentPaymentStatus { initial, loading, success, failure }

class CurrentPaymentState extends Equatable {
  final CurrentPaymentStatus status;
  final PaymentMethodEntity? currentMethod;
  final String? errorMessage;

  const CurrentPaymentState({
    this.status = CurrentPaymentStatus.initial,
    this.currentMethod,
    this.errorMessage,
  });

  CurrentPaymentState copyWith({
    CurrentPaymentStatus? status,
    PaymentMethodEntity? selectedMethodId,
    String? errorMessage,
  }) {
    return CurrentPaymentState(
      status: status ?? this.status,
      currentMethod: selectedMethodId ?? this.currentMethod,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, currentMethod, errorMessage];
}
