import 'package:flutter/material.dart';
import 'package:mvmnt_cli/core/resources/value_objects.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class ItemRating extends StatelessWidget {
  final Rating? rating;

  const ItemRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgIcon(
            name: 'star',
            color: Theme.of(context).colorScheme.primary,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            (rating?.average ?? 5).toStringAsFixed(1),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
