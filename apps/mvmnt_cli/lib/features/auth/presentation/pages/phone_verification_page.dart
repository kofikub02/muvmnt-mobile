import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/phone_auth/phone_auth_cubit.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/phone_auth/phone_auth_state.dart';
import 'package:mvmnt_cli/features/auth/presentation/widgets/resend_code.dart';
import 'package:mvmnt_cli/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:mvmnt_cli/ui/forms/custom_text_field.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class PhoneVerificationPage extends StatelessWidget {
  final String phoneNumber;

  const PhoneVerificationPage({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhoneAuthCubit>(
      create: (_) => serviceLocator<PhoneAuthCubit>(),
      child: _PhoneVerificationView(
        key: Key('phone_verify_view'),
        phoneNumber: Uri.decodeComponent(phoneNumber),
      ),
    );
  }
}

class _PhoneVerificationView extends StatefulWidget {
  final String phoneNumber;

  const _PhoneVerificationView({super.key, required this.phoneNumber});

  @override
  State<_PhoneVerificationView> createState() => _PhoneVerificationViewState();
}

class _PhoneVerificationViewState extends State<_PhoneVerificationView> {
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
    context.read<PhoneAuthCubit>().sendVerification(widget.phoneNumber, false);
  }

  @override
  void dispose() {
    super.dispose();
    _codeController.dispose();
  }

  Map<String, dynamic> _buildUpdatePhoneJson() {
    final Map<String, dynamic> updated = {};
    String countryCode = '';
    String number = '';

    RegExp regex = RegExp(r'^\+(\d+)(\d{10})$');
    var match = regex.firstMatch(widget.phoneNumber);

    if (match != null && match.groupCount >= 2) {
      countryCode = '+${match.group(1)}';
      number = match.group(2) ?? '';
    } else {
      // If pattern doesn't match, keep number as is
      number = widget.phoneNumber;
    }

    updated['phone'] = {
      'country_code': countryCode,
      'number': number,
      'verified': true,
    };

    return updated;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
      listener: (context, state) {
        if (state.status == PhoneAuthStatus.verified) {
          context.read<ProfileCubit>().updateProfile(_buildUpdatePhoneJson());
          context.pop(true);
        }
      },
      builder: (context, state) {
        bool loading = state.status == PhoneAuthStatus.loading;

        return Scaffold(
          appBar: AppBar(
            shape: Border(bottom: BorderSide.none),
            leading: IconButton(
              onPressed:
                  loading
                      ? null
                      : () {
                        Navigator.pop(context, false);
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
                  Text(
                    'Phone number verification',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text:
                          "For your security, we want to make sure it's really you. We sent a code to ",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Lexend',
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      children: [
                        TextSpan(
                          text: widget.phoneNumber,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  CustomTextField(
                    enabled: !loading,
                    maxLength: 6,
                    label: "Enter 6-digit code",
                    controller: _codeController,
                    keyboardType: TextInputType.phone,
                    onChanged: (code) {
                      context.read<PhoneAuthCubit>().clearError();
                      if (code.length == 6) {
                        context.read<PhoneAuthCubit>().verifyCode(code);
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  ResendCode(
                    enabled: !loading,
                    phoneNumber: widget.phoneNumber,
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
