// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import '../../lib/payment.dart';

void main() {
  group('Payment', () {
    test('can be instantiated', () {
      expect(Payment(), isNotNull);
    });
  });
}
