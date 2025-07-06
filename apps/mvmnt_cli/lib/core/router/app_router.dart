import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/features/auth/presentation/pages/anonymous_auth.dart';
import 'package:mvmnt_cli/app/presentation/not_found_page.dart';
import 'package:mvmnt_cli/app/presentation/loading_splash.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/core/router/route_notifier.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';
import 'package:mvmnt_cli/features/addresses/presentation/pages/address_icon_page.dart';
import 'package:mvmnt_cli/features/addresses/presentation/pages/address_label_page.dart';
import 'package:mvmnt_cli/features/addresses/presentation/pages/address_search_page.dart';
import 'package:mvmnt_cli/features/addresses/presentation/pages/address_pin_page.dart';
import 'package:mvmnt_cli/features/addresses/presentation/pages/edit_address_page.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/authentication/authentication_state.dart';
import 'package:mvmnt_cli/features/auth/presentation/pages/email_auth_page.dart';
import 'package:mvmnt_cli/features/auth/presentation/pages/reset_password_page.dart';
import 'package:mvmnt_cli/features/location/domain/entities/geo_latlng_entity.dart';
import 'package:mvmnt_cli/features/notifications/presentation/pages/notification_preferences_page.dart';
import 'package:mvmnt_cli/features/addresses/presentation/pages/addresses_page.dart';
import 'package:mvmnt_cli/features/orders/presentation/pages/order_detail_page.dart';
import 'package:mvmnt_cli/features/profile/presentation/pages/delete_profile_page.dart';
import 'package:mvmnt_cli/features/auth/presentation/pages/email_verification_page.dart';
import 'package:mvmnt_cli/features/auth/presentation/pages/phone_verification_page.dart';
import 'package:mvmnt_cli/features/referral/presentation/pages/issued_referrals_page.dart';
import 'package:mvmnt_cli/features/referral/presentation/pages/referral_page.dart';
import 'package:mvmnt_cli/features/settings/presentation/pages/locale_page.dart';
import 'package:mvmnt_cli/features/settings/presentation/pages/privacy_page.dart';
import 'package:mvmnt_cli/features/settings/presentation/pages/theme_page.dart';
import 'package:mvmnt_cli/features/support/presentation/pages/feed_back_page.dart';
import 'package:mvmnt_cli/features/support/presentation/pages/select_order_for_support_page.dart';
import 'package:mvmnt_cli/features/vendors/presentation/pages/nearby_vendors_map_page.dart';
import 'package:mvmnt_cli/app/presentation/pages/account_page.dart';
import 'package:mvmnt_cli/app/presentation/pages/activity_page.dart';
import 'package:mvmnt_cli/features/auth/presentation/pages/authentication_page.dart';
import 'package:mvmnt_cli/features/auth/presentation/pages/phone_auth_page.dart';
import 'package:mvmnt_cli/app/presentation/app_layout.dart';
import 'package:mvmnt_cli/app/presentation/pages/home_page.dart';
import 'package:mvmnt_cli/features/profile/presentation/pages/profile_page.dart';
import 'package:mvmnt_cli/features/settings/presentation/pages/safety_page.dart';
import 'package:mvmnt_cli/features/support/presentation/pages/support_contact_page.dart';
import 'package:mvmnt_cli/features/support/presentation/pages/support_page.dart';
import 'package:mvmnt_cli/features/payments/presentation/pages/payment_page.dart';

final _routeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

bool _isWebViewRoute(String route) {
  final webViewPatterns = [
    'com.googleusercontent.apps',
    'google.com/recaptcha',
    'accounts.google.com',
    // Add other patterns as needed
  ];

  return webViewPatterns.any((pattern) => route.contains(pattern));
}

