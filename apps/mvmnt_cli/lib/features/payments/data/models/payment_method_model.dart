import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';

class PaymentMethodModel extends PaymentMethodEntity {
  const PaymentMethodModel({
    required super.id,
    required super.name,
    super.meta,
    required super.icon,
    required super.type,
  });

  // 🔁 Convert from entity
  factory PaymentMethodModel.fromEntity(PaymentMethodEntity entity) {
    return PaymentMethodModel(
      id: entity.id,
      name: entity.name,
      meta: entity.meta,
      icon: entity.icon,
      type: PaymentMethodType.values.firstWhere(
        (e) => e.name == entity.type.name,
        orElse: () => PaymentMethodType.card, // fallback
      ),
    );
  }

  // 🔁 Convert to entity
  PaymentMethodEntity toEntity() {
    return PaymentMethodEntity(
      id: id,
      name: name,
      meta: meta,
      icon: icon,
      type: PaymentMethodType.values[type.index],
    );
  }

  // 🔁 JSON serialization
  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'],
      name: json['name'],
      meta: json['meta'],
      icon: json['icon'],
      type: PaymentMethodType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PaymentMethodType.card,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'meta': meta,
      'icon': icon,
      'type': type.name,
    };
  }
}
