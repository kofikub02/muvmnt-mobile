import 'package:equatable/equatable.dart';

class PaymentCreditsEntity extends Equatable {
  final double credits;

  const PaymentCreditsEntity({required this.credits});

  @override
  List<Object?> get props => [credits];
}
