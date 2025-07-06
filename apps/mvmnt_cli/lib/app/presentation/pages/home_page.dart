import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/core/util/device/device_utility.dart';
import 'package:mvmnt_cli/features/carts/presentation/widgets/shopping_cart_icon.dart';
import 'package:mvmnt_cli/features/location/presentation/widgets/current_location_display.dart';
import 'package:mvmnt_cli/features/notifications/presentation/cubits/notifications_service/notification_service_cubit.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/current/current_payment_cubit.dart';
import 'package:mvmnt_cli/features/vendors/presentation/pages/nearby_vendors_map_page.dart';
import 'package:mvmnt_cli/ui/forms/custom_text_field.dart';
import 'package:mvmnt_cli/ui/widgets/dismiss_keyboard.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String route = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initPlugin());
    context.read<NotificationServiceCubit>().requestNotificationPermission();
    context.read<CurrentPaymentCubit>().getDefaultPaymentMethod();
  }

  Future<void> _initPlugin() async {
    await TDeviceUtils.requestTracking();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              toolbarHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ), // lifts off the bottom
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: CurrentLocationDisplay()),
                          const SizedBox(width: 50),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [ShoppingCartIcon()],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: TextEditingController(),
                              hintText: "Search 'Sneakers'",
                              prefixIcon: SvgIcon(name: 'search'),
                              keyboardType: TextInputType.streetAddress,
                              // focusNode: widget.focusNode,
                              onChanged: (value) {},
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            onPressed: () {
                              context.push(NearbyVendorsMapPage.route);
                            },
                            icon: SvgIcon(name: 'map'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
