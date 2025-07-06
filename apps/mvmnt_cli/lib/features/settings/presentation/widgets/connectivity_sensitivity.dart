import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/features/settings/domain/entities/connectivity_entity.dart';
import 'package:mvmnt_cli/features/settings/presentation/cubits/connectivity/connectivity_cubit.dart';
import 'package:mvmnt_cli/features/settings/presentation/cubits/connectivity/connectivity_state.dart';

class ConnectivitySensitiveWidget extends StatelessWidget {
  final Widget connectedChild;
  final Widget disconnectedChild;

  const ConnectivitySensitiveWidget({
    super.key,
    required this.connectedChild,
    required this.disconnectedChild,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context, state) {
        if (state.connection.status == ConnectivityStatus.connected) {
          return connectedChild;
        } else if (state.connection.status == ConnectivityStatus.disconnected) {
          return disconnectedChild;
        } else {
          // For unknown state, I might want to show a loading indicator
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
