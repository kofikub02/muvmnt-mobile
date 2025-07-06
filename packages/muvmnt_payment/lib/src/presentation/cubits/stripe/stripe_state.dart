import 'package:equatable/equatable.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';

enum StripeStatus { initial, loading, success, failure }

class StripeState extends Equatable {

  const StripeState({
    this.status = StripeStatus.initial,
    this.errorMessage,
    this.cards = const [],
  });
  final StripeStatus status;
  final String? errorMessage;
  final List<PaymentMethodEntity> cards;

  StripeState copyWith({
    StripeStatus? status,
    String? errorMessage,
    List<PaymentMethodEntity>? cards,
  }) {
    return StripeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      cards: cards ?? this.cards,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, cards];
}
