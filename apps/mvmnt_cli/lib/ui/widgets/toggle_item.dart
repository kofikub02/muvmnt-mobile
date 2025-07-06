import 'package:flutter/material.dart';

class ToggleItem extends StatelessWidget {
  final String item;
  final bool value;
  final bool loading;
  final Function(bool) onChanged;

  const ToggleItem({
    super.key,
    required this.item,
    required this.value,
    this.loading = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Text(item, style: Theme.of(context).textTheme.bodyLarge),
          if (loading) ...[
            SizedBox(width: 8),
            CircularProgressIndicator.adaptive(),
          ],
          Spacer(),
          Switch(
            value: value,
            onChanged: (newValue) {
              onChanged(newValue);
            },
          ),
        ],
      ),
    );
  }
}
