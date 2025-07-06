import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Not Found'),
      body: Center(
        child: TextButton(
          onPressed: () {
            context.push('/');
          },
          child: Text('Not Found, Return to main'),
        ),
      ),
    );
  }
}
