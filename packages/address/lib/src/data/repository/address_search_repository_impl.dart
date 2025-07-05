import 'package:dio/dio.dart';
import 'package:mvmnt_cli/features/location/data/datasources/local/location_service.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/addresses/data/datasources/remote/address_search_remote_data_source.dart';
import 'package:mvmnt_cli/features/location/data/models/geo_latlng_model.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_prediction_entity.dart';
import 'package:mvmnt_cli/features/location/domain/entities/geo_latlng_entity.dart';
import 'package:mvmnt_cli/features/addresses/domain/repository/address_search_repository.dart';

class AddressSearchRepositoryImpl extends AddressSearchRepository {

  AddressSearchRepositoryImpl({
    required this.addressRemoteDataSource,
    required this.geoLocationDataSource,
  });
  final AddressSearchRemoteDataSource addressRemoteDataSource;
  final LocationService geoLocationDataSource;

  @override
  Future<DataState<GeoLatLngEntity>> getGeocodeForAddress(
    String address,
  ) async {
    try {
      return DataSuccess(
        await addressRemoteDataSource.getAddressGeocode(address),
      );
    } on DioException catch (error) {
      return DataFailed(error);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(),
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<String>> getAddressForGeocode(GeoLatLngEntity latlng) async {
    try {
      return DataSuccess(
        await addressRemoteDataSource.getGeocodeAddress(
          GeoLatLngModel.fromEntity(latlng),
        ),
      );
    } on DioException catch (error) {
      return DataFailed(error);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(),
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<List<AddressPredictionEntity>>> searchAddress(
    String query,
    String? country,
  ) async {
    try {
      return DataSuccess(
        await addressRemoteDataSource.searchAddress(query, country),
      );
    } on DioException catch (error) {
      return DataFailed(error);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(),
          error: e.toString(),
        ),
      );
    }
  }
}
