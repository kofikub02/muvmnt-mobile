import 'package:mvmnt_cli/features/location/domain/entities/geo_latlng_entity.dart';

class GeoLatLngModel extends GeoLatLngEntity {
  const GeoLatLngModel({required super.lat, required super.lng});

  factory GeoLatLngModel.fromJson(Map<String, dynamic> json) {
    return GeoLatLngModel(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng};
  }

  factory GeoLatLngModel.fromEntity(GeoLatLngEntity entity) {
    return GeoLatLngModel(lat: entity.lat, lng: entity.lng);
  }

  GeoLatLngEntity toEntity() {
    return GeoLatLngEntity(lat: lat, lng: lng);
  }
}
