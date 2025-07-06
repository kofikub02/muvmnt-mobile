import 'package:equatable/equatable.dart';

enum PaymentMethodType {
  card,
  applepay,
  googlepay,
  momo,
  paypal,
  cash,
  unknown,
}

class PaymentMethodEntity extends Equatable {

  const PaymentMethodEntity({
    required this.id,
    required this.name,
    this.meta,
    required this.icon,
    required this.type,
  });
  final String id;
  final String name;
  final String? meta;
  final String icon;
  final PaymentMethodType type;

  @override
  List<Object?> get props => [id, name, meta, icon, type];
}
