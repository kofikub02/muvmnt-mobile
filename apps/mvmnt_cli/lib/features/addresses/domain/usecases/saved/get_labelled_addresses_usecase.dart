import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';
import 'package:mvmnt_cli/features/addresses/domain/repository/saved_addresses_repository.dart';

class GetLabelledAddressesUsecase {
  final SavedAddressesRepository repository;

  GetLabelledAddressesUsecase(this.repository);

  Future<DataState<List<AddressEntity>>> call() {
    return repository.getLabelledAddresses();
  }
}
