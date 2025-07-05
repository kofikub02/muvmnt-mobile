import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;
  final bool hasIntrinsic;

  const SvgIcon({
    super.key,
    required this.name,
    this.color,
    this.size = 22,
    this.hasIntrinsic = false,
  });

  @override
  Widget build(BuildContext context) {
    if (hasIntrinsic) {
      return SizedBox(
        width: 25,
        height: 28,
        child: SvgPicture.asset(
          'assets/icons/$name.svg',
          width: size,
          height: size,
        ),
      );
    }

    return SvgPicture.asset(
      'assets/icons/$name.svg',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        color ?? Theme.of(context).colorScheme.onSurface,
        BlendMode.srcIn,
      ),
    );
  }
}
