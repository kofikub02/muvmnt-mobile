// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:features/features.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Features', () {
    test('can be instantiated', () {
      expect(Features(), isNotNull);
    });
  });
}
