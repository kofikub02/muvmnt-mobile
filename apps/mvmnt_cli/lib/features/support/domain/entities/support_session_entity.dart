import 'package:equatable/equatable.dart';

enum SupportSessionStatus { open, resolved, escalated }

class SupportSessionEntity extends Equatable {
  final String id;
  final String locale; // fr, en
  final SupportSessionStatus status; // open, resolved, escalated
  final double? rating;
  final DateTime createdAt;

  const SupportSessionEntity({
    required this.id,
    required this.locale,
    required this.status,
    this.rating,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, locale, status, rating, createdAt];
}
