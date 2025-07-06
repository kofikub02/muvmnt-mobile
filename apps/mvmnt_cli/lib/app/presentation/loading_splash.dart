import 'package:flutter/material.dart';

class LoadingSplash extends StatelessWidget {
  static const route = '/loading';

  const LoadingSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
