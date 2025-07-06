import 'package:mvmnt_cli/features/support/domain/entities/support_session_entity.dart';

class SupportSessionModel extends SupportSessionEntity {
  const SupportSessionModel({
    required super.id,
    required super.locale,
    required super.status,
    super.rating,
    required super.createdAt,
  });

  factory SupportSessionModel.fromJson(Map<String, dynamic> json) {
    return SupportSessionModel(
      id: json['_id'],
      locale: json['locale'],
      status: SupportSessionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => SupportSessionStatus.open,
      ),
      rating: json['rating'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'locale': locale,
      'status': status.toString().split('.').last,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory SupportSessionModel.fromEntity(SupportSessionEntity entity) {
    return SupportSessionModel(
      id: entity.id,
      locale: entity.locale,
      status: entity.status,
      rating: entity.rating,
      createdAt: entity.createdAt,
    );
  }

  SupportSessionEntity toEntity() {
    return SupportSessionEntity(
      id: id,
      locale: locale,
      status: status,
      rating: rating,
      createdAt: createdAt,
    );
  }
}
