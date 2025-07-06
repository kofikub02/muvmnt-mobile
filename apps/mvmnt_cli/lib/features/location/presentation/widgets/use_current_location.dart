import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';
import 'package:mvmnt_cli/features/location/presentation/cubit/location_service_cubit.dart';
import 'package:mvmnt_cli/features/location/presentation/cubit/location_service_state.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class UseCurrentLocation extends StatefulWidget {
  final Function(AddressEntity) onSelect;

  const UseCurrentLocation({super.key, required this.onSelect});

  @override
  State<UseCurrentLocation> createState() => _UseCurrentLocationState();
}

class _UseCurrentLocationState extends State<UseCurrentLocation>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    context.read<LocationServiceCubit>().requestLocationServiceState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<LocationServiceCubit>().requestLocationServiceState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationServiceCubit, LocationServiceState>(
      listenWhen:
          (previous, current) =>
              previous.currentLocation != current.currentLocation,
      listener: (context, state) {
        if (state.currentLocation != null &&
            state.currentLocation?.origin == AddressOriginType.nearby) {
          widget.onSelect(state.currentLocation!);
        }
      },
      builder: (context, state) {
        var isLoading = state.status == LocationServiceStatus.loading;
        var isSelected =
            (state.isLocationEnabled != null && state.isLocationEnabled!) &&
            state.currentLocation?.origin == AddressOriginType.nearby;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Text(
                'Explore nearby',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
            ListTile(
              selected: isSelected,
              leading: SvgIcon(
                name: 'compass',
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
              ),
              title: Text(
                '${isSelected ? 'Using' : 'Use'} current location',
                style: TextStyle(
                  color:
                      isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                state.status == LocationServiceStatus.success
                    ? state.isLocationEnabled != null &&
                            state.isLocationEnabled == true
                        ? state.currentLocation?.origin !=
                                AddressOriginType.nearby
                            ? 'Add your address later'
                            : state.currentLocation?.description ??
                                'Your current location is active'
                        : 'Enable location services'
                    : 'Fetching...',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              trailing:
                  isLoading
                      ? CircularProgressIndicator.adaptive()
                      : (state.isLocationEnabled ?? false)
                      ? null
                      : SvgIcon(name: 'chevron-right'),
              onTap:
                  isLoading
                      ? null
                      : () {
                        if (state.isLocationEnabled != null &&
                            state.isLocationEnabled!) {
                          context
                              .read<LocationServiceCubit>()
                              .useCurrentLocationSelected();
                        } else {
                          context
                              .read<LocationServiceCubit>()
                              .onLocationAccessPressed();
                        }
                      },
            ),
          ],
        );
      },
    );
  }
}
