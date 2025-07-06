import 'package:flutter/material.dart';
import 'package:mvmnt_cli/core/constants/tags.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function? onPressed;
  final List<Widget>? actions;
  final dynamic toReturn;
  final bool showBorder;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onPressed,
    this.toReturn,
    this.actions,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: APP_BAR_TAG,
      child: Material(
        child: AppBar(
          shape: showBorder ? null : Border(bottom: BorderSide.none),
          leading: IconButton(
            onPressed: () {
              if (onPressed != null) {
                onPressed!();
              }
              Navigator.pop(context, toReturn);
            },
            icon: SvgIcon(name: 'arrow-left'),
          ),
          title: Text(title),
          actions: actions,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
