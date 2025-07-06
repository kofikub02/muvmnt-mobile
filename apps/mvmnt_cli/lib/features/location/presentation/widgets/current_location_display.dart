import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/core/util/string_utils.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';
import 'package:mvmnt_cli/features/location/presentation/cubit/location_service_cubit.dart';
import 'package:mvmnt_cli/features/location/presentation/cubit/location_service_state.dart';
import 'package:mvmnt_cli/features/addresses/presentation/cubits/saved/saved_addresses_cubit.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class CurrentLocationDisplay extends StatefulWidget {
  const CurrentLocationDisplay({super.key});

  @override
  State<CurrentLocationDisplay> createState() => _CurrentLocationDisplayState();
}

class _CurrentLocationDisplayState extends State<CurrentLocationDisplay> {
  @override
  void initState() {
    super.initState();
    context.read<LocationServiceCubit>().getCurrentAddress();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationServiceCubit, LocationServiceState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == LocationServiceStatus.success &&
            state.currentLocation == null) {
          // context.push('/addresses');
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            var selectedAddress = await context.push<AddressEntity>(
              '/addresses',
              extra: state.currentLocation,
            );
            if (selectedAddress != null) {
              _onSelectAddressSuggestion(selectedAddress);
            }
          },
          child: IntrinsicWidth(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                state.currentLocation == null
                    ? SvgIcon(name: 'map-pin')
                    : SvgIcon(
                      name:
                          state.currentLocation!.icon.isEmpty
                              ? 'map-pin'
                              : state.currentLocation!.icon,
                    ),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    state.status == LocationServiceStatus.fetching
                        ? 'Loading...'
                        : (state.currentLocation != null &&
                            (state.currentLocation!.label?.isNotEmpty ?? false))
                        ? state.currentLocation!.label!.toCapitalized
                        : state.currentLocation?.description ??
                            'Set current location',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                const SizedBox(width: 2),
                SvgIcon(name: 'chevron-down'),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onSelectAddressSuggestion(AddressEntity selected) {
    context.read<LocationServiceCubit>().setCurrentAddress(selected);
    context.read<SavedAddressesCubit>().addToAddressHistory(selected);
  }
}
