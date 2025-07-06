import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/services/config/remote_config.dart';
import 'package:mvmnt_cli/services/services/stripe.dart';
import 'package:mvmnt_cli/services/analytics/analytics_service.dart';
import 'package:mvmnt_cli/services/analytics/firebase_analytics_service.dart';
import 'package:mvmnt_cli/core/api/api_client.dart';
import 'package:mvmnt_cli/services/error/crash_reporting_service.dart';
import 'package:mvmnt_cli/services/error/firebase_crashlytics_service.dart';
import 'package:mvmnt_cli/core/router/app_router.dart';
import 'package:mvmnt_cli/core/router/route_notifier.dart';
import 'package:mvmnt_cli/core/socket/socket_client.dart';
import 'package:mvmnt_cli/core/storage/local_storage/user_local_storage.dart';
import 'package:mvmnt_cli/features/addresses/data/datasources/remote/saved_addresses_remote_data_source.dart';
import 'package:mvmnt_cli/features/addresses/domain/usecases/saved/get_labelled_addresses_usecase.dart';
import 'package:mvmnt_cli/features/addresses/domain/usecases/saved/save_address_usecase.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/email/confirm_email_verification_usecase.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/email/reset_email_password_usecase.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/email/send_email_verification_usecase.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/email/signin_with_email_and_password_usecase.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/email/signup_with_email_and_password_usecase.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/email_auth/email_auth_cubit.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/social_auth/social_auth_cubit.dart';
import 'package:mvmnt_cli/features/location/data/datasources/local/location_local_data_source.dart';
import 'package:mvmnt_cli/features/location/domain/location/get_current_address_usecase.dart';
import 'package:mvmnt_cli/features/location/domain/location/set_current_address_usecase.dart';
import 'package:mvmnt_cli/features/addresses/domain/usecases/saved/delete_address_usecase.dart';
import 'package:mvmnt_cli/features/addresses/domain/usecases/saved/get_address_history_usecase.dart';
import 'package:mvmnt_cli/features/addresses/domain/usecases/saved/add_to_address_history_usecase.dart';
import 'package:mvmnt_cli/features/addresses/domain/usecases/saved/update_address_usecase.dart';
import 'package:mvmnt_cli/features/addresses/presentation/cubits/saved/saved_addresses_cubit.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/social/signin_annonymously_usecase.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/social/signin_with_facebook_usecase.dart';
import 'package:mvmnt_cli/features/notifications/data/datasource/local/local_notification_service.dart';
import 'package:mvmnt_cli/features/notifications/data/datasource/local/messaging_firebase_service.dart';
import 'package:mvmnt_cli/features/payments/data/datasources/local/current_payment_method_datasource.dart';
import 'package:mvmnt_cli/features/payments/data/datasources/local/payment_methods_local_datasource.dart';
import 'package:mvmnt_cli/features/payments/data/datasources/remote/credits_remote_datasource.dart';
import 'package:mvmnt_cli/features/payments/data/datasources/remote/momo_remote_datasource.dart';
import 'package:mvmnt_cli/features/payments/data/datasources/remote/paypal_remote_datasouce.dart';
import 'package:mvmnt_cli/features/payments/data/datasources/remote/stripe_remote_datasource.dart';
import 'package:mvmnt_cli/features/payments/data/repository/current_payment_repository_impl.dart';
import 'package:mvmnt_cli/features/payments/data/repository/momo_repository_impl.dart';
import 'package:mvmnt_cli/features/payments/data/repository/payment_credits_repository_impl.dart';
import 'package:mvmnt_cli/features/payments/data/repository/payment_methods_repository_impl.dart';
import 'package:mvmnt_cli/features/payments/data/repository/paypal_repository_impl.dart';
import 'package:mvmnt_cli/features/payments/data/repository/stripe_repository_impl.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/current_payment_repository.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/momo_repository.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/payment_credits_repository.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/payment_methods_repository.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/paypal_repository.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/stripe_repository.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/credits/get_payment_credits_usecase.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/methods/get_active_payment_methods.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/current/get_default_payment_method_usecase.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/paypal/create_paypal_payment_token.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/paypal/get_paypal_methods_usecase.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/paypal/remove_payment_method_usecase.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/paypal/setup_paypal_token_usecase.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/methods/remove_saved_payment_method_usecase.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/stripe/get_card_methods_usecase.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/stripe/remove_card_method_usecase.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/stripe/save_card_method_usecase.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/methods/save_payment_method_usecase.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/current/set_default_payment_method.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/credits/payment_credits_cubit.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/current/current_payment_cubit.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/methods/payment_methods_cubit.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/paypal/paypal_cubit.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/stripe/stripe_cubit.dart';
import 'package:mvmnt_cli/features/referral/data/datasources/remote/referral_remote_datasource.dart';
import 'package:mvmnt_cli/features/referral/data/repository/referral_repository_impl.dart';
import 'package:mvmnt_cli/features/referral/domain/repository/referral_repository.dart';
import 'package:mvmnt_cli/features/referral/domain/usecases/get_issued_referrals_usecase.dart';
import 'package:mvmnt_cli/features/referral/domain/usecases/get_referral_code_usecase.dart';
import 'package:mvmnt_cli/features/referral/presentation/cubits/referral_cubit.dart';
import 'package:mvmnt_cli/features/settings/data/datasource/local/connectivity_service.dart';
import 'package:mvmnt_cli/features/settings/data/datasource/remote/safety_remote_datasource.dart';
import 'package:mvmnt_cli/features/settings/data/repository/connectivity_repository_impl.dart';
import 'package:mvmnt_cli/features/settings/data/repository/safety_repository_impl.dart';
import 'package:mvmnt_cli/features/settings/domain/repository/connectivity_repository.dart';
import 'package:mvmnt_cli/features/settings/domain/repository/safety_repository.dart';
import 'package:mvmnt_cli/features/settings/domain/usecases/check_connectivity_usecase.dart';
import 'package:mvmnt_cli/features/settings/domain/usecases/get_connectivity_status_usecase.dart';
import 'package:mvmnt_cli/features/settings/domain/usecases/get_safety_usecase.dart';
import 'package:mvmnt_cli/features/settings/domain/usecases/update_safety_usecase.dart';
import 'package:mvmnt_cli/features/settings/presentation/cubits/connectivity/connectivity_cubit.dart';
import 'package:mvmnt_cli/features/notifications/data/datasource/remote/notification_preferences_remote_data_source.dart';
import 'package:mvmnt_cli/features/notifications/data/repository/notification_preferences_repository_impl.dart';
import 'package:mvmnt_cli/features/notifications/data/repository/notification_service_repository_impl.dart';
import 'package:mvmnt_cli/features/notifications/domain/repository/notification_preference_repository.dart';
import 'package:mvmnt_cli/features/auth/data/datasources/auth_firebase_service.dart';
import 'package:mvmnt_cli/features/auth/data/repository/auth_repository_impl.dart';
import 'package:mvmnt_cli/features/auth/domain/repository/auth_repository.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/phone/send_phone_verification.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/social/signin_with_apple_usecase.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/social/signin_with_google_usecase.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/signout_usecase.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/stream_auth_state.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/phone/verify_phone_code.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/authentication/authentication_cubit.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/phone_auth/phone_auth_cubit.dart';
import 'package:mvmnt_cli/features/notifications/domain/repository/notification_service_repository.dart';
import 'package:mvmnt_cli/features/notifications/domain/usecases/get_notification_preferences_usecase.dart';
import 'package:mvmnt_cli/features/notifications/domain/usecases/initialize_notifications_usecase.dart';
import 'package:mvmnt_cli/features/notifications/domain/usecases/update_notification_preference_usecase.dart';
import 'package:mvmnt_cli/features/notifications/presentation/cubits/notification_preferences/notification_preferences_cubit.dart';
import 'package:mvmnt_cli/features/notifications/presentation/cubits/notifications_service/notification_service_cubit.dart';
import 'package:mvmnt_cli/features/location/data/datasources/local/location_service.dart';
import 'package:mvmnt_cli/features/addresses/data/datasources/local/addresses_local_data_source.dart';
import 'package:mvmnt_cli/features/addresses/data/datasources/remote/address_search_remote_data_source.dart';
import 'package:mvmnt_cli/features/addresses/data/repository/address_search_repository_impl.dart';
import 'package:mvmnt_cli/features/location/data/repository/location_service_repository_impl.dart';
import 'package:mvmnt_cli/features/addresses/data/repository/saved_addresses_repository_impl.dart';
import 'package:mvmnt_cli/features/addresses/domain/repository/address_search_repository.dart';
import 'package:mvmnt_cli/features/location/domain/repository/location_service_repository.dart';
import 'package:mvmnt_cli/features/addresses/domain/repository/saved_addresses_repository.dart';
import 'package:mvmnt_cli/features/addresses/domain/usecases/search/get_address_from_geocode_usecase.dart';
import 'package:mvmnt_cli/features/addresses/domain/usecases/search/get_geocode_from_address.dart';
import 'package:mvmnt_cli/features/addresses/domain/usecases/search/search_address_usecase.dart';
import 'package:mvmnt_cli/features/location/presentation/cubit/location_service_cubit.dart';
import 'package:mvmnt_cli/features/addresses/presentation/cubits/address_search/address_search_cubit.dart';
import 'package:mvmnt_cli/features/profile/data/datasources/remote/profile_remote_data_source.dart';
import 'package:mvmnt_cli/features/profile/data/repository/profile_repository_impl.dart';
import 'package:mvmnt_cli/features/profile/domain/repository/profile_repository.dart';
import 'package:mvmnt_cli/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:mvmnt_cli/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:mvmnt_cli/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:mvmnt_cli/features/settings/data/datasource/local/theme_local_datasource.dart';
import 'package:mvmnt_cli/features/settings/data/repository/theme_repository_impl.dart';
import 'package:mvmnt_cli/features/settings/domain/repository/theme_repository.dart';
import 'package:mvmnt_cli/features/settings/domain/usecases/get_theme_use_case.dart';
import 'package:mvmnt_cli/features/settings/domain/usecases/save_theme_use_case.dart';
import 'package:mvmnt_cli/features/settings/presentation/cubits/safety/safety_cubit.dart';
import 'package:mvmnt_cli/features/settings/presentation/cubits/theme/theme_cubit.dart';
import 'package:mvmnt_cli/features/support/data/datasources/remote/session_messages_remote_datasource.dart';
import 'package:mvmnt_cli/features/support/data/datasources/remote/support_session_remote_datasource.dart';
import 'package:mvmnt_cli/features/support/data/repository/session_messages_repository_impl.dart';
import 'package:mvmnt_cli/features/support/data/repository/support_session_repository_impl.dart';
import 'package:mvmnt_cli/features/support/domain/repository/session_messages_repository.dart';
import 'package:mvmnt_cli/features/support/domain/repository/support_session_repository.dart';
import 'package:mvmnt_cli/features/support/domain/usecases/session/create_session_usecase.dart';
import 'package:mvmnt_cli/features/support/domain/usecases/session/get_active_sessions_usecase.dart';
import 'package:mvmnt_cli/features/support/domain/usecases/messages/load_session_messages_usecase.dart';
import 'package:mvmnt_cli/features/support/domain/usecases/messages/send_session_message_usecase.dart';
import 'package:mvmnt_cli/features/support/domain/usecases/messages/stream_session_messages_usecase.dart';
import 'package:mvmnt_cli/features/support/presentation/cubits/messages/session_messages_cubit.dart';
import 'package:mvmnt_cli/features/support/presentation/cubits/session/support_session_cubit.dart';
import 'package:mvmnt_cli/services/navigation/navigation_service.dart';
import 'package:mvmnt_cli/services/navigation/navigation_service_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {
  registerFirebase();

  registerRouter();

  registerApiClient();

  await registerExternalServices();

  registerDatasources();

  registerRepositories();

  registerUseCases();

  registerCubits();
}

