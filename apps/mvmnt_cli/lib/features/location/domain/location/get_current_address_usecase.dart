import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';
import 'package:mvmnt_cli/features/location/domain/repository/location_service_repository.dart';

class GetCurrentAddressUsecase {
  final LocationServiceRepository repository;

  GetCurrentAddressUsecase(this.repository);

  Future<DataState<AddressEntity?>> call({params}) {
    return repository.getCurrentAddress();
  }
}
