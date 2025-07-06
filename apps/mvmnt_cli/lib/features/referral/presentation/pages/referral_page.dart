import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/features/referral/presentation/cubits/referral_state.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';
import 'package:mvmnt_cli/features/referral/presentation/cubits/referral_cubit.dart';
import 'package:share_plus/share_plus.dart';

class ReferralPage extends StatelessWidget {
  const ReferralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReferralCubit>(
      create: (_) => serviceLocator<ReferralCubit>(),
      child: _ReferralView(key: key),
    );
  }
}

class _ReferralView extends StatefulWidget {
  const _ReferralView({super.key});

  @override
  State<_ReferralView> createState() => _ReferralViewState();
}

class _ReferralViewState extends State<_ReferralView> {
  @override
  void initState() {
    super.initState();
    context.read<ReferralCubit>().getReferralCode();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReferralCubit, ReferralState>(
      builder: (context, state) {
        bool isNotLoaded =
            state.status == ReferralStatus.loading ||
            state.referralCode == null;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: SvgIcon(name: 'arrow-left'),
            ),
          ),
          body: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: SvgPicture.asset(
                      'assets/images/credits.svg',
                      width: 128,
                      height: 128,
                    ),
                  ),
                  Text(
                    isNotLoaded
                        ? 'Share your referral link'
                        : 'Share \$${state.referralCode?.points}, Get \$${state.referralCode?.points}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Text(
                      'Get ${isNotLoaded ? ' \$${state.referralCode?.points} in' : ''} credits when someone signs up using your referral link and places their first. Your friend will also get ${isNotLoaded ? ' \$${state.referralCode?.points} in' : ''} credits of their first order.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  TextButton(
                    child: const Text(
                      'Check referral status →',
                      style: TextStyle(fontSize: 14),
                    ),
                    onPressed: () {
                      context.push('/account/referral/issued');
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Questions?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "See our ",
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      children: [
                        TextSpan(
                          text: "Referral FAQ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  // launch('https://winie.io/privacy-terms');
                                },
                        ),
                        TextSpan(text: " and "),
                        TextSpan(
                          text: "Terms & Conditions",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  // launch('https://winie.io/privacy-terms');
                                },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 32,
                    ),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color?>((
                                Set<WidgetState> states,
                              ) {
                                return Theme.of(context).colorScheme.error;
                              }),
                        ),
                        onPressed:
                            isNotLoaded
                                ? null
                                : () {
                                  SharePlus.instance.share(
                                    ShareParams(
                                      text: '${state.referralCode?.code}',
                                    ),
                                  );
                                },
                        label: Text(
                          isNotLoaded ? 'Loading..' : 'Share Your Link',
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: SvgIcon(name: 'share', color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
