import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/core/util/string_utils.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';
import 'package:mvmnt_cli/features/addresses/presentation/cubits/saved/saved_addresses_cubit.dart';
import 'package:mvmnt_cli/features/addresses/presentation/cubits/saved/saved_addresses_state.dart';
import 'package:mvmnt_cli/features/location/presentation/cubit/location_service_cubit.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class LabeledAddresses extends StatefulWidget {
  const LabeledAddresses({super.key});

  @override
  State<LabeledAddresses> createState() => _LabeledAddressesState();
}

class _LabeledAddressesState extends State<LabeledAddresses> {
  @override
  void initState() {
    context.read<SavedAddressesCubit>().loadLabeledAddresses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedAddressesCubit, SavedAddressesState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.only(top: 4, bottom: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 0.1,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          child: SizedBox(
            height: 45,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.labelledAddresses.length + 1,
              itemBuilder: (context, index) {
                if (index == state.labelledAddresses.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9),
                    child: TextButton.icon(
                      onPressed: _createNewLabelled,
                      icon: SvgIcon(name: 'plus'),
                      label: Text('Add label', style: TextStyle(fontSize: 12)),
                    ),
                  );
                }

                var address = state.labelledAddresses[index];
                return _LabelledAddressCard(
                  key: Key(address.id),
                  address: address,
                );
              },
              separatorBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: VerticalDivider(thickness: 0.5, color: Colors.grey),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _createNewLabelled() async {
    // Shouldnt be popped
    var selectedAddress = await context.push<AddressEntity?>(
      '/addresses/search',
      extra: 'Choose Address for Label',
    );

    if (selectedAddress == null) return;

    context.push('/addresses/label', extra: selectedAddress);
  }
}

class _LabelledAddressCard extends StatefulWidget {
  final AddressEntity address;

  const _LabelledAddressCard({super.key, required this.address});

  @override
  State<_LabelledAddressCard> createState() => _LabelledAddressCardState();
}

class _LabelledAddressCardState extends State<_LabelledAddressCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: _onLabelAddressCardPressed,
        onLongPress: _onLabelAddressCardLongPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SvgIcon(
                name:
                    widget.address.icon.isEmpty
                        ? 'map-pin'
                        : widget.address.icon,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.address.label?.toCapitalized ?? '',
                  style: TextStyle(fontWeight: FontWeight.w700, height: 1),
                ),
                SizedBox(
                  width: 90,
                  child: Text(
                    widget.address.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onLabelAddressCardPressed() async {
    if (widget.address.mainText.isEmpty) {
      var selected = await context.push<AddressEntity?>(
        '/addresses/search',
        extra: 'Edit Address for Label',
      );

      if (selected == null) return;

      selected = widget.address.copyWith(
        description: selected.description,
        mainText: selected.mainText,
        secondaryText: selected.secondaryText,
        lat: selected.lat,
        lng: selected.lng,
      );

      context.read<SavedAddressesCubit>().saveAddress(selected);
    } else {
      context.read<LocationServiceCubit>().setCurrentAddress(widget.address);
      context.read<SavedAddressesCubit>().addToAddressHistory(widget.address);
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Future<void> _onLabelAddressCardLongPressed() async {
    if (widget.address.description.isNotEmpty &&
        widget.address.mainText.isNotEmpty) {
      context.push('/addresses/edit', extra: widget.address);
    }
  }
}
