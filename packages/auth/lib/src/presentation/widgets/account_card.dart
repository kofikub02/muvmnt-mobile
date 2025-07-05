import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Row(
            children: [
              SvgIcon(name: 'account', size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "You're missing out on credits and discounts. Tap below to unlock premium features.",
                  overflow: TextOverflow.visible,
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.push('/anonymous');
              },
              child: Text('Unlock credits →'),
            ),
          ),
        ],
      ),
    );
  }
}
