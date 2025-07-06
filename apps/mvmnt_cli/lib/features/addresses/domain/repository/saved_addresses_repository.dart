import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';

abstract class SavedAddressesRepository {
  Future<DataState<void>> addToAddressHistory(AddressEntity address);
  Future<DataState<AddressEntity?>> saveAddress(AddressEntity address);
  Future<DataState<AddressEntity?>> updateAddress(AddressEntity address);
  Future<DataState<void>> deleteAddress(String addressId, bool isLabeled);
  Future<DataState<List<AddressEntity>>> getSelectedAddressHistory();
  Future<DataState<List<AddressEntity>>> getLabelledAddresses();
}
