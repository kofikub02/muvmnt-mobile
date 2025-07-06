import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/email_auth/email_auth_cubit.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/email_auth/email_auth_state.dart';
import 'package:mvmnt_cli/ui/forms/custom_text_field.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmailAuthCubit>(
      create: (_) => serviceLocator<EmailAuthCubit>(),
      child: _ResetPasswordPage(key: Key('reset_password_view')),
    );
  }
}

class _ResetPasswordPage extends StatefulWidget {
  const _ResetPasswordPage({super.key});

  @override
  State<_ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<_ResetPasswordPage> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmailAuthCubit, EmailAuthState>(
      builder: (context, state) {
        bool loading = state.status == EmailAuthStatus.loading;

        return Scaffold(
          appBar: CustomAppBar(title: '', showBorder: false),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Reset password',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (state.status == EmailAuthStatus.loading) ...[
                              CircularProgressIndicator.adaptive(),
                            ],
                          ],
                        ),
                        Text(
                          "We'll send a password reset link to your email shortly",
                          style: TextStyle(fontSize: 14),
                        ),
                        if (state.errorMessage != null &&
                            state.errorMessage!.isNotEmpty) ...[
                          SizedBox(height: 14),
                          Text(
                            state.errorMessage!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],

                        if (state.status == EmailAuthStatus.resetSuccess) ...[
                          SizedBox(height: 14),
                          Text(
                            'Password reset link has been sent to ${_emailController.text.trim()}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ] else ...[
                          CustomTextField(
                            enabled: !loading,
                            label: "Email",
                            controller: _emailController,
                            onChanged: (text) {
                              context.read<EmailAuthCubit>().clearError();
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (state.status != EmailAuthStatus.resetSuccess) ...[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<EmailAuthCubit>().clearError();
                            context.read<EmailAuthCubit>().resetPassword(
                              _emailController.text.trim(),
                            );
                          },
                          child: Text('Submit'),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
