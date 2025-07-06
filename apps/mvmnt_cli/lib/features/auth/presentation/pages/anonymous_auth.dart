import 'package:flutter/material.dart';
import 'package:mvmnt_cli/features/auth/presentation/widgets/email_phone_auth.dart';
import 'package:mvmnt_cli/features/auth/presentation/widgets/social_auth.dart';
import 'package:mvmnt_cli/features/auth/presentation/widgets/text_divider.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';
import 'package:mvmnt_cli/ui/widgets/dismiss_keyboard.dart';

class AnonymousAuthPage extends StatelessWidget {
  const AnonymousAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Unlock new features'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16),
              EmailPhoneAuth(),
              TextDivider(text: 'or'),
              SocialAuth(),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
