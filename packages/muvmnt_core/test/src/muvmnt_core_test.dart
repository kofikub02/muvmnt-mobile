// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:muvmnt_core/muvmnt_core.dart';

void main() {
  group('MuvmntCore', () {
    test('can be instantiated', () {
      expect(MuvmntCore(), isNotNull);
    });
  });
}
