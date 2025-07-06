import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/current/current_payment_cubit.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/paypal/paypal_cubit.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/stripe/stripe_cubit.dart';
import 'package:mvmnt_cli/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/features/addresses/presentation/cubits/saved/saved_addresses_cubit.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/methods/payment_methods_cubit.dart';
import 'package:mvmnt_cli/features/support/presentation/cubits/session/support_session_cubit.dart';
import 'package:mvmnt_cli/l10n/app_localizations.dart';
import 'package:mvmnt_cli/core/theme/app_theme.dart';
import 'package:mvmnt_cli/features/settings/presentation/cubits/theme/theme_cubit.dart';
import 'package:mvmnt_cli/features/settings/presentation/cubits/theme/theme_state.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/authentication/authentication_cubit.dart';
import 'package:mvmnt_cli/features/addresses/presentation/cubits/address_search/address_search_cubit.dart';
import 'package:mvmnt_cli/features/location/presentation/cubit/location_service_cubit.dart';
import 'package:mvmnt_cli/features/settings/presentation/cubits/connectivity/connectivity_cubit.dart';
import 'package:mvmnt_cli/features/notifications/presentation/cubits/notifications_service/notification_service_cubit.dart';
import 'package:mvmnt_cli/features/profile/presentation/cubits/profile_cubit.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initialization());
  }

  void initialization() async {
    await Future.delayed(const Duration(milliseconds: 100));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationCubit>(
          create: (_) => serviceLocator<AuthenticationCubit>(),
        ),
        BlocProvider<ThemeCubit>(create: (_) => serviceLocator<ThemeCubit>()),
        BlocProvider<ConnectivityCubit>(
          create: (_) => serviceLocator<ConnectivityCubit>(),
        ),
        BlocProvider<NotificationServiceCubit>(
          create: (_) => serviceLocator<NotificationServiceCubit>(),
        ),
        BlocProvider<LocationServiceCubit>(
          create: (_) => serviceLocator<LocationServiceCubit>(),
        ),
        BlocProvider<AddressSearchCubit>(
          create: (_) => serviceLocator<AddressSearchCubit>(),
        ),
        BlocProvider<SavedAddressesCubit>(
          create: (_) => serviceLocator<SavedAddressesCubit>(),
        ),
        BlocProvider<ProfileCubit>(
          create: (_) => serviceLocator<ProfileCubit>(),
        ),
        BlocProvider<CurrentPaymentCubit>(
          create: (_) => serviceLocator<CurrentPaymentCubit>(),
        ),
        BlocProvider<PaymentMethodsCubit>(
          create: (_) => serviceLocator<PaymentMethodsCubit>(),
        ),
        BlocProvider<StripeCubit>(create: (_) => serviceLocator<StripeCubit>()),
        BlocProvider<PaypalCubit>(create: (_) => serviceLocator<PaypalCubit>()),
        BlocProvider<SupportSessionCubit>(
          create: (_) => serviceLocator<SupportSessionCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            routerConfig: serviceLocator<GoRouter>(),
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getTheme(context, state.themeEntity?.themeType),
            supportedLocales: L10n.all,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            locale: const Locale('en'),
            title: "Muvmnt",
          );
        },
      ),
    );
  }
}
