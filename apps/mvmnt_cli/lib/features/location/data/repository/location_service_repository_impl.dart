import 'package:dio/dio.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/location/data/datasources/local/location_service.dart';
import 'package:mvmnt_cli/features/location/data/datasources/local/location_local_data_source.dart';
import 'package:mvmnt_cli/features/addresses/data/models/address_model.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';
import 'package:mvmnt_cli/features/location/domain/repository/location_service_repository.dart';

class LocationServiceRepositoryImpl extends LocationServiceRepository {
  final LocationService locationService;
  final LocationLocalDataSource locationLocalDataSource;

  LocationServiceRepositoryImpl({
    required this.locationService,
    required this.locationLocalDataSource,
  });

  @override
  Future<DataState<AddressEntity?>> getCurrentAddress() async {
    try {
      var currentAddressModel =
          await locationLocalDataSource.getCurrentAddress();
      if (currentAddressModel != null) {
        return DataSuccess(currentAddressModel.toEntity());
      } else {
        return DataSuccess(null);
      }
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<void>> setCurrentaddress(AddressEntity address) async {
    try {
      return DataSuccess(
        await locationLocalDataSource.saveCurrentAddress(
          AddressModel.fromEntity(address),
        ),
      );
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e.toString(),
        ),
      );
    }
  }
}
