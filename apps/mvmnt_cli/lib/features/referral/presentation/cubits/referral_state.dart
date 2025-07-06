import 'package:equatable/equatable.dart';
import 'package:mvmnt_cli/features/referral/domain/entities/referral_code_entity.dart';
import 'package:mvmnt_cli/features/referral/domain/entities/referral_entity.dart';

enum ReferralStatus { initial, loading, success, error }

class ReferralState extends Equatable {
  final ReferralStatus status;
  final ReferralCodeEntity? referralCode;
  final List<ReferralEntity> issuedReferrals;
  final String? errorMessage;

  const ReferralState._({
    required this.status,
    required this.issuedReferrals,
    this.referralCode,
    this.errorMessage,
  });

  factory ReferralState.initial() =>
      ReferralState._(status: ReferralStatus.initial, issuedReferrals: []);

  ReferralState copyWith({
    ReferralStatus? status,
    String? errorMessage,
    ReferralCodeEntity? referralCode,
    List<ReferralEntity>? issuedReferrals,
  }) => ReferralState._(
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    referralCode: referralCode ?? this.referralCode,
    issuedReferrals: issuedReferrals ?? this.issuedReferrals,
  );

  @override
  List<Object?> get props => [
    status,
    referralCode,
    issuedReferrals,
    referralCode,
    errorMessage,
  ];
}
