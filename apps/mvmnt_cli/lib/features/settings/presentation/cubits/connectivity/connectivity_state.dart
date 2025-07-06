import 'package:mvmnt_cli/features/settings/domain/entities/connectivity_entity.dart';

class ConnectivityState {
  final ConnectivityEntity connection;
  final bool isLoading;

  const ConnectivityState({required this.connection, this.isLoading = false});

  factory ConnectivityState.initial() {
    return const ConnectivityState(
      connection: ConnectivityEntity(status: ConnectivityStatus.unknown),
      isLoading: false,
    );
  }

  ConnectivityState copyWith({
    ConnectivityEntity? connection,
    bool? isLoading,
  }) {
    return ConnectivityState(
      connection: connection ?? this.connection,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
