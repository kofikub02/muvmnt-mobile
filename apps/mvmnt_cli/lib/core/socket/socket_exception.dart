class SocketException implements Exception {
  final String message;
  final dynamic error;

  SocketException(this.message, [this.error]);

  @override
  String toString() =>
      'SocketException: $message${error != null ? ' ($error)' : ''}';
}
