import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String info;

  const InfoCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Text(info),
    );
  }
}
