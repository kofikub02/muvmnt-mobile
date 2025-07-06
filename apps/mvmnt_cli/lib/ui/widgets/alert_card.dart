import 'package:flutter/material.dart';
import 'package:mvmnt_cli/core/theme/app_colors.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class AlertCard extends StatelessWidget {
  final String alertText;
  final Function? onTap;

  const AlertCard({super.key, required this.alertText, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap == null
              ? null
              : () {
                onTap!();
              },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: AppColors.alertDart.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          children: [
            SvgIcon(name: 'alert'),
            SizedBox(width: 8),
            Text(alertText),
            Spacer(),
            SvgIcon(name: 'chevron-right'),
          ],
        ),
      ),
    );
  }
}
