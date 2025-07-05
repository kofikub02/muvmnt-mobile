import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/features/auth/presentation/widgets/resend_code.dart';
import 'package:mvmnt_cli/ui/forms/custom_phone_field.dart';
import 'package:mvmnt_cli/ui/forms/custom_text_field.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/phone_auth/phone_auth_cubit.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/phone_auth/phone_auth_state.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class PhoneAuthPage extends StatelessWidget {
  const PhoneAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhoneAuthCubit>(
      create: (_) => serviceLocator<PhoneAuthCubit>(),
      child: _PhoneAuthView(key: Key('email_auth_view')),
    );
  }
}

class _PhoneAuthView extends StatefulWidget {
  const _PhoneAuthView({super.key});

  @override
  State<_PhoneAuthView> createState() => _PhoneAuthViewState();
}

class _PhoneAuthViewState extends State<_PhoneAuthView> {
  late final PageController _pageController;
  late final TextEditingController _phoneController;
  late final TextEditingController _codeController;
  late String _selectedCountryCode;

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = '+1';
    _pageController = PageController(initialPage: 0);
    _phoneController = TextEditingController();
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
      listener: (context, state) {
        if (state.status == PhoneAuthStatus.codeSent &&
            _pageController.page?.round() == 0) {
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      builder: (context, state) {
        bool loading = state.status == PhoneAuthStatus.loading;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                if (_pageController.page?.round() == 0) {
                  Navigator.pop(context);
                } else {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              icon: SvgIcon(name: 'arrow-left'),
            ),
            shape: Border(bottom: BorderSide.none),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SafeArea(
              child: PageView.builder(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(), // prevent swipe
                itemCount: 2,
                itemBuilder: (context, position) {
                  return Column(
                    children: [
                      Expanded(
                        child:
                            position == 0
                                ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Enter your number',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "We'll send a verification code to your phone number",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    CustomPhoneField(
                                      enabled: !loading,
                                      selectedCountryCode: _selectedCountryCode,
                                      phoneNumberController: _phoneController,
                                      onCountryChanged: (value) {
                                        context
                                            .read<PhoneAuthCubit>()
                                            .clearError();
                                        setState(() {
                                          _selectedCountryCode = value;
                                        });
                                      },
                                      onPhoneChanged: (value) {
                                        context
                                            .read<PhoneAuthCubit>()
                                            .clearError();
                                      },
                                    ),
                                    if (state.errorMessage != null &&
                                        state.errorMessage!.isNotEmpty) ...[
                                      SizedBox(height: 14),
                                      Text(
                                        state.errorMessage!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.error,
                                        ),
                                      ),
                                    ],
                                  ],
                                )
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Verify phone number',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                        text: 'A code was sent to ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Lexend',
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                '$_selectedCountryCode${_phoneController.text.trim()}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (state.errorMessage != null &&
                                        state.errorMessage!.isNotEmpty) ...[
                                      SizedBox(height: 14),
                                      Text(
                                        state.errorMessage!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.error,
                                        ),
                                      ),
                                    ],
                                    CustomTextField(
                                      enabled: !loading,
                                      maxLength: 6,
                                      label: "6-digit code",
                                      keyboardType: TextInputType.phone,
                                      onChanged: (code) {
                                        context
                                            .read<PhoneAuthCubit>()
                                            .clearError();
                                        if (code.length == 6) {
                                          context
                                              .read<PhoneAuthCubit>()
                                              .verifyCode(code);
                                        }
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    ResendCode(
                                      enabled: !loading,
                                      phoneNumber:
                                          '$_selectedCountryCode${_phoneController.text.trim()}',
                                    ),
                                  ],
                                ),
                      ),
                      if (position == 0) ...[
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<PhoneAuthCubit>().clearError();
                                final phoneNumber =
                                    '$_selectedCountryCode${_phoneController.text.trim()}';
                                context.read<PhoneAuthCubit>().sendVerification(
                                  phoneNumber,
                                  false,
                                );
                              },
                              child: Text('Continue'),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
