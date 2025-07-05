import 'package:dio/dio.dart';
import 'package:mvmnt_cli/features/location/data/models/geo_latlng_model.dart';
import 'package:mvmnt_cli/features/addresses/data/models/address_prediction_model.dart';

class AddressSearchRemoteDataSource {
  final Dio dio;
  CancelToken? _cancelToken;

  AddressSearchRemoteDataSource({required this.dio});

  Future<GeoLatLngModel> getAddressGeocode(String address) async {
    var encodedAddress = Uri.encodeComponent(address);
    var response = await dio.get(
      '/addresses/search/geocode?address=$encodedAddress',
    );

    if (response.statusCode == 200) {
      if (response.data != null && response.data['data'] != null) {
        return GeoLatLngModel.fromJson(response.data['data']);
      }
    }

    throw response.data['message'];
  }

  Future<String> getGeocodeAddress(GeoLatLngModel latlng) async {
    var response = await dio.get(
      '/addresses/search/convert?lat=${latlng.lat}&lng=${latlng.lng}',
    );

    if (response.statusCode == 200) {
      if (response.data != null && response.data['data'] != null) {
        return response.data['data'];
      }
    }

    throw response.data['message'];
  }

  Future<List<AddressPredictionModel>> searchAddress(
    String query,
    String? country,
  ) async {
    _cancelToken?.cancel("Cancelled due to new request");
    _cancelToken = CancelToken();

    String countryString =
        country != null && country.isNotEmpty ? '&country=$country' : '';

    try {
      var response = await dio.get(
        '/addresses/search/autocomplete?query=$query$countryString',
        cancelToken: _cancelToken,
      );

      if (response.statusCode == 200) {
        if (response.data != null && response.data['data'] != null) {
          return (response.data['data'] as List)
              .map(
                (json) => AddressPredictionModel.fromJson(
                  json as Map<String, dynamic>,
                ),
              )
              .toList();
        }
      }

      throw response.data['message'];
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        print('Request canceled: ${e.message}');
      }
      rethrow;
    }
  }
}
