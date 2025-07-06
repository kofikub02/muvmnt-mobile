import 'package:equatable/equatable.dart';

enum AddressOriginType { nearby, searched, labelled, unknown }

//Check addresses
//Icon to home

class AddressEntity extends Equatable {

  const AddressEntity({
    required this.id,
    required this.icon,
    this.label,
    this.buildingName,
    this.apartmentSuite,
    this.entryCode,
    this.instructions,
    required this.description,
    required this.mainText,
    required this.secondaryText,
    required this.lat,
    required this.lng,
    required this.origin,
    required this.updatedAt,
    required this.createdAt,
  });
  final String id;
  final String icon;
  final String? label;
  final String? buildingName;
  final String? apartmentSuite;
  final String? entryCode;
  final String? instructions;
  final String description;
  final String mainText;
  final String secondaryText;
  final double lat;
  final double lng;
  final AddressOriginType origin;
  final DateTime updatedAt;
  final DateTime createdAt;

  AddressEntity copyWith({
    String? id,
    String? icon,
    String? label,
    String? buildingName,
    String? apartmentSuite,
    String? entryCode,
    String? instructions,
    String? description,
    String? mainText,
    String? secondaryText,
    double? lat,
    double? lng,
    AddressOriginType? origin,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      label: label ?? this.label,
      buildingName: buildingName ?? this.buildingName,
      apartmentSuite: apartmentSuite ?? this.apartmentSuite,
      entryCode: entryCode ?? this.entryCode,
      instructions: instructions ?? this.instructions,
      description: description ?? this.description,
      mainText: mainText ?? this.mainText,
      secondaryText: secondaryText ?? this.secondaryText,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      origin: origin ?? this.origin,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static AddressEntity empty() {
    return AddressEntity(
      id: '',
      icon: '',
      description: '',
      mainText: '',
      secondaryText: '',
      lat: 0,
      lng: 0,
      origin: AddressOriginType.unknown,
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    icon,
    label,
    buildingName,
    apartmentSuite,
    entryCode,
    instructions,
    description,
    mainText,
    secondaryText,
    lat,
    lng,
    origin,
    updatedAt,
    createdAt,
  ];
}
