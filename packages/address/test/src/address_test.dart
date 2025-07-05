// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:address/address.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Address', () {
    test('can be instantiated', () {
      expect(Address(), isNotNull);
    });
  });
}
