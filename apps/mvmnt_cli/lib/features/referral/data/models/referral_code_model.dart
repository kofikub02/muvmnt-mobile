import 'package:mvmnt_cli/features/referral/domain/entities/referral_code_entity.dart';

class ReferralCodeModel extends ReferralCodeEntity {
  const ReferralCodeModel({required super.code, required super.points});

  factory ReferralCodeModel.fromEntity(ReferralCodeEntity entity) {
    return ReferralCodeModel(code: entity.code, points: entity.points);
  }

  ReferralCodeEntity toEntity() {
    return ReferralCodeEntity(code: code, points: points);
  }

  factory ReferralCodeModel.fromJson(Map<String, dynamic> json) {
    return ReferralCodeModel(
      code: json['code'] as String,
      points: json['points'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'points': points};
  }
}
