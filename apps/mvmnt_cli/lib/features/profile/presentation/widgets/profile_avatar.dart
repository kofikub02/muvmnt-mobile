import 'package:flutter/material.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class ProfileAvatar extends StatelessWidget {
  final String? firstName;
  final String? imageUrl;

  const ProfileAvatar({
    super.key,
    required this.firstName,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(radius: 32, backgroundImage: NetworkImage(imageUrl!));
    }

    if (firstName != null && firstName!.isNotEmpty) {
      return CircleAvatar(
        radius: 32,
        child: Text(
          firstName![0].toUpperCase(),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      );
    }

    return CircleAvatar(
      radius: 32,
      child: SvgIcon(
        name: 'user',
        size: 32,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
