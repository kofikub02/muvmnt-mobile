import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';
import 'package:mvmnt_cli/features/location/domain/entities/currency_entity.dart';
import 'package:mvmnt_cli/features/location/domain/entities/geo_latlng_entity.dart';

enum LocationServiceStatus { initial, fetching, loading, success, error }

class LocationServiceState extends Equatable {
  final LocationServiceStatus status;
  final String? errorMessage;
  final bool? isLocationEnabled;
  final AddressEntity? currentLocation;
  final Placemark? placemark;
  final CurrencyEntity? currency;

  const LocationServiceState._({
    required this.status,
    this.errorMessage,
    this.isLocationEnabled,
    this.currentLocation,
    this.placemark,
    this.currency,
  });

  factory LocationServiceState.initial() =>
      LocationServiceState._(status: LocationServiceStatus.initial);

  LocationServiceState copyWith({
    LocationServiceStatus? status,
    String? errorMessage,
    bool? isLocationEnabled,
    AddressEntity? currentLocation,
    final GeoLatLngEntity? geoLatlng,
    final Placemark? placemark,
    final CurrencyEntity? currency,
  }) => LocationServiceState._(
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
    currentLocation: currentLocation ?? this.currentLocation,
    placemark: placemark ?? this.placemark,
    currency: currency ?? this.currency,
  );

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    isLocationEnabled,
    currentLocation,
    placemark,
    currency,
  ];
}
