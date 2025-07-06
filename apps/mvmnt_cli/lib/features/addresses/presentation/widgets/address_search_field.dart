import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/constants/tags.dart';
import 'package:mvmnt_cli/features/location/presentation/cubit/location_service_cubit.dart';
import 'package:mvmnt_cli/features/location/presentation/cubit/location_service_state.dart';
import 'package:mvmnt_cli/ui/forms/custom_text_field.dart';
import 'package:mvmnt_cli/ui/widgets/search_suffix_icon.dart';
import 'package:mvmnt_cli/features/addresses/presentation/cubits/address_search/address_search_cubit.dart';
import 'package:mvmnt_cli/features/addresses/presentation/cubits/address_search/address_search_state.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class AddressSearchField extends StatefulWidget {
  final bool enabled;
  final FocusNode? focusNode;

  const AddressSearchField({super.key, this.enabled = true, this.focusNode});

  @override
  State<AddressSearchField> createState() => _AddressSearchFieldState();
}

class _AddressSearchFieldState extends State<AddressSearchField> {
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
    return BlocBuilder<LocationServiceCubit, LocationServiceState>(
      builder: (context, state) {
        String? country =
            state.placemark != null
                ? state.placemark!.isoCountryCode?.toLowerCase()
                : '';

        return BlocBuilder<AddressSearchCubit, AddressSearchState>(
          builder: (context, state) {
            final isLoading = state.status == AddressSearchStatus.loading;

            return Hero(
              tag: ADDRESS_SEARCH_TAG,
              child: Material(
                child: CustomTextField(
                  enabled: widget.enabled,
                  controller: _controller,
                  hintText: 'Search for an address',
                  prefixIcon: SvgIcon(name: 'search'),
                  suffixIcon: SearchSuffixIcon(
                    isLoading: isLoading,
                    hasText: _controller.text.isNotEmpty,
                    action: () {
                      _controller.clear();
                      context.read<AddressSearchCubit>().clear();
                    },
                  ),
                  keyboardType: TextInputType.streetAddress,
                  focusNode: widget.focusNode,
                  onChanged: (value) {
                    context.read<AddressSearchCubit>().updateQuery(
                      value,
                      country,
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
