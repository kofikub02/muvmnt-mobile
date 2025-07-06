import 'package:hive_flutter/hive_flutter.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/features/addresses/data/datasources/local/addresses_local_data_source.dart';
import 'package:mvmnt_cli/features/addresses/data/models/address_model.dart';

class HiveInit {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    Hive.registerAdapter(AddressOriginTypeHiveAdapter());
    Hive.registerAdapter(AddressModelAdapter());
  }

  static Future<void> setUser(String uid) async {
    await serviceLocator<AddressLocalDataSource>().init(uid);
  }
}
