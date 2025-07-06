import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/ui/map/bottom_sliding_panel.dart';
import 'package:mvmnt_cli/ui/map/map_screen.dart';

class OrderDetailPage extends StatefulWidget {
  static const String route = '/order';

  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [MapScreen(), BottomSlidingPanel()],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [],
        ),
        onPressed: () {
          context.pop(context);
        },
      ),
    );
  }
}
