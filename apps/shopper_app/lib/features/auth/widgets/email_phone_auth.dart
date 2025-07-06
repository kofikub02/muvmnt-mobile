import 'package:flutter/material.dart';

class EmailPhoneAuth extends StatefulWidget {
  const EmailPhoneAuth({super.key});

  @override
  State<EmailPhoneAuth> createState() => _EmailPhoneAuthState();
}

class _EmailPhoneAuthState extends State<EmailPhoneAuth> {
  bool isPhone = true;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _emailController;
  String _selectedCountryCode = '';

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = '+1';
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child:
              isPhone
                  ? CustomPhoneField(
                    selectedCountryCode: '+1',
                    phoneNumberController: _phoneNumberController,
                    onCountryChanged: (code) {},
                  )
                  : CustomTextField(
                    // enabled: !loading,
                    label: "Email",
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    onChanged: (text) {
                      // context.read<EmailAuthCubit>().clearError();
                    },
                  ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: GestureDetector(
            onTap: () {
              setState(() {
                isPhone = !isPhone;
              });
            },
            child: Text(
              isPhone ? 'Use email instead' : 'Use phone number instead',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                String fullPhoneNumber =
                    '$_selectedCountryCode${_phoneNumberController.text.trim()}';
                String encodedPhone = Uri.encodeComponent(fullPhoneNumber);

                await context.push('/profile/phone?phone_number=$encodedPhone');
              },
              child: Text(
                isPhone ? 'Continue with Phone number' : 'Continue with Email',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
