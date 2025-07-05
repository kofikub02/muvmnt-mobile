import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/core/util/string_utils.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';
import 'package:mvmnt_cli/features/addresses/presentation/widgets/address_label_field.dart';
import 'package:mvmnt_cli/features/location/domain/entities/geo_latlng_entity.dart';
import 'package:mvmnt_cli/features/addresses/presentation/cubits/saved/saved_addresses_cubit.dart';
import 'package:mvmnt_cli/features/addresses/presentation/cubits/saved/saved_addresses_state.dart';
import 'package:mvmnt_cli/features/addresses/presentation/pages/addresses_page.dart';
import 'package:mvmnt_cli/features/addresses/presentation/widgets/adjust_map_pin.dart';
import 'package:mvmnt_cli/features/location/presentation/cubit/location_service_cubit.dart';
import 'package:mvmnt_cli/features/location/presentation/cubit/location_service_state.dart';
import 'package:mvmnt_cli/ui/forms/custom_text_field.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';
import 'package:mvmnt_cli/ui/widgets/custom_bottom_navigation_bar.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class EditAddressPage extends StatefulWidget {

  const EditAddressPage({super.key, required this.address});
  final AddressEntity address;

  static const String route = '/${AddressesPage.route}/edit';

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  late final TextEditingController _labelController;
  late final TextEditingController _suiteController;
  late final TextEditingController _codeController;
  late final TextEditingController _buildingNameController;
  late final TextEditingController _instructionController;
  String? icon;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(
      text: widget.address.label?.toCapitalized,
    );
    _suiteController = TextEditingController(
      text: widget.address.apartmentSuite,
    );
    _codeController = TextEditingController(text: widget.address.entryCode);
    _buildingNameController = TextEditingController(
      text: widget.address.buildingName,
    );
    _instructionController = TextEditingController(
      text: widget.address.instructions,
    );
    icon = widget.address.icon;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SavedAddressesCubit, SavedAddressesState>(
      listener: (context, state) {
        if (state.status == SavedAddressesStatus.success) {
          context.pop();
        }
      },
      builder: (context, state) {
        final var isLoading = state.status == SavedAddressesStatus.loading;
        final var isUpdating = state.status == SavedAddressesStatus.updating;
        final var enableFields = !isLoading && !isUpdating;

        return Scaffold(
          appBar: CustomAppBar(
            title: 'Edit Address',
            actions: [
              BlocBuilder<LocationServiceCubit, LocationServiceState>(
                builder: (subContext, subState) {
                  final var isSelected =
                      subState.currentLocation != null &&
                      subState.currentLocation?.id == widget.address.id;

                  if (isSelected) {
                    return Container();
                  }

                  return IconButton(
                    onPressed:
                        isLoading
                            ? null
                            : () {
                              context.read<SavedAddressesCubit>().removeAddress(
                                widget.address.id,
                              );
                              context.pop();
                            },
                    icon: SvgIcon(name: 'trash'),
                  );
                },
              ),
            ],
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: BlocBuilder<LocationServiceCubit, LocationServiceState>(
                builder: (subContext, subState) {
                  final var isSelected =
                      subState.currentLocation != null &&
                      subState.currentLocation?.id == widget.address.id;

                  return ElevatedButton(
                    onPressed:
                        isUpdating
                            ? null
                            : () {
                              final address = widget.address.copyWith(
                                icon:
                                    _labelController.text
                                                .trim()
                                                .toLowerCase() ==
                                            'home'
                                        ? 'home'
                                        : _labelController.text
                                                .trim()
                                                .toLowerCase() ==
                                            'work'
                                        ? 'work'
                                        : icon,
                                label:
                                    _labelController.text.trim().toLowerCase(),
                                buildingName:
                                    _buildingNameController.text.trim(),
                                entryCode: _codeController.text.trim(),
                                apartmentSuite: _suiteController.text.trim(),
                                instructions:
                                    _instructionController.text.trim(),
                              );

                              context.read<SavedAddressesCubit>().updateAddress(
                                address,
                              );

                              if (isSelected) {
                                context
                                    .read<LocationServiceCubit>()
                                    .setCurrentAddress(address);
                              }
                            },
                    child:
                        isUpdating
                            ? const Center(
                              child: CircularProgressIndicator.adaptive(),
                            )
                            : const Text('Save Address'),
                  );
                },
              ),
            ),
          ),

          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.address.mainText,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.address.secondaryText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        onPressed:
                            icon == 'work' || icon == 'home'
                                ? null
                                : () async {
                                  final selectedIcon = await context
                                      .push<String?>(
                                        '/addresses/icon',
                                        extra: icon,
                                      );
                                  setState(() {
                                    icon = selectedIcon;
                                  });
                                },
                        icon: SvgIcon(
                          name:
                              (icon?.isEmpty ?? true) ? 'location-edit' : icon!,
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.1),
                  Row(
                    children: [
                      Flexible(
                        child: CustomTextField(
                          enabled: enableFields,
                          label: 'Apartment/Suite',
                          hintText: 'e.g. Unit 999',
                          controller: _suiteController,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: CustomTextField(
                          enabled: enableFields,
                          label: 'Entry Code',
                          controller: _codeController,
                        ),
                      ),
                    ],
                  ),
                  CustomTextField(
                    enabled: enableFields,
                    label: 'Building Name',
                    hintText: 'e.g. Stanbic Heights',
                    controller: _buildingNameController,
                  ),
                  AddressLabelField(
                    controller: _labelController,
                    onChanged: (value) {
                      if (value.isEmpty || value.length == 1) {
                        setState(() {});
                      }
                    },
                  ),
                  AdjustMapPin(
                    initialGeoPosition: GeoLatLngEntity(
                      lat: widget.address.lat,
                      lng: widget.address.lng,
                    ),
                  ),
                  CustomTextField(
                    enabled: enableFields,
                    maxLines: 4,
                    hintText: 'e.g. Hand it to me/Leave at my door',
                    label: 'Dropoff Instructions',
                    controller: _instructionController,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
