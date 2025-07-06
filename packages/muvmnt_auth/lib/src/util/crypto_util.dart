import 'dart:convert' show utf8;
// import 'dart:math' show Random;
import 'package:crypto/crypto.dart' show sha256;
import 'package:uuid/uuid.dart';

final uuid = Uuid();

// String generateNonce() {
//   const length = 32;
//   const charset =
//       '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
//   final random = Random.secure();
//   return List.generate(
//     length,
//     (_) => charset[random.nextInt(charset.length)],
//   ).join();
// }

String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

String getUniqueId() {
  return uuid.v4();
}
