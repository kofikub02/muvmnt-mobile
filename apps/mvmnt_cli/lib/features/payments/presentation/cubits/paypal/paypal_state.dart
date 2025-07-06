import 'package:equatable/equatable.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';

enum PaypalStatus { initial, loading, settingUp, success, failure }

class PaypalState extends Equatable {
  final PaypalStatus status;
  final String? errorMessage;
  final String? setupTokenId;
  final String? approvalUrl;
  final List<PaymentMethodEntity> methods;

  const PaypalState({
    this.status = PaypalStatus.initial,
    this.errorMessage,
    this.setupTokenId,
    this.approvalUrl,
    this.methods = const [],
  });

  PaypalState copyWith({
    PaypalStatus? status,
    String? errorMessage,
    String? setupTokenId,
    String? approvalUrl,
    List<PaymentMethodEntity>? methods,
  }) {
    return PaypalState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      setupTokenId: setupTokenId ?? this.setupTokenId,
      approvalUrl: approvalUrl ?? this.approvalUrl,
      methods: methods ?? this.methods,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    setupTokenId,
    approvalUrl,
    methods,
  ];
}
