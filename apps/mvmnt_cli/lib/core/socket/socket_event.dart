class SocketEvent {
  final String name;
  final dynamic data;
  final DateTime timestamp;

  SocketEvent({required this.name, required this.data, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() => 'SocketEvent($name, $data)';
}
