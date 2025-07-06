import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final Widget icon;
  final String name;

  final Function callFunction;

  const AuthButton({
    super.key,
    required this.icon,
    required this.name,

    required this.callFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16, left: 16, bottom: 10),
      height: 50,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () async {
          await callFunction();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [icon, Text("Continue with $name")],
        ),
      ),
    );
  }
}
