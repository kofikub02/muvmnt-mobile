import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_prediction_entity.dart';
import 'package:mvmnt_cli/features/location/domain/entities/geo_latlng_entity.dart';

abstract class AddressSearchRepository {
  Future<DataState<List<AddressPredictionEntity>>> searchAddress(
    String query,
    String? country,
  );
  Future<DataState<GeoLatLngEntity>> getGeocodeForAddress(String address);
  Future<DataState<String>> getAddressForGeocode(GeoLatLngEntity latlng);
}
