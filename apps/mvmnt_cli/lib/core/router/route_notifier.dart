import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:mvmnt_cli/services/services/stripe.dart';
import 'package:mvmnt_cli/core/api/api_client.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/core/storage/hive/hive_init.dart';
import 'package:mvmnt_cli/core/storage/local_storage/user_local_storage.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/authentication/authentication_cubit.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/authentication/authentication_state.dart';

class RouteNotifier extends ChangeNotifier {
  final AuthenticationCubit _authenticationCubit;
  late final StreamSubscription<AuthenticationState> _authSubscription;

  RouteNotifier(this._authenticationCubit) {
    _authSubscription = _authenticationCubit.stream.listen((state) async {
      // Optional: Add logging for debugging
      if (kDebugMode) {
        print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
        print('Auth state changed: ${state.status}');
        print('###################################');
      }
      // await Future.delayed(const Duration(seconds: 2));
      if (state.status == AuthenticationStatus.authenticated) {
        serviceLocator<FirebaseCrashlytics>().setUserIdentifier(
          state.authEntity!.id!,
        );
        serviceLocator<UserLocalStorage>().create();
        await HiveInit.setUser(state.authEntity!.id!);
        await serviceLocator<StripeService>().initialize();
      } else if (state.status == AuthenticationStatus.unauthenticated) {
        serviceLocator<FirebaseCrashlytics>().setUserIdentifier('');
        serviceLocator<ApiClient>().clearAuthToken();
        await serviceLocator<UserLocalStorage>().clearUserData();
      }

      notifyListeners();
    });
  }

  AuthenticationState get authStatus => _authenticationCubit.state;

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
