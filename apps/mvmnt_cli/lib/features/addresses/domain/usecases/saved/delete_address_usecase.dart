import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/addresses/domain/repository/saved_addresses_repository.dart';

class DeleteAddressUseCase {
  final SavedAddressesRepository repository;

  DeleteAddressUseCase(this.repository);

  Future<DataState<void>> call(String addressId, bool isLabeled) {
    return repository.deleteAddress(addressId, isLabeled);
  }
}
