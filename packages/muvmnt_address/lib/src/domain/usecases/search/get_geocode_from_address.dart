import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/location/domain/entities/geo_latlng_entity.dart';
import 'package:mvmnt_cli/features/addresses/domain/repository/address_search_repository.dart';

class GetGeocodeFromAddressUseCase {

  GetGeocodeFromAddressUseCase(this.repository);
  final AddressSearchRepository repository;

  Future<DataState<GeoLatLngEntity>> call({String? address}) {
    return repository.getGeocodeForAddress(address!);
  }
}
