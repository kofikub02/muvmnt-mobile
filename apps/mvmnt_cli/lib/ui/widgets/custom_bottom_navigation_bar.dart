import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final Widget child;

  const CustomBottomNavigationBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
        decoration: BoxDecoration(border: Border(top: BorderSide(width: 0.1))),
        child: child,
      ),
    );
  }
}
