import 'package:flutter_dotenv/flutter_dotenv.dart';

class SocketConfig {
  static final baseUrl = dotenv.env['API_ENDPOINT'] ?? '';
}
