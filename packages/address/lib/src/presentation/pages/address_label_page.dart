import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';
import 'package:mvmnt_cli/features/addresses/presentation/cubits/saved/saved_addresses_cubit.dart';
import 'package:mvmnt_cli/features/addresses/presentation/widgets/address_label_field.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';
import 'package:mvmnt_cli/ui/widgets/custom_bottom_navigation_bar.dart';
import 'package:mvmnt_cli/ui/widgets/info_card.dart';

class AddressLabelPage extends StatefulWidget {
  final AddressEntity address;

  const AddressLabelPage({super.key, required this.address});

  @override
  State<AddressLabelPage> createState() => _AddressLabelPageState();
}

class _AddressLabelPageState extends State<AddressLabelPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Set Address Label'),
      bottomNavigationBar: CustomBottomNavigationBar(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed:
                _controller.text.isNotEmpty
                    ? () {
                      context.read<SavedAddressesCubit>().saveAddress(
                        widget.address.copyWith(
                          label: _controller.text,
                          origin: AddressOriginType.labelled,
                        ),
                      );
                      context.pop();
                    }
                    : null,
            child: Text('Save'),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            AddressLabelField(
              controller: _controller,
              onChanged: (value) {
                if (value.isEmpty || value.length == 1) {
                  setState(() {});
                }
              },
            ),
            SizedBox(height: 16),
            InfoCard(
              info:
                  'Your labeled addresses are used to personalize your experience across Muvmnt. Only you can see the label and you can unset it anytime',
            ),
          ],
        ),
      ),
    );
  }
}
