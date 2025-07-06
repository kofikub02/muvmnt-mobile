import 'package:flutter/material.dart';
import 'package:mvmnt_cli/core/util/device/device_utility.dart';
import 'package:mvmnt_cli/features/orders/presentation/widgets/completed_order_card.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Tab> _tabs = const [Tab(text: 'Ongoing'), Tab(text: 'Complete')];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 10 + TDeviceUtils.getStatusBarHeight(context),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Orders',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(onPressed: () {}, icon: SvgIcon(name: 'info')),
                  ],
                ),
                SizedBox(height: 12),
                TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  tabs: _tabs,
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Center(child: Text('Upcoming')),
                ListView.builder(
                  itemCount: 11,
                  itemBuilder: (context, index) {
                    return CompletedOrderCard(onSelected: () {});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
