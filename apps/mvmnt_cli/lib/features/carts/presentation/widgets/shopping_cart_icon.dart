import 'package:flutter/material.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class ShoppingCartIcon extends StatelessWidget {
  const ShoppingCartIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(onPressed: () {}, icon: SvgIcon(name: 'shopping-cart')),
      ],
    );
  }
}
