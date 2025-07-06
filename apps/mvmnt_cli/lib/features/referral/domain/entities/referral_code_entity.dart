import 'package:equatable/equatable.dart';

class ReferralCodeEntity extends Equatable {
  final String code;
  final int points;

  const ReferralCodeEntity({required this.code, required this.points});

  @override
  List<Object?> get props => [code, points];
}
