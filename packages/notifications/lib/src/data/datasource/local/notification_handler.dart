import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/services/navigation/navigation_service.dart';

void handleNotificationNavigation(Map<String, dynamic> data) {
  final router = serviceLocator<NavigationService>();
  final type = data['type'];
  final id = data['id'];

  print(type);

  switch (type) {
    case 'payments':
      router.navigateToScreen('/payments');
      break;
    case 'orders':
      if (id != null) {
        router.navigateToScreen('/orders/$id');
      }
      break;
    case 'profile':
      if (id != null) {
        router.navigateToScreen('/accounts/profile');
      }
      break;
    default:
      // Handle unknown notification type
      print('Unknown notification type: $type');
  }
}
