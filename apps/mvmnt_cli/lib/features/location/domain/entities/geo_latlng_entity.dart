import 'package:equatable/equatable.dart';

class GeoLatLngEntity extends Equatable {
  final double lat;
  final double lng;

  const GeoLatLngEntity({required this.lat, required this.lng});

  @override
  List<Object?> get props => [lat, lng];
}
