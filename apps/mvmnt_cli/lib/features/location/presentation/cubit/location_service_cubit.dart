import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mvmnt_cli/core/util/zone_util.dart';
import 'package:mvmnt_cli/features/location/data/datasources/local/location_service.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';
import 'package:mvmnt_cli/features/location/domain/entities/geo_latlng_entity.dart';
import 'package:mvmnt_cli/features/location/domain/location/get_current_address_usecase.dart';
import 'package:mvmnt_cli/features/location/domain/location/set_current_address_usecase.dart';

import 'location_service_state.dart';

class LocationServiceCubit extends Cubit<LocationServiceState> {
  final SetCurrentAddressUseCase setCurrentAddressUseCase;
  final GetCurrentAddressUsecase getCurrentAddressUsecase;

  LocationServiceCubit({
    required this.setCurrentAddressUseCase,
    required this.getCurrentAddressUsecase,
  }) : super(LocationServiceState.initial());

  Future<void> requestLocationServiceState() async {
    emit(state.copyWith(status: LocationServiceStatus.fetching));

    final permissionResult =
        await serviceLocator<LocationService>().checkPermision();

    bool? enabled = false;
    switch (permissionResult) {
      case LocationPermissionStatus.enabled:
        enabled = true;
        break;
      case LocationPermissionStatus.denied:
        enabled = false;
        break;
      case LocationPermissionStatus.unset:
      case LocationPermissionStatus.error:
        enabled = null;
        break;
    }

    emit(
      state.copyWith(
        isLocationEnabled: enabled,
        status: LocationServiceStatus.success,
      ),
    );
  }

  Future onLocationAccessPressed() async {
    await serviceLocator<LocationService>().openLocationSettings();
  }

  Future<void> useCurrentLocationSelected() async {
    try {
      emit(state.copyWith(status: LocationServiceStatus.loading));

      GeoLatLngEntity? geoLatlng =
          await serviceLocator<LocationService>().getCurrentPosition();
      if (geoLatlng == null) {
        await serviceLocator<LocationService>().openLocationSettings();
        return;
      }

      Placemark? placemark = await serviceLocator<LocationService>()
          .getPlaceMarkDetails(geoLatlng);
      if (placemark == null) {
        emit(
          state.copyWith(
            status: LocationServiceStatus.error,
            errorMessage: 'Could not get placemark',
          ),
        );
        return;
      }

      var address = AddressEntity.empty().copyWith(
        description: 'Nearby ${placemark.subLocality}, ${placemark.locality}',
        mainText: placemark.name,
        secondaryText: placemark.locality,
        lat: geoLatlng.lat,
        lng: geoLatlng.lng,
        origin: AddressOriginType.nearby,
      );

      final result = await setCurrentAddressUseCase(address: address);
      if (result is DataFailed) {
        emit(
          state.copyWith(
            status: LocationServiceStatus.error,
            errorMessage:
                result.error?.message ?? 'Failed to set current address',
          ),
        );
        return;
      }

      dynamic currency;
      currency = getCurrency(placemark.isoCountryCode!);

      emit(
        state.copyWith(
          currentLocation: address,
          placemark: placemark,
          status: LocationServiceStatus.success,
          errorMessage: null,
          currency: currency,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LocationServiceStatus.error,
          errorMessage: 'Error occured',
        ),
      );
    }
  }

  Future<void> setCurrentAddress(AddressEntity address) async {
    emit(state.copyWith(status: LocationServiceStatus.fetching));
    final result = await setCurrentAddressUseCase(address: address);

    if (result is DataSuccess) {
      await _basic(address);

      emit(
        state.copyWith(
          currentLocation: address,
          status: LocationServiceStatus.success,
          errorMessage: null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: LocationServiceStatus.error,
          errorMessage:
              result.error?.message ?? 'Failed to set current address',
        ),
      );
    }
  }

  Future<void> getCurrentAddress() async {
    emit(state.copyWith(status: LocationServiceStatus.fetching));

    final result = await getCurrentAddressUsecase();

    if (result is DataSuccess) {
      await _basic(result.data);

      emit(
        state.copyWith(
          currentLocation: result.data,
          status: LocationServiceStatus.success,
          errorMessage: null,
        ),
      );
    } else if (result is DataFailed) {
      emit(
        state.copyWith(
          status: LocationServiceStatus.error,
          errorMessage:
              result.error?.message ?? 'Failed to get current address',
        ),
      );
    }
  }

  Future<void> _basic(AddressEntity? current) async {
    double lat;
    double lng;

    if (current == null) {
      if (state.isLocationEnabled != null && state.isLocationEnabled!) {
        GeoLatLngEntity? geoLatlng =
            await serviceLocator<LocationService>().getCurrentPosition();

        if (geoLatlng == null) {
          return;
        }

        lat = geoLatlng.lat;
        lng = geoLatlng.lng;
      } else {
        return;
      }
    } else {
      lat = current.lat;
      lng = current.lng;
    }

    Placemark? placemark = await serviceLocator<LocationService>()
        .getPlaceMarkDetails(GeoLatLngEntity(lat: lat, lng: lng));

    dynamic currency;
    if (placemark != null) {
      currency = getCurrency(placemark.isoCountryCode!);
    }

    emit(state.copyWith(placemark: placemark, currency: currency));
  }
}
