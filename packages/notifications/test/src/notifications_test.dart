// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:notifications/notifications.dart';

void main() {
  group('Notifications', () {
    test('can be instantiated', () {
      expect(Notifications(), isNotNull);
    });
  });
}
