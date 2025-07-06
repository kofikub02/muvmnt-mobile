import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mvmnt_cli/features/location/data/models/geo_latlng_model.dart';
import 'package:mvmnt_cli/features/location/domain/entities/geo_latlng_entity.dart';

enum LocationPermissionStatus { enabled, denied, unset, error }

class LocationService {
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  Future<LocationPermissionStatus> checkPermision() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionStatus.error;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    switch (permission) {
      case LocationPermission.whileInUse:
        return LocationPermissionStatus.enabled;
      case LocationPermission.always:
        return LocationPermissionStatus.enabled;
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.denied;
      case LocationPermission.unableToDetermine:
        return LocationPermissionStatus.unset;
    }
  }

  Future<void> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
  }

  Future<GeoLatLngModel?> getCurrentPosition() async {
    LocationPermissionStatus status = await checkPermision();
    if (status == LocationPermissionStatus.denied) {
      Position? position = await Geolocator.getLastKnownPosition();
      if (position == null) {
        return null;
      } else {
        return GeoLatLngModel(lat: position.latitude, lng: position.longitude);
      }
    }

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    // Position? position = await Geolocator.getLastKnownPosition();

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    return GeoLatLngModel(lat: position.latitude, lng: position.longitude);
  }

  Future<Placemark?> getPlaceMarkDetails(GeoLatLngEntity latlng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      latlng.lat,
      latlng.lng,
    );

    return placemarks.first;
  }

  Future<String> translateGeocodeToAddress(GeoLatLngModel geocode) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      geocode.lat,
      geocode.lng,
    );

    return placemarkToGoogleStyleAddress(placemarks.first);
  }

  Future<GeoLatLngModel> translateAddressToGeocode(String address) async {
    List<Location> locations = await locationFromAddress(address);
    return GeoLatLngModel(
      lat: locations.first.latitude,
      lng: locations.first.longitude,
    );
  }

  double getEuclideanDistanceBetween(
    GeoLatLngModel position1,
    GeoLatLngModel position2,
  ) {
    return Geolocator.bearingBetween(
      position1.lat,
      position1.lng,
      position2.lat,
      position2.lng,
    );
  }

  String placemarkToGoogleStyleAddress(Placemark placemark) {
    final street = [
      placemark.subThoroughfare, // street number
      placemark.thoroughfare, // street name
    ].where((e) => e != null && e.trim().isNotEmpty).join(' ');

    final city = placemark.locality ?? placemark.subAdministrativeArea;
    final state = placemark.administrativeArea;
    final country = placemark.country;
    final postalCode = placemark.postalCode;

    final parts = [
      street,
      if (city != null && city.isNotEmpty) city,
      if (state != null && state.isNotEmpty) state,
      if (postalCode != null && postalCode.isNotEmpty) postalCode,
      if (country != null && country.isNotEmpty) country,
    ];

    return parts.join(', ');
  }
}
