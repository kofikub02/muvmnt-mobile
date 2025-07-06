import 'package:equatable/equatable.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_credits_entity.dart';

enum PaymentCreditsStatus { initial, loading, loaded, error }

class PaymentCreditsState extends Equatable {

  const PaymentCreditsState({
    this.status = PaymentCreditsStatus.initial,
    this.credits,
    this.errorMessage,
  });
  final PaymentCreditsStatus status;
  final PaymentCreditsEntity? credits;
  final String? errorMessage;

  PaymentCreditsState copyWith({
    PaymentCreditsStatus? status,
    PaymentCreditsEntity? credits,
    String? errorMessage,
  }) {
    return PaymentCreditsState(
      status: status ?? this.status,
      credits: credits ?? this.credits,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, credits, errorMessage];
}
