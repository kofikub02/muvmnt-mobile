// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:services/services.dart';

void main() {
  group('Services', () {
    test('can be instantiated', () {
      expect(Services(), isNotNull);
    });
  });
}
