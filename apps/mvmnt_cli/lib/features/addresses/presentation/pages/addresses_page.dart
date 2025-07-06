import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';
import 'package:mvmnt_cli/features/addresses/presentation/widgets/saved_addresses_list.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/authentication/authentication_cubit.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/authentication/authentication_state.dart';
import 'package:mvmnt_cli/features/location/presentation/cubit/location_service_cubit.dart';
import 'package:mvmnt_cli/features/addresses/presentation/cubits/saved/saved_addresses_cubit.dart';
import 'package:mvmnt_cli/features/addresses/presentation/widgets/address_search_field.dart';
import 'package:mvmnt_cli/features/addresses/presentation/widgets/labeled_addresses.dart';
import 'package:mvmnt_cli/features/location/presentation/widgets/use_current_location.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});

  static const String route = '/addresses';

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Addresses'),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: GestureDetector(
                onTap: () async {
                  var selected = await context.push<AddressEntity?>(
                    '/addresses/search',
                    extra: 'Search Address',
                  );

                  if (selected != null) {
                    _onSelectAddress(selected, true);
                  }
                },
                child: AddressSearchField(enabled: false),
              ),
            ),
            BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, state) {
                print(state.authEntity);
                if (state.authEntity?.isAnonymous == false) {
                  return LabeledAddresses();
                } else {
                  return Container();
                }
              },
            ),
            Expanded(
              child: ListView(
                children: [
                  BlocBuilder<AuthenticationCubit, AuthenticationState>(
                    builder: (context, state) {
                      print(state.authEntity);
                      if (state.authEntity?.isAnonymous == false) {
                        return UseCurrentLocation(
                          onSelect: (address) {
                            _onSelectAddress(address, false);
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  SavedAddressesList(
                    canEdit: true,
                    onSelect: (address) {
                      _onSelectAddress(address, true);
                    },
                  ),
                ],
              ),
            ),
            // Expanded(child: AddressSelectOptions()),
          ],
        ),
      ),
    );
  }

  void _onSelectAddress(AddressEntity address, bool add) {
    if (add) {
      context.read<SavedAddressesCubit>().addToAddressHistory(address);
    }
    context.read<LocationServiceCubit>().setCurrentAddress(address);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
