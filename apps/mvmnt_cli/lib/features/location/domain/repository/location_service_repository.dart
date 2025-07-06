import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';

abstract class LocationServiceRepository {
  Future<DataState<AddressEntity?>> getCurrentAddress();
  Future<DataState<void>> setCurrentaddress(AddressEntity address);
}
