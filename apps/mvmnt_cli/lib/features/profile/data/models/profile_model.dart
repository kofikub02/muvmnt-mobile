import 'package:mvmnt_cli/core/resources/value_objects.dart';
import 'package:mvmnt_cli/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phone,
    required super.photoUrl,
    required super.rating,
  });

  ProfileModel.empty()
    : super(
        id: '',
        firstName: '',
        lastName: '',
        email: Email.empty(),
        phone: PhoneNumber.empty(),
        photoUrl: '',
        rating: Rating.empty(),
      );

  ProfileModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    Email? email,
    PhoneNumber? phone,
    String? countryCode,
    String? photoUrl,
    Rating? rating,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      rating: rating ?? this.rating,
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: Email.fromJson(json['email'] ?? {}),
      phone: PhoneNumber.fromJson(json['phone'] ?? {}),
      photoUrl: json['photo_url'] as String,
      rating: Rating.fromJson(json['rating']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email.toJson(),
      'phone': phone.toJson(),
      'photoUrl': photoUrl,
      'rating': rating.toJson(),
    };
  }
}
