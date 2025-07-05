import 'package:dio/dio.dart';
import 'package:mvmnt_cli/features/addresses/data/models/address_model.dart';

class SavedAddressesRemoteDataSource {
  final Dio dio;

  SavedAddressesRemoteDataSource({required this.dio});

  Future<List<AddressModel>> getLabelledAddresses() async {
    final response = await dio.get('/addresses/saved');

    if (response.statusCode == 200) {
      if (response.data != null && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((json) => AddressModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    }

    throw response.data['message'];
  }

  Future<AddressModel?> saveAddress(AddressModel address) async {
    final json = address.toJson();
    json.removeWhere(
      (key, _) => ['id', 'origin', 'updatedAt', 'createdAt'].contains(key),
    );

    final response = await dio.post('/addresses/saved', data: json);

    if (response.statusCode == 201 || response.statusCode == 200) {
      if (response.data != null && response.data['data'] != null) {
        return AddressModel.fromJson(response.data['data']);
      }
    }

    throw response.data['message'];
  }

  Future<AddressModel?> updateAddress(AddressModel address) async {
    final json = address.toJson();
    json.removeWhere(
      (key, _) => [
        'id',
        'origin',
        'updatedAt',
        'createdAt',
        'description',
        'mainText',
        'secondaryText',
      ].contains(key),
    );

    final response = await dio.put(
      '/addresses/saved/${address.id}',
      data: json,
    );

    if (response.statusCode == 200) {
      if (response.data != null && response.data['data'] != null) {
        return AddressModel.fromJson(response.data['data']);
      }
    }

    throw response.data['message'];
  }

  Future<void> deleteAddress(String addressId) async {
    final response = await dio.delete('/addresses/saved/$addressId');

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    }

    throw response.data['message'];
  }
}
