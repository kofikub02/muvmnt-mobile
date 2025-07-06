import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/email_auth/email_auth_cubit.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/email_auth/email_auth_state.dart';
import 'package:mvmnt_cli/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class EmailVerificationPage extends StatelessWidget {
  final String emailAddress;
  final bool isNewEmail;

  const EmailVerificationPage({
    super.key,
    required this.emailAddress,
    required this.isNewEmail,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmailAuthCubit>(
      create: (_) => serviceLocator<EmailAuthCubit>(),
      child: _EmailVerificationView(
        key: Key('email_verify_view'),
        email: Uri.decodeComponent(emailAddress),
        isNewEmail: isNewEmail,
      ),
    );
  }
}

class _EmailVerificationView extends StatefulWidget {
  final String email;
  final bool isNewEmail;

  const _EmailVerificationView({
    super.key,
    required this.email,
    required this.isNewEmail,
  });

  @override
  State<_EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<_EmailVerificationView> {
  bool isVerified = false;

  @override
  void initState() {
    super.initState();
    print('${widget.email} - ${widget.isNewEmail}');
    context.read<EmailAuthCubit>().sendEmailVerificationRequested(
      widget.email,
      widget.isNewEmail,
    );
  }

  Map<String, dynamic> _buildUpdateEmailJson(bool isVerified) {
    final Map<String, dynamic> updated = {};

    updated['email'] = {'address': widget.email, 'verified': isVerified};

    return updated;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmailAuthCubit, EmailAuthState>(
      listener: (context, state) {
        if (state.status == EmailAuthStatus.verificationSent) {
          context.read<ProfileCubit>().updateProfile(
            _buildUpdateEmailJson(false),
          );
        } else if (state.status == EmailAuthStatus.verificationConfirmed) {
          context.read<ProfileCubit>().updateProfile(
            _buildUpdateEmailJson(true),
          );
          context.pop();
        }
      },
      builder: (context, state) {
        bool loading = state.status == EmailAuthStatus.loading;
        bool sent = state.status == EmailAuthStatus.verificationSent;
        bool hasError = state.status == EmailAuthStatus.error;

        return Scaffold(
          appBar: AppBar(
            shape: Border(bottom: BorderSide.none),
            leading: IconButton(
              onPressed:
                  loading
                      ? null
                      : () {
                        Navigator.pop(context);
                      },
              icon: SvgIcon(name: 'x'),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email verification',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (sent) ...[
                          RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              text:
                                  "For your security, we want to make sure it's really you. We sent a verification link to ",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Lexend',
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              children: [
                                TextSpan(
                                  text: widget.email,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                TextSpan(
                                  text:
                                      '. After verification, you can come back to confirm the verification.',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<EmailAuthCubit>()
                                      .confirmEmailVerificationRequested();
                                },
                                child: Text('Confirm verification'),
                              ),
                            ],
                          ),
                        ] else if (hasError &&
                            state.errorMessage != null &&
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
                      ],
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
