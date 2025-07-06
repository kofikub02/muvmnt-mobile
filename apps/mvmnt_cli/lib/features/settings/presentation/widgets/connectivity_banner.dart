import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/features/settings/domain/entities/connectivity_entity.dart';
import 'package:mvmnt_cli/features/settings/presentation/cubits/connectivity/connectivity_cubit.dart';
import 'package:mvmnt_cli/features/settings/presentation/cubits/connectivity/connectivity_state.dart';

class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context, state) {
        if (state.connection.status == ConnectivityStatus.disconnected) {
          return Container(
            color: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: const Text(
              'No Internet Connection',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
