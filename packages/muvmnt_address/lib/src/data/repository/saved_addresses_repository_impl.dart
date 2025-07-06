import 'package:dio/dio.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/addresses/data/datasources/local/addresses_local_data_source.dart';
import 'package:mvmnt_cli/features/addresses/data/datasources/remote/saved_addresses_remote_data_source.dart';
import 'package:mvmnt_cli/features/addresses/data/models/address_model.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';
import 'package:mvmnt_cli/features/addresses/domain/repository/saved_addresses_repository.dart';

class SavedAddressesRepositoryImpl implements SavedAddressesRepository {

  SavedAddressesRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });
  final AddressLocalDataSource localDataSource;
  final SavedAddressesRemoteDataSource remoteDataSource;

  @override
  Future<DataState<void>> addToAddressHistory(AddressEntity address) async {
    try {
      final model = AddressModel.fromEntity(
        address.copyWith(updatedAt: DateTime.now()),
      );
      return DataSuccess(await localDataSource.saveAddress(model));
    } catch (error) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(),
          error: error.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<void>> deleteAddress(
    String addressId,
    bool isLabeled,
  ) async {
    try {
      await localDataSource.deleteAddress(addressId);
      if (isLabeled) {
        await remoteDataSource.deleteAddress(addressId);
      }

      return DataSuccess(null);
    } catch (error) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(),
          error: error.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<AddressEntity?>> updateAddress(AddressEntity address) async {
    try {
      final model = AddressModel.fromEntity(address);

      var toReturn = await localDataSource.updateAddress(model);

      if (model.label != null && model.label!.isNotEmpty) {
        if (address.origin == AddressOriginType.searched) {
          toReturn = await remoteDataSource.saveAddress(model);
        } else {
          toReturn = await remoteDataSource.updateAddress(model);
        }
      }

      if (toReturn == null) {
        return DataSuccess(null);
      } else {
        return DataSuccess(toReturn.toEntity());
      }
    } catch (error) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(),
          error: error.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<List<AddressEntity>>> getSelectedAddressHistory() async {
    try {
      final models = await localDataSource.getAddresses();
      return DataSuccess(models.map((m) => m.toEntity()).toList());
    } catch (error) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(),
          error: error.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<List<AddressEntity>>> getLabelledAddresses() async {
    try {
      final models = await remoteDataSource.getLabelledAddresses();
      return DataSuccess(models.map((m) => m.toEntity()).toList());
    } catch (error) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(),
          error: error.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<AddressEntity?>> saveAddress(AddressEntity address) async {
    try {
      final newAddress = await remoteDataSource.saveAddress(
        AddressModel.fromEntity(address),
      );

      return DataSuccess(newAddress?.toEntity());
    } catch (error) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(),
          error: error.toString(),
        ),
      );
    }
  }
}
