import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/features/orders/presentation/pages/order_detail_page.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class CompletedOrderCard extends StatelessWidget {
  final Function onSelected;

  const CompletedOrderCard({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                SvgIcon(
                  name: 'store',
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8),
                Text('Salut Rice', style: TextStyle(fontSize: 15)),
                Spacer(),
                SvgIcon(name: 'chevron-right'),
              ],
            ),
          ),
          Divider(thickness: 0.1),
          GestureDetector(
            onTap: () {
              onSelected('orderId');
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'Friday, May 2 · \$123.48 · 15 items',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
                Text(
                  'AirStride Runner (LTW) · UrbanFlex Loafers · TrailBlaze Hiker (WTP) · CloudStep Sneakers (MEM) · RetroKicks 90s · LuxeWalk Derby (PRS) · StreetGrip Skate',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: Text('Reorder', style: TextStyle(fontSize: 14)),
              ),
              SizedBox(width: 4),
              TextButton(
                onPressed: () {
                  context.push(OrderDetailPage.route);
                },
                child: Text('View receipt', style: TextStyle(fontSize: 14)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
