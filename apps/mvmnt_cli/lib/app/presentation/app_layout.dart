import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class AppLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 0.1,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: navigationShell.goBranch,
          animationDuration: Duration(milliseconds: 400),
          destinations:
              destinations
                  .map(
                    (destination) => NavigationDestination(
                      icon: destination.icon,
                      selectedIcon: destination.selectedIcon,
                      label: destination.label,
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}

class Destination {
  final String label;
  final Widget icon;
  final Widget? selectedIcon;

  const Destination({
    required this.label,
    required this.icon,
    this.selectedIcon,
  });
}

const destinations = [
  Destination(
    label: 'Home',
    icon: SvgIcon(name: 'home'),
    selectedIcon: SvgIcon(name: 'home', color: Color(0xFF00D097)),
  ),
  Destination(
    label: 'Activity',
    icon: SvgIcon(name: 'receipt-text'),
    selectedIcon: SvgIcon(name: 'receipt-text', color: Color(0xFF00D097)),
  ),
  Destination(
    label: 'Account',
    icon: SvgIcon(name: 'account'),
    selectedIcon: SvgIcon(name: 'account', color: Color(0xFF00D097)),
  ),
];
