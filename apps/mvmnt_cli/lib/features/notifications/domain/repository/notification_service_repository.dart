import 'package:mvmnt_cli/core/resources/data_state.dart';

abstract class NotificationServiceRepository {
  Future<DataState<void>> initialize();
}
