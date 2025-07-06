import 'package:flutter/material.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class AccessWidget extends StatelessWidget {
  final String title;
  final String description;
  final String status;
  final bool loading;
  final Function onTap;

  const AccessWidget({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Divider(thickness: 0.1),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12),
        Text(
          description,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        InkWell(
          onTap: () {
            onTap();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                Text(title),
                if (loading) ...[
                  SizedBox(width: 4),
                  CircularProgressIndicator.adaptive(),
                ],
                Spacer(),
                Text(status),
                SizedBox(width: 4),
                SvgIcon(name: 'chevron-right'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
