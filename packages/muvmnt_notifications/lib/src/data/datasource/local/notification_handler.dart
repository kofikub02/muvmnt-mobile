import 'dart:developer';
import 'package:muvmnt_services/muvmnt_services.dart';

void handleNotificationNavigation(NavigationService router, Map<String, dynamic> data) {
  final type = data['type'];
  final id = data['id'];

  switch (type) {
    case 'payments':
      router.navigateToScreen('/payments');
    case 'orders':
      if (id != null) {
        router.navigateToScreen('/orders/$id');
      } else {
        router.navigateToScreen('/orders');
      }
    case 'profile':
      if (id != null) {
        router.navigateToScreen('/accounts/profile');
      }
    default:
      // Handle unknown notification type
      log('Unknown notification type: $type');
  }
}
