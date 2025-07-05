import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/core/constants/tags.dart';
import 'package:mvmnt_cli/core/util/string_utils.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';
import 'package:mvmnt_cli/features/addresses/presentation/cubits/saved/saved_addresses_cubit.dart';
import 'package:mvmnt_cli/features/addresses/presentation/cubits/saved/saved_addresses_state.dart';
import 'package:mvmnt_cli/features/location/presentation/cubit/location_service_cubit.dart';
import 'package:mvmnt_cli/features/location/presentation/cubit/location_service_state.dart';
import 'package:mvmnt_cli/ui/widgets/custom_dismissible.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class SavedAddressesList extends StatefulWidget {
  final bool canEdit;
  final Function(AddressEntity)? onSelect;

  const SavedAddressesList({
    super.key,
    required this.onSelect,
    required this.canEdit,
  });

  @override
  State<SavedAddressesList> createState() => _SavedAddressesListState();
}

class _SavedAddressesListState extends State<SavedAddressesList> {
  @override
  void initState() {
    context.read<SavedAddressesCubit>().loadSavedAddresses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedAddressesCubit, SavedAddressesState>(
      builder: (context, state) {
        if (state.addresses.isEmpty) {
          return Container();
        }

        return BlocBuilder<LocationServiceCubit, LocationServiceState>(
          builder: (subContext, subState) {
            return Hero(
              tag: SAVED_ADDRESSES_TAG,
              child: Material(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Text(
                          'Saved addresses',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      ...state.addresses.map((address) {
                        bool isSelected =
                            subState.currentLocation != null &&
                            subState.currentLocation?.id == address.id;
                        return CustomDismissible(
                          id: address.id,
                          isDismissible: isSelected,
                          onDismissed: () {
                            context.read<SavedAddressesCubit>().removeAddress(
                              address.id,
                            );
                          },
                          child: ListTile(
                            selected: isSelected,
                            leading: SvgIcon(
                              name:
                                  address.icon.isEmpty
                                      ? 'map-pin'
                                      : address.icon,
                              color:
                                  isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface,
                            ),

                            title: Text(
                              address.label != null && address.label!.isNotEmpty
                                  ? address.label!.toCapitalized
                                  : address.mainText,
                            ),
                            subtitle: Text(
                              address.label != null && address.label!.isNotEmpty
                                  ? address.description
                                  : address.secondaryText,
                              overflow:
                                  TextOverflow
                                      .ellipsis, // Truncate with ellipsis
                              maxLines: 1,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            trailing:
                                widget.canEdit
                                    ? GestureDetector(
                                      onTap: () {
                                        context.push(
                                          '/addresses/edit',
                                          extra: address,
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        child: SvgIcon(name: 'pencil'),
                                      ),
                                    )
                                    : null,
                            onTap: () {
                              if (widget.onSelect != null) {
                                widget.onSelect!(address);
                              }
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
