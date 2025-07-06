import 'package:mvmnt_cli/features/referral/domain/entities/referral_code_entity.dart';

class ReferralEntity {
  final String id;
  final ReferralCodeEntity referralCode;
  final String status;
  final ReferredUserEntity referredUser;
  final String referrerUid;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReferralEntity({
    required this.id,
    required this.referralCode,
    required this.status,
    required this.referredUser,
    required this.referrerUid,
    required this.createdAt,
    required this.updatedAt,
  });
}

class ReferredUserEntity {
  final String firstName;
  final String lastName;

  ReferredUserEntity({required this.firstName, required this.lastName});
}
