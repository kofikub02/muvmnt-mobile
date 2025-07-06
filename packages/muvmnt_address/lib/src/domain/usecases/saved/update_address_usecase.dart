import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';
import 'package:mvmnt_cli/features/addresses/domain/repository/saved_addresses_repository.dart';

class UpdateAddressUseCase {

  UpdateAddressUseCase(this.repository);
  final SavedAddressesRepository repository;

  Future<DataState<AddressEntity?>> call(AddressEntity place) {
    return repository.updateAddress(place);
  }
}
