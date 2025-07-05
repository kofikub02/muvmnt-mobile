import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/email_auth/email_auth_cubit.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/email_auth/email_auth_state.dart';
import 'package:mvmnt_cli/features/auth/presentation/widgets/custom_password_field.dart';
import 'package:mvmnt_cli/ui/forms/custom_text_field.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';

class EmailAuthPage extends StatelessWidget {
  const EmailAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmailAuthCubit>(
      create: (_) => serviceLocator<EmailAuthCubit>(),
      child: _EmailAuthView(key: Key('email_auth_view')),
    );
  }
}

enum EmailAuthType { signin, signup }

class _EmailAuthView extends StatefulWidget {
  const _EmailAuthView({super.key});

  @override
  State<_EmailAuthView> createState() => _EmailAuthViewState();
}

class _EmailAuthViewState extends State<_EmailAuthView> {
  EmailAuthType emailAuthTypeView = EmailAuthType.signin;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    emailAuthTypeView == EmailAuthType.signin
                        ? 'Log in'
                        : 'Sign up',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text:
                          emailAuthTypeView == EmailAuthType.signin
                              ? 'If you are new here, '
                              : 'If you already have an account, ',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Lexend',
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      children: [
                        TextSpan(
                          text:
                              emailAuthTypeView == EmailAuthType.signin
                                  ? "Sign up"
                                  : 'Log in',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  setState(() {
                                    emailAuthTypeView =
                                        emailAuthTypeView ==
                                                EmailAuthType.signin
                                            ? EmailAuthType.signup
                                            : EmailAuthType.signin;
                                  });
                                  GoRouter.of(context).replace(
                                    '/auth/email?session=${emailAuthTypeView == EmailAuthType.signin ? 'login' : 'signup'}',
                                  );
                                  _emailController.text = '';
                                  _passwordController.text = '';
                                  context.read<EmailAuthCubit>().clearError();
                                },
                        ),
                        TextSpan(text: " here."),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        CustomTextField(
                          enabled: !loading,
                          label: "Email",
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          onChanged: (text) {
                            context.read<EmailAuthCubit>().clearError();
                          },
                        ),
                        CustomPasswordField(
                          enabled: !loading,
                          controller: _passwordController,
                          onChanged: (text) {
                            context.read<EmailAuthCubit>().clearError();
                          },
                        ),
                        if (emailAuthTypeView == EmailAuthType.signin) ...[
                          SizedBox(height: 14),
                          GestureDetector(
                            onTap: () {
                              if (!loading) {
                                context.read<EmailAuthCubit>().clearError();
                                context.push('/auth/email/reset-password');
                              }
                            },
                            child: Text(
                              'Reset Password',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<EmailAuthCubit>().clearError();

                          if (emailAuthTypeView == EmailAuthType.signin) {
                            context
                                .read<EmailAuthCubit>()
                                .signInWithEmailAndPassword(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                          } else {
                            context
                                .read<EmailAuthCubit>()
                                .signUpWithEmailAndPassword(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                          }
                        },
                        child: Text(
                          emailAuthTypeView == EmailAuthType.signin
                              ? 'Log in'
                              : 'Sign up',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EmailAuthSelect extends StatefulWidget {
  final Function onChange;
  final EmailAuthType type;

  const _EmailAuthSelect({required this.onChange, required this.type});

  @override
  State<_EmailAuthSelect> createState() => __EmailAuthSelectState();
}

class __EmailAuthSelectState extends State<_EmailAuthSelect> {
  @override
  Widget build(BuildContext context) {
    return SegmentedButton<EmailAuthType>(
      segments: const <ButtonSegment<EmailAuthType>>[
        ButtonSegment<EmailAuthType>(
          value: EmailAuthType.signin,
          label: Text('Log in'),
        ),
        ButtonSegment<EmailAuthType>(
          value: EmailAuthType.signup,
          label: Text('Sign up'),
        ),
      ],
      selected: <EmailAuthType>{widget.type},
      onSelectionChanged: (Set<EmailAuthType> newSelection) {
        widget.onChange(newSelection.first);
      },
    );
  }
}
