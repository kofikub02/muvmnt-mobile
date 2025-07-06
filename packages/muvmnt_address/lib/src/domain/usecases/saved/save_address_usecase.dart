import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';
import 'package:mvmnt_cli/features/addresses/domain/repository/saved_addresses_repository.dart';

class SaveAddressUsecase {

  SaveAddressUsecase(this.repository);
  final SavedAddressesRepository repository;

  Future<DataState<void>> call(AddressEntity address) {
    return repository.saveAddress(address);
  }
}
