import 'package:hive/hive.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';

part 'address_model.g.dart';

@HiveType(typeId: 0)
enum AddressOriginTypeHive {
  @HiveField(0)
  nearby,
  @HiveField(1)
  searched,
  @HiveField(2)
  labelled,
}

@HiveType(typeId: 1)
class AddressModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String icon;
  @HiveField(2)
  String? label;
  @HiveField(3)
  String? buildingName;
  @HiveField(4)
  String? apartmentSuite;
  @HiveField(5)
  String? entryCode;
  @HiveField(6)
  String? instructions;
  @HiveField(7)
  String description;
  @HiveField(8)
  String mainText;
  @HiveField(9)
  String secondaryText;
  @HiveField(10)
  double lat;
  @HiveField(11)
  double lng;
  @HiveField(12)
  AddressOriginTypeHive origin;
  @HiveField(13)
  DateTime updatedAt;
  @HiveField(14)
  DateTime createdAt;

  AddressModel({
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

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      icon: entity.icon,
      label: entity.label,
      buildingName: entity.buildingName,
      apartmentSuite: entity.apartmentSuite,
      entryCode: entity.entryCode,
      instructions: entity.instructions,
      description: entity.description,
      mainText: entity.mainText,
      secondaryText: entity.secondaryText,
      lat: entity.lat,
      lng: entity.lng,
      origin: AddressOriginTypeHive.values.firstWhere(
        (e) => e.name == entity.origin.name,
        orElse: () => AddressOriginTypeHive.searched, // fallback
      ),
      updatedAt: entity.updatedAt,
      createdAt: entity.createdAt,
    );
  }

  AddressEntity toEntity() {
    return AddressEntity(
      id: id,
      icon: icon,
      label: label,
      buildingName: buildingName,
      apartmentSuite: apartmentSuite,
      entryCode: entryCode,
      instructions: instructions,
      description: description,
      mainText: mainText,
      secondaryText: secondaryText,
      lat: lat,
      lng: lng,
      origin: AddressOriginType.values[origin.index],
      updatedAt: updatedAt,
      createdAt: createdAt,
    );
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id'] ?? json['id'],
      icon: json['icon'],
      buildingName: json['buildingName'],
      apartmentSuite: json['apartmentSuite'],
      entryCode: json['entryCode'],
      instructions: json['instructions'],
      label: json['label'],
      description: json['description'],
      mainText: json['mainText'],
      secondaryText: json['secondaryText'],
      lat: json['lat'],
      lng: json['lng'],
      origin: AddressOriginTypeHive.values.firstWhere(
        (e) => e.name == json['origin'],
        orElse: () => AddressOriginTypeHive.labelled,
      ),
      updatedAt: DateTime.parse(json['updatedAt']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon,
      'buildingName': buildingName ?? '',
      'apartmentSuite': apartmentSuite ?? '',
      'entryCode': entryCode ?? '',
      'instructions': instructions ?? '',
      'label': label ?? '',
      'description': description,
      'mainText': mainText,
      'secondaryText': secondaryText,
      'lat': lat,
      'lng': lng,
      'origin': origin.name,
      'updatedAt': updatedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
