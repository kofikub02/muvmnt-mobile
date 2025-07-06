import 'package:equatable/equatable.dart';

enum ConnectivityStatus { connected, disconnected, unknown }

class ConnectivityEntity extends Equatable {
  final ConnectivityStatus status;

  const ConnectivityEntity({required this.status});

  @override
  List<Object?> get props => [status];
}
