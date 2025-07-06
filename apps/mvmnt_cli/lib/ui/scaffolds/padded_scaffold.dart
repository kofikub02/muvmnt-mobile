import 'package:flutter/material.dart';

class PaddedPoppableScaffold extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const PaddedPoppableScaffold({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(child: Padding(padding: padding, child: child)),
    );
  }
}