void registerFirebase() {
  serviceLocator.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );

  serviceLocator.registerLazySingleton<FirebaseMessaging>(
    () => FirebaseMessaging.instance,
  );

  serviceLocator.registerLazySingleton<FirebaseCrashlytics>(
    () => FirebaseCrashlytics.instance,
  );

  serviceLocator.registerLazySingleton<FirebaseAnalytics>(
    () => FirebaseAnalytics.instance,
  );

  serviceLocator.registerLazySingleton<FirebaseRemoteConfig>(
    () => FirebaseRemoteConfig.instance,
  );
}

void registerRouter() {
  serviceLocator.registerLazySingleton<GoRouter>(() => AppRouter.router);

  serviceLocator.registerLazySingleton<NavigationService>(
    () => NavigationServiceImpl(serviceLocator<GoRouter>()),
  );

  serviceLocator.registerLazySingleton(() => RouteNotifier(serviceLocator()));
}

void registerApiClient() {
  serviceLocator.registerSingleton(ApiClient());
}

Future registerExternalServices() async {
  // Shared Preferences
  serviceLocator.registerSingleton<SharedPreferences>(
    await SharedPreferences.getInstance(),
  );

  // Local Storage
  serviceLocator.registerSingleton<UserLocalStorage>(
    UserLocalStorage(serviceLocator(), serviceLocator()),
  );

  // Connectivity
  serviceLocator.registerLazySingleton<Connectivity>(() => Connectivity());

  // Local Notifications
  serviceLocator.registerLazySingleton<LocalNotificationsService>(
    () => LocalNotificationsService(
      flutterLocalNotificationsPlugin: FlutterLocalNotificationsPlugin(),
    ),
  );
}