class AppRouter {
  static var router = GoRouter(
    navigatorKey: _routeNavigatorKey,
    refreshListenable: serviceLocator<RouteNotifier>(),
    initialLocation: HomePage.route,
    redirect: (context, state) {
      final authNotifier = serviceLocator<RouteNotifier>();
      final authState = authNotifier.authStatus;
      final currentRoute = state.uri.toString();
      final isAuthRoute = currentRoute.startsWith('/auth');

      if (kDebugMode) {
        print('Redirect check: $currentRoute, Auth: ${authState.status}');
      }

      // Allow webview routes (for OAuth, reCAPTCHA, etc.)
      if (_isWebViewRoute(currentRoute)) {
        return null;
      }

      if (authState.status == AuthenticationStatus.initial) {
        return LoadingSplash.route;
      }

      // Handle loading state - stay on loading splash
      if (authState.status == AuthenticationStatus.loading) {
        if (currentRoute != LoadingSplash.route) {
          return LoadingSplash.route;
        }
        return null;
      }

      // Handle error state - could redirect to error page or auth
      if (authState.status == AuthenticationStatus.failure) {
        if (!isAuthRoute) {
          return AuthenticationPage.route;
        }
        return null;
      }

      final isAuthenticated =
          authState.status == AuthenticationStatus.authenticated;

      if (!isAuthenticated) {
        if (isAuthRoute) {
          return null;
        }
        return AuthenticationPage.route;
      }

      if (isAuthenticated && isAuthRoute) {
        return HomePage.route;
      }

      return null;
    },
    errorBuilder: (context, state) => NotFoundPage(),
    routes: [
      GoRoute(
        path: LoadingSplash.route,
        builder: (_, _) => const LoadingSplash(),
      ),
      GoRoute(
        path: AuthenticationPage.route,
        builder: (BuildContext context, GoRouterState state) {
          return AuthenticationPage();
        },
        routes: [
          GoRoute(
            path: '/phone',
            builder: (BuildContext context, GoRouterState state) {
              return PhoneAuthPage();
            },
          ),
          GoRoute(
            path: '/email',
            builder: (BuildContext context, GoRouterState state) {
              return EmailAuthPage();
            },
            routes: [
              GoRoute(
                path: '/reset-password',
                builder: (BuildContext context, GoRouterState state) {
                  return ResetPasswordPage();
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/anonymous',
        builder: (BuildContext context, GoRouterState state) {
          return AnonymousAuthPage();
        },
      ),
      StatefulShellRoute.indexedStack(
        builder:
            (context, state, navigationShell) =>
                AppLayout(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: HomePage.route,
                builder: (BuildContext context, GoRouterState state) {
                  return const HomePage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/activity',
                builder: (BuildContext context, GoRouterState state) {
                  return const ActivityPage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AccountPage.route,
                builder: (BuildContext context, GoRouterState state) {
                  return AccountPage();
                },
                routes: [
                  GoRoute(
                    path: '/safety',
                    builder: (BuildContext context, GoRouterState state) {
                      return SafetyPage();
                    },
                  ),
                  GoRoute(
                    path: '/privacy',
                    builder: (BuildContext context, GoRouterState state) {
                      return PrivacyPage();
                    },
                  ),
                  GoRoute(
                    path: '/notifications',
                    builder: (BuildContext context, GoRouterState state) {
                      return NotificationPreferencesPage();
                    },
                  ),
                  GoRoute(
                    path: '/theme',
                    builder: (BuildContext context, GoRouterState state) {
                      return ThemePage();
                    },
                  ),
                  GoRoute(
                    path: '/locale',
                    builder: (BuildContext context, GoRouterState state) {
                      return LocalePage();
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: NearbyVendorsMapPage.route,
        builder: (BuildContext context, GoRouterState state) {
          return NearbyVendorsMapPage();
        },
      ),
      GoRoute(
        path: OrderDetailPage.route,
        builder: (BuildContext context, GoRouterState state) {
          return OrderDetailPage();
        },
      ),
      GoRoute(
        path: PaymentPage.route,
        builder: (BuildContext context, GoRouterState state) {
          return PaymentPage();
        },
      ),
      GoRoute(
        path: AddressesPage.route,
        builder: (BuildContext context, GoRouterState state) {
          return AddressesPage();
        },
        routes: [
          GoRoute(
            path: '/search',
            builder: (BuildContext context, GoRouterState state) {
              final title = state.extra as String;
              return AddressSearchPage(title: title);
            },
          ),
          GoRoute(
            path: '/edit',
            builder: (BuildContext context, GoRouterState state) {
              final address = state.extra as AddressEntity;
              return EditAddressPage(address: address);
            },
          ),
          GoRoute(
            path: '/label',
            builder: (BuildContext context, GoRouterState state) {
              final address = state.extra as AddressEntity;
              return AddressLabelPage(address: address);
            },
          ),
          GoRoute(
            path: '/pin',
            builder: (BuildContext context, GoRouterState state) {
              final latlng = state.extra as GeoLatLngEntity;
              return AddressPinPage(latlng: latlng);
            },
          ),
          GoRoute(
            path: '/icon',
            builder: (BuildContext context, GoRouterState state) {
              final icon = state.extra as String?;
              return AddressIconPage(existingIcon: icon);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/support',
        builder: (BuildContext context, GoRouterState state) {
          return SupportPage();
        },
        routes: [
          GoRoute(
            path: '/feedback',
            builder: (BuildContext context, GoRouterState state) {
              return FeedBackPage();
            },
          ),
          GoRoute(
            path: '/select',
            builder: (BuildContext context, GoRouterState state) {
              return SelectOrderForSupportPage();
            },
          ),
          GoRoute(
            path: '/contact',
            builder: (BuildContext context, GoRouterState state) {
              final sessionId = state.extra as String;
              return SupportContactPage(sessionId: sessionId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/referral',
        builder: (BuildContext context, GoRouterState state) {
          return ReferralPage();
        },
        routes: [
          GoRoute(
            path: '/issued',
            builder: (BuildContext context, GoRouterState state) {
              return IssuedReferralsPage();
            },
          ),
        ],
      ),
      GoRoute(
        path: '/profile',
        builder: (BuildContext context, GoRouterState state) {
          return ProfilePage();
        },
        routes: [
          GoRoute(
            path: '/phone',
            builder: (BuildContext context, GoRouterState state) {
              final phoneNumber = state.uri.queryParameters['phone_number']!;
              return PhoneVerificationPage(phoneNumber: phoneNumber);
            },
          ),
          GoRoute(
            path: '/email',
            builder: (BuildContext context, GoRouterState state) {
              final emailAddress = state.uri.queryParameters['emailAddress']!;
              final isNew = state.uri.queryParameters['isNew'] == 'true';
              return EmailVerificationPage(
                emailAddress: emailAddress,
                isNewEmail: isNew,
              );
            },
          ),
          GoRoute(
            path: '/delete',
            builder: (BuildContext context, GoRouterState state) {
              return DeleteProfilePage();
            },
          ),
        ],
      ),
    ],
  );
}
