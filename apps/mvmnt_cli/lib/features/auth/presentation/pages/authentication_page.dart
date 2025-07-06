import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/features/auth/presentation/widgets/social_auth.dart';
import 'package:mvmnt_cli/features/auth/presentation/widgets/text_divider.dart';
import 'package:mvmnt_cli/features/auth/presentation/widgets/auth_button.dart';
import 'package:mvmnt_cli/features/auth/presentation/widgets/terms.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  static const String route = '/auth';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ''),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 32),
            AuthButton(
              icon: SvgIcon(name: 'smartphone'),
              name: "Number",
              callFunction: () async {
                context.push('/auth/phone');
              },
            ),
            AuthButton(
              icon: SvgIcon(name: 'mail'),
              name: "Email",
              callFunction: () async {
                context.push('/auth/email?session=login');
              },
            ),
            TextDivider(text: 'or'),
            SocialAuth(),
            Spacer(),
            TermsText(),
          ],
        ),
      ),
    );
  }
}
