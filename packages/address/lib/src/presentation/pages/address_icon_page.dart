import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

const icons = ['home', 'work', 'school', 'gym', 'heart'];

class AddressIconPage extends StatefulWidget {

  const AddressIconPage({super.key, this.existingIcon});
  final String? existingIcon;

  @override
  State<AddressIconPage> createState() => _AddressIconPageState();
}

class _AddressIconPageState extends State<AddressIconPage> {
  final List<String> icons = [
    'business',
    'university',
    'gym',
    'store',
    'church',
    'popcorn',
    'factory',
    'heart',
    'cherry',
    'trees',
    'bubbles',
    'roller-coaster',
    'tent-tree',
    'flame',
  ];

  String? selectedIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Choose Icon for Address',
        toReturn: widget.existingIcon,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: icons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final iconName = icons[index];
            var selected =
                widget.existingIcon != null
                    ? widget.existingIcon == iconName
                    : false;

            return GestureDetector(
              onTap: () {
                context.pop(iconName);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      selected
                          ? Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.2)
                          : Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: SvgIcon(name: iconName),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
