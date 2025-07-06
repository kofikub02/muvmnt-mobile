import 'package:flutter/material.dart';

class PageDescription extends StatelessWidget {
  final String description;

  const PageDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Text(description, style: TextStyle(fontSize: 14));
  }
}
