import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/core/util/device/device_utility.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/authentication/authentication_cubit.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/authentication/authentication_state.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/social_auth/social_auth_cubit.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/social_auth/social_auth_state.dart';
import 'package:mvmnt_cli/features/auth/presentation/widgets/auth_button.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class SocialAuth extends StatelessWidget {
  const SocialAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SocialAuthCubit>(
      create: (_) => serviceLocator<SocialAuthCubit>(),
      child: _SocialAuthView(key: Key('social_auth_view')),
    );
  }
}

class _SocialAuthView extends StatelessWidget {
  const _SocialAuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SocialAuthCubit, SocialAuthState>(
      listener: (context, state) {
        if (state.status == SocialAuthStatus.failure &&
            state.errorMessage != null &&
            state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Authentication failure'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Column(
        children: [
          if (TDeviceUtils.isIOS()) ...[
            AuthButton(
              icon: SvgIcon(name: 'apple'),
              name: "Apple",
              callFunction: () async {
                context.read<SocialAuthCubit>().signInWithApplePressed();
              },
            ),
          ],
          AuthButton(
            icon: SvgIcon(name: 'google', hasIntrinsic: true),
            name: "Google",
            callFunction: () async {
              context.read<SocialAuthCubit>().signInWithGooglePressed();
            },
          ),
          AuthButton(
            icon: SvgIcon(name: 'facebook', hasIntrinsic: true),
            name: "Facebook",
            callFunction: () async {
              context.read<SocialAuthCubit>().signInWithFacebookPressed();
            },
          ),
          BlocBuilder<AuthenticationCubit, AuthenticationState>(
            builder: (context, state) {
              if (state.authEntity?.isAnonymous == false) {
                return AuthButton(
                  icon: SvgIcon(name: 'map-pin'),
                  name: "Near-by",
                  callFunction: () async {
                    context.read<SocialAuthCubit>().signInAnonymousInitiated();
                  },
                );
              }

              return Container();
            },
          ),
        ],
      ),
    );
  }
}
