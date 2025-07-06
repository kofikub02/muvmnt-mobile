import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';
import 'package:mvmnt_cli/features/location/domain/repository/location_service_repository.dart';

class SetCurrentAddressUseCase {
  final LocationServiceRepository repository;

  SetCurrentAddressUseCase(this.repository);

  Future<DataState<void>> call({AddressEntity? address}) {
    return repository.setCurrentaddress(address!);
  }
}
