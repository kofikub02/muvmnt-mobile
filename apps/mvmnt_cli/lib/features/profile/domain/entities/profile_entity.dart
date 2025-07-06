import 'package:equatable/equatable.dart';
import 'package:mvmnt_cli/core/resources/value_objects.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final Email email;
  final PhoneNumber phone;
  final String photoUrl;
  final Rating rating;

  const ProfileEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.photoUrl,
    required this.rating,
  });

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    phone,
    photoUrl,
    rating,
  ];
}
