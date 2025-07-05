import 'package:equatable/equatable.dart';

class PaymentCreditsEntity extends Equatable {

  const PaymentCreditsEntity({required this.credits});
  final double credits;

  @override
  List<Object?> get props => [credits];
}
