import 'package:mvmnt_cli/features/referral/data/models/referral_code_model.dart';
import 'package:mvmnt_cli/features/referral/domain/entities/referral_entity.dart';

class ReferralModel extends ReferralEntity {
  ReferralModel({
    required super.id,
    required ReferralCodeModel code,
    required super.referrerUid,
    required ReferredUserModel referred,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  }) : super(referralCode: code, referredUser: referred);

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    return ReferralModel(
      id: json['_id'],
      code: ReferralCodeModel.fromJson(json['referral_code']),
      referrerUid: json['referrer_uid'],
      referred: ReferredUserModel.fromJson(json['referred']),
      status: json['status'],
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'referral_code': (referralCode as ReferralCodeModel).toJson(),
      'referrer_uid': referrerUid,
      'referred': (referredUser as ReferredUserModel).toJson(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Converts this model to domain entity
  ReferralEntity toEntity() {
    return ReferralEntity(
      id: id,
      referralCode: referralCode,
      referrerUid: referrerUid,
      referredUser: referredUser,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Creates this model from domain entity
  factory ReferralModel.fromEntity(ReferralEntity entity) {
    return ReferralModel(
      id: entity.id,
      code: ReferralCodeModel.fromEntity(entity.referralCode),
      referrerUid: entity.referrerUid,
      referred: ReferredUserModel.fromEntity(entity.referredUser),
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

class ReferredUserModel extends ReferredUserEntity {
  ReferredUserModel({required super.firstName, required super.lastName});

  // Convert model to entity
  ReferredUserEntity toEntity() {
    return ReferredUserModel(firstName: firstName, lastName: lastName);
  }

  // Convert entity to model
  factory ReferredUserModel.fromEntity(ReferredUserEntity entity) {
    return ReferredUserModel(
      firstName: entity.firstName,
      lastName: entity.lastName,
    );
  }

  factory ReferredUserModel.fromJson(Map<String, dynamic> json) {
    return ReferredUserModel(
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'first_name': firstName, 'last_name': lastName};
  }
}
