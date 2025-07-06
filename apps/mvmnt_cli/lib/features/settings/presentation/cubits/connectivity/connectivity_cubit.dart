import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/features/settings/domain/entities/connectivity_entity.dart';
import 'package:mvmnt_cli/features/settings/domain/usecases/check_connectivity_usecase.dart';
import 'package:mvmnt_cli/features/settings/domain/usecases/get_connectivity_status_usecase.dart';
import 'package:mvmnt_cli/features/settings/presentation/cubits/connectivity/connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final GetConnectivityStatusUseCase getConnectivityStatusUseCase;
  final CheckConnectivityUseCase checkConnectivityUseCase;

  StreamSubscription<ConnectivityEntity>? _connectivitySubscription;

  ConnectivityCubit({
    required this.getConnectivityStatusUseCase,
    required this.checkConnectivityUseCase,
  }) : super(ConnectivityState.initial());

  Future start() async {
    final initialConnection = await checkConnectivityUseCase();
    emit(state.copyWith(connection: initialConnection));

    await _connectivitySubscription?.cancel();
    _connectivitySubscription = getConnectivityStatusUseCase().listen(
      (connectionStatus) => emit(state.copyWith(connection: connectionStatus)),
    );
  }

  Future<void> checkConnectivity() async {
    emit(state.copyWith(isLoading: true));
    final connection = await checkConnectivityUseCase();
    emit(state.copyWith(connection: connection, isLoading: false));
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
