import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/addresses/domain/repository/saved_addresses_repository.dart';

class DeleteAddressUseCase {

  DeleteAddressUseCase(this.repository);
  final SavedAddressesRepository repository;

  Future<DataState<void>> call(String addressId, bool isLabeled) {
    return repository.deleteAddress(addressId, isLabeled);
  }
}
