import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_prediction_entity.dart';
import 'package:mvmnt_cli/features/addresses/domain/repository/address_search_repository.dart';

class SearchAddressUseCase {

  SearchAddressUseCase(this.repository);
  final AddressSearchRepository repository;

  Future<DataState<List<AddressPredictionEntity>>> call(
    String query,
    String? country,
  ) {
    return repository.searchAddress(query, country);
  }
}