void registerDatasources() {
  // Authentication Service
  serviceLocator.registerSingleton<AuthFirebaseService>(
    AuthFirebaseService(firebaseAuth: serviceLocator()),
  );

  // // Dio
  // var dio = serviceLocator<ApiClient>().getDio();
  var dioWithToken = serviceLocator<ApiClient>().getDio(tokenInterceptor: true);
  var socketClient = SocketClient();

  // // Socket
  serviceLocator.registerLazySingleton<SocketClient>(() => SocketClient());

  // Datasources
  serviceLocator.registerLazySingleton<RemoteConfig>(
    () => RemoteConfig(remoteConfig: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<CrashReportingService>(
    () => FirebaseCrashlyticsService(crashlytics: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<AnalyticsService>(
    () => FirebaseAnalyticsService(analytics: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<StripeService>(
    () => StripeService(dio: dioWithToken),
  );
  serviceLocator.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService(connectivity: serviceLocator()),
  );

  // // Notifications
  serviceLocator.registerSingleton<MessagingFirebaseService>(
    MessagingFirebaseService(
      dio: dioWithToken,
      firebaseMessaging: serviceLocator(),
      localNotificationsService: serviceLocator(),
    ),
  );

  serviceLocator.registerSingleton<ThemeLocalDatasource>(
    ThemeLocalDatasource(localStorage: serviceLocator()),
  );

  serviceLocator.registerSingleton<ProfileRemoteDataSource>(
    ProfileRemoteDataSource(dio: dioWithToken, firebaseAuth: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<SafetyRemoteDatasource>(
    () => SafetyRemoteDatasource(dio: dioWithToken),
  );
  serviceLocator.registerSingleton<NotificationPreferencesRemoteDataSource>(
    NotificationPreferencesRemoteDataSource(dio: dioWithToken),
  );
  serviceLocator.registerSingleton<LocationService>(LocationService());
  serviceLocator.registerSingleton<AddressLocalDataSource>(
    AddressLocalDataSource(),
  );
  serviceLocator.registerSingleton<LocationLocalDataSource>(
    LocationLocalDataSource(localStorage: serviceLocator()),
  );
  serviceLocator.registerSingleton<ReferralRemoteDatasource>(
    ReferralRemoteDatasource(dio: dioWithToken),
  );
  serviceLocator.registerSingleton<AddressSearchRemoteDataSource>(
    AddressSearchRemoteDataSource(dio: dioWithToken),
  );
  serviceLocator.registerSingleton<SavedAddressesRemoteDataSource>(
    SavedAddressesRemoteDataSource(dio: dioWithToken),
  );

  // Payments Datasources
  serviceLocator.registerSingleton<CurrentPaymentMethodDatasource>(
    CurrentPaymentMethodDatasource(localStorage: serviceLocator()),
  );
  serviceLocator.registerSingleton<PaymentMethodsLocalDatasource>(
    PaymentMethodsLocalDatasource(localStorage: serviceLocator()),
  );
  serviceLocator.registerSingleton<CreditsRemoteDataSource>(
    CreditsRemoteDataSource(dio: dioWithToken),
  );
  serviceLocator.registerSingleton<StripeRemoteDatasource>(
    StripeRemoteDatasource(dio: dioWithToken),
  );
  serviceLocator.registerSingleton<PaypalRemoteDatasouce>(
    PaypalRemoteDatasouce(dio: dioWithToken),
  );
  serviceLocator.registerSingleton<MomoRemoteDatasource>(
    MomoRemoteDatasource(dio: dioWithToken),
  );

  // Support Session
  serviceLocator.registerSingleton<SupportSessionRemoteDataSource>(
    SupportSessionRemoteDataSource(dio: dioWithToken),
  );
  serviceLocator.registerSingleton<SessionMessagesRemoteDatasource>(
    SessionMessagesRemoteDatasource(
      dio: dioWithToken,
      socketClient: socketClient,
    ),
  );
}

void registerRepositories() {
  // Theme
  serviceLocator.registerSingleton<ThemeRepository>(
    ThemeRepositoryImpl(themeLocalDatasource: serviceLocator()),
  );
  //Safety
  serviceLocator.registerSingleton<SafetyRepository>(
    SafetyRepositoryImpl(safetyRemoteDatasource: serviceLocator()),
  );

  // Auth
  serviceLocator.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(firebaseDataSource: serviceLocator()),
  );

  //Connectivity
  serviceLocator.registerSingleton<ConnectivityRepository>(
    ConnectivityRepositoryImpl(connectionDataSource: serviceLocator()),
  );

  // Notification Service
  serviceLocator.registerSingleton<NotificationServiceRepository>(
    NotificationServiceRepositoryImpl(
      // notificationFirebaseService: serviceLocator(),
      messagingFirebaseService: serviceLocator(),
    ),
  );

  // Profile
  serviceLocator.registerSingleton<ProfileRepository>(
    ProfileRepositoryImpl(profileRemoteDataSource: serviceLocator()),
  );

  // Notification Preferences
  serviceLocator.registerSingleton<NotificationPreferenceRepository>(
    NotificationPreferenceRepositoryImpl(
      notificationPreferencesRemoteDataSource: serviceLocator(),
    ),
  );

  // Location
  serviceLocator.registerSingleton<LocationServiceRepository>(
    LocationServiceRepositoryImpl(
      locationService: serviceLocator(),
      locationLocalDataSource: serviceLocator(),
    ),
  );

  // Referrals
  serviceLocator.registerSingleton<ReferralRepository>(
    ReferralRepositoryImpl(remoteDatasource: serviceLocator()),
  );

  // Addresses
  serviceLocator.registerSingleton<SavedAddressesRepository>(
    SavedAddressesRepositoryImpl(
      localDataSource: serviceLocator(),
      remoteDataSource: serviceLocator(),
    ),
  );
  serviceLocator.registerSingleton<AddressSearchRepository>(
    AddressSearchRepositoryImpl(
      addressRemoteDataSource: serviceLocator(),
      geoLocationDataSource: serviceLocator(),
    ),
  );

  // Payment
  serviceLocator.registerSingleton<CurrentPaymentRepository>(
    CurrentPaymentRepositoryImpl(localDatasource: serviceLocator()),
  );
  serviceLocator.registerSingleton<PaymentMethodsRepository>(
    PaymentMethodsRepositoryImpl(localDatasource: serviceLocator()),
  );
  serviceLocator.registerSingleton<PaymentCreditsRepository>(
    PaymentCreditsRepositoryImpl(remoteDataSource: serviceLocator()),
  );
  serviceLocator.registerSingleton<StripeRepository>(
    StripeRepositoryImpl(remoteDatasouce: serviceLocator()),
  );
  serviceLocator.registerSingleton<PaypalRepository>(
    PaypalRepositoryImpl(remoteDatasouce: serviceLocator()),
  );
  serviceLocator.registerSingleton<MomoRepository>(
    MomoRepositoryImpl(remoteDatasouce: serviceLocator()),
  );

  // Support
  serviceLocator.registerSingleton<SupportSessionRepository>(
    SupportSessionRepositoryImpl(remoteDataSource: serviceLocator()),
  );
  serviceLocator.registerSingleton<SessionMessagesRepository>(
    SessionMessagesRepositoryImpl(remoteDataSource: serviceLocator()),
  );
}

void registerUseCases() {
  // // Theme
  serviceLocator.registerLazySingleton(
    () => GetThemeUseCase(themeRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SaveThemeUseCase(themeRepository: serviceLocator()),
  );

  // // Connectivity
  serviceLocator.registerLazySingleton(
    () => CheckConnectivityUseCase(connectivityRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () =>
        GetConnectivityStatusUseCase(connectivityRepository: serviceLocator()),
  );

  // // Safety
  serviceLocator.registerLazySingleton(
    () => GetSafetyUsecase(safetyRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => UpdateSafetyUsecase(safetyRepository: serviceLocator()),
  );

  // // Notification
  serviceLocator.registerLazySingleton(
    () => GetNotificationPreferencesUsecase(
      notificationPreferenceRepository: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => UpdateNotificationPreferenceUsecase(
      notificationPreferenceRepository: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => InitializeNotificationsUsecase(
      notificationServiceRepository: serviceLocator(),
    ),
  );

  // // Auth
  serviceLocator.registerLazySingleton(
    () => SendPhoneVerificationUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => VerifyPhoneCodeUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SigninWithGoogleUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SigninWithAppleUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SigninWithFacebookUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SigninWithEmailAndPasswordUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SignupWithEmailAndPasswordUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => ResetEmailPasswordUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SendEmailVerificationUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => ConfirmEmailVerificationUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SignInAnonymousUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(() => SignoutUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(
    () => StreamAuthStateUseCase(serviceLocator()),
  );

  // // Profile
  serviceLocator.registerLazySingleton(
    () => GetProfileUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => UpdateProfileUsecase(serviceLocator()),
  );

  // // Referrals
  serviceLocator.registerLazySingleton(
    () => GetReferralCodeUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetIssuedReferralsUseCase(serviceLocator()),
  );

  // // Location
  serviceLocator.registerLazySingleton(
    () => GetCurrentAddressUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SetCurrentAddressUseCase(serviceLocator()),
  );

  // // Address Search
  serviceLocator.registerLazySingleton(
    () => SearchAddressUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetAddressFromGeocodeUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetGeocodeFromAddressUseCase(serviceLocator()),
  );

  // // Address Save
  serviceLocator.registerLazySingleton(
    () => AddToAddressesHistoryUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SaveAddressUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetAddressHistoryUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetLabelledAddressesUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => UpdateAddressUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => DeleteAddressUseCase(serviceLocator()),
  );

  // Payment Methods
  // // Methods
  serviceLocator.registerLazySingleton(
    () => GetActivePaymentMethodTypesUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => RemovePaymentMethodTypeUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SavePaymentMethodTypeUseCase(serviceLocator()),
  );
  // // Cards - Stripe
  serviceLocator.registerLazySingleton(
    () => GetCardMethodsUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SaveCardMethodUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => RemoveCardMethodUseCase(serviceLocator()),
  );
  // // Paypal
  serviceLocator.registerLazySingleton(
    () => GetPaypalMethodsUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SetupPaypalTokenUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => CreatePaypalPaymentTokenUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => RemovePaypalPaymentMethodUseCase(serviceLocator()),
  );
  // // Momo

  // // Default
  serviceLocator.registerLazySingleton(
    () => GetDefaultPaymentMethodUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SetDefaultPaymentMethodUseCase(serviceLocator()),
  );

  // // Default
  serviceLocator.registerLazySingleton(
    () => GetPaymentCreditsUseCase(serviceLocator()),
  );

  // Support
  serviceLocator.registerLazySingleton(
    () => GetActiveSessionsUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => CreateSessionUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => LoadSessionMessagesUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SendSessionMessageUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => StreamSessionMessagesUsecase(serviceLocator()),
  );
}

void registerCubits() {
  serviceLocator.registerFactory(
    () => ThemeCubit(
      getThemeUseCase: serviceLocator(),
      saveThemeUseCase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => ConnectivityCubit(
      getConnectivityStatusUseCase: serviceLocator(),
      checkConnectivityUseCase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => AuthenticationCubit(
      signOutUseCase: serviceLocator(),
      streamAuthStateUseCase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => SocialAuthCubit(
      signinWithGoogleUseCase: serviceLocator(),
      signinWithAppleUseCase: serviceLocator(),
      signinWithFacebookUseCase: serviceLocator(),
      signInAnonymousUseCase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => PhoneAuthCubit(
      sendPhoneVerificationUseCase: serviceLocator(),
      verifyPhoneCodeUseCase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => EmailAuthCubit(
      signinWithEmailUseCase: serviceLocator(),
      signupWithEmailUseCase: serviceLocator(),
      resetEmailPasswordUseCase: serviceLocator(),
      sendEmailVerificationUseCase: serviceLocator(),
      confirmEmailVerificationUseCase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => ProfileCubit(
      getProfileUsecase: serviceLocator(),
      updateProfileUsecase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => NotificationPreferencesCubit(
      getNotificationPreferencesUsecase: serviceLocator(),
      updateNotificationPreferenceUsecase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => NotificationServiceCubit(
      initializeNotificationsUsecase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => LocationServiceCubit(
      setCurrentAddressUseCase: serviceLocator(),
      getCurrentAddressUsecase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => AddressSearchCubit(
      searchAddressUseCase: serviceLocator(),
      getGeocodeFromAddressUsecase: serviceLocator(),
      getAddressFromGeocodeUsecase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => SavedAddressesCubit(
      getLabelledAddressesUsecase: serviceLocator(),
      getSavedAddressesUsecase: serviceLocator(),
      saveAddressUsecase: serviceLocator(),
      addToAddressesHistoryUseCase: serviceLocator(),
      updateAddressUseCase: serviceLocator(),
      deleteSavedAddressUsecase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => SafetyCubit(
      getSafetyUsecase: serviceLocator(),
      updateSafetyUsecase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => ReferralCubit(
      getIssuedReferralsUseCase: serviceLocator(),
      getReferralCodeUseCase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => CurrentPaymentCubit(
      setDefaultPaymentMethodUseCase: serviceLocator(),
      getDefaultPaymentMethodUseCase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => PaymentMethodsCubit(
      getActivePaymentMethodTypesUseCase: serviceLocator(),
      savePaymentMethodTypeUseCase: serviceLocator(),
      removePaymentMethodTypeUseCase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => PaymentCreditsCubit(getPaymentCreditsUseCase: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => StripeCubit(
      saveCardMethodUseCase: serviceLocator(),
      removeCardMethodUseCase: serviceLocator(),
      getCardMethodsUseCase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => PaypalCubit(
      getPaypalMethodsUseCase: serviceLocator(),
      setupPaypalMethodUseCase: serviceLocator(),
      createPaypalPaymentTokenUseCase: serviceLocator(),
      removePaypalPaymentMethodUseCase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => SupportSessionCubit(
      getActiveSessionsUseCase: serviceLocator(),
      createSessionUsecase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => SessionMessagesCubit(
      streamSessionMessagesUsecase: serviceLocator(),
      sendSessionMessageUseCase: serviceLocator(),
      loadSessionMessagesUseCase: serviceLocator(),
    ),
  );
}
