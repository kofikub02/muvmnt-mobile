import 'package:flutter/material.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class GroupedAvatars extends StatelessWidget {
  final List<String> imageUrls;
  final double avatarRadius;
  final double overlapOffset;

  const GroupedAvatars({
    super.key,
    required this.imageUrls,
    this.avatarRadius = 18,
    this.overlapOffset = 25,
  });

  @override
  Widget build(BuildContext context) {
    final double totalWidth =
        avatarRadius * 2.5 + (imageUrls.length - 1) * overlapOffset;

    return SizedBox(
      height: avatarRadius * 2.5,
      width: totalWidth,
      child: Stack(
        children: List.generate(imageUrls.length, (index) {
          return Positioned(
            left: index * overlapOffset,
            child: CircleAvatar(
              radius: avatarRadius + 2,
              child: SvgIcon(
                name: imageUrls[index],
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          );
        }),
      ),
    );
  }
}
