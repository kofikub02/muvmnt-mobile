import 'package:flutter/material.dart';

class CustomDismissible extends StatelessWidget {
  final String id;
  final bool isDismissible;
  final Function onDismissed;
  final Widget child;

  const CustomDismissible({
    super.key,
    required this.id,
    required this.isDismissible,
    required this.child,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(id),
      direction:
          isDismissible ? DismissDirection.none : DismissDirection.endToStart,
      onDismissed:
          isDismissible
              ? null
              : (direction) {
                onDismissed();
              },
      background: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.error),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Delete',
                style: TextStyle(color: Theme.of(context).colorScheme.surface),
              ),
            ),
          ],
        ),
      ),
      child: child,
    );
  }
}
