import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

class TermsText extends StatelessWidget {
  const TermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'By tapping any "Continue with..." button, our ',
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Lexend',
              color: Theme.of(context).colorScheme.onSurface,
            ),
            children: [
              TextSpan(
                text: "Terms & Conditions",
                style: TextStyle(decoration: TextDecoration.underline),
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () {
                        // launch('https://winie.io/privacy-terms');
                      },
              ),
              TextSpan(text: " and "),
              TextSpan(
                text: "Privacy Policy",
                style: TextStyle(decoration: TextDecoration.underline),
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () {
                        // launch('https://winie.io/privacy-terms');
                      },
              ),
              TextSpan(text: " apply to you. "),
              TextSpan(text: "You can equally change your "),
              TextSpan(
                text: "communication preferences",
                style: TextStyle(decoration: TextDecoration.underline),
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () {
                        // launch('https://winie.io/privacy-terms');
                      },
              ),
              TextSpan(text: "."),
            ],
          ),
        ),
      ),
    );
  }
}
