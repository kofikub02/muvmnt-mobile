import 'package:flutter/material.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class SearchSuffixIcon extends StatelessWidget {
  final bool isLoading;
  final bool hasText;
  final Function? action;

  const SearchSuffixIcon({
    super.key,
    required this.isLoading,
    required this.hasText,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isLoading) ...{
            Center(
              child: SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
              ),
            ),
          } else if (hasText) ...{
            GestureDetector(
              onTap:
                  action != null
                      ? () {
                        action!();
                      }
                      : null,
              child: SvgIcon(name: 'circle-x'),
            ),
          },
        ],
      ),
    );
  }
}
