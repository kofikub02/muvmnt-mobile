import 'dart:convert';

import 'package:mvmnt_cli/core/storage/local_storage/user_local_storage.dart';
import 'package:mvmnt_cli/features/addresses/data/models/address_model.dart';

class LocationLocalDataSource {
  static const _key = 'CURRENT_ADDRESS';

  final UserLocalStorage localStorage;

  LocationLocalDataSource({required this.localStorage});

  Future<void> saveCurrentAddress(AddressModel address) async {
    final addressJson = jsonEncode(address.toJson());
    await localStorage.set(_key, addressJson);
  }

  Future<AddressModel?> getCurrentAddress() async {
    final jsonString = localStorage.get(_key);
    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return AddressModel.fromJson(jsonMap);
  }

  Future<void> clearCurrentAddress() async {
    await localStorage.remove(_key);
  }
}
