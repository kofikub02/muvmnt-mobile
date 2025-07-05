import 'package:mvmnt_cli/features/payments/domain/entities/payment_credits_entity.dart';

class PaymentCreditsModel extends PaymentCreditsEntity {

  factory PaymentCreditsModel.fromEntity(PaymentCreditsEntity entity) {
    return PaymentCreditsModel(credits: entity.credits);
  }
  const PaymentCreditsModel({required super.credits});

  factory PaymentCreditsModel.fromJson(Map<String, dynamic> json) {
    return PaymentCreditsModel(credits: (json['credits'] as num).toDouble());
  }

  Map<String, dynamic> toJson() {
    return {'credits': credits};
  }

  PaymentCreditsEntity toEntity() {
    return PaymentCreditsEntity(credits: credits);
  }
}
