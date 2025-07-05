import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/features/addresses/presentation/cubits/address_search/address_search_cubit.dart';
import 'package:mvmnt_cli/features/addresses/presentation/cubits/address_search/address_search_state.dart';
import 'package:mvmnt_cli/features/addresses/presentation/widgets/address_search_field.dart';
import 'package:mvmnt_cli/features/addresses/presentation/widgets/saved_addresses_list.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';

class AddressSearchPage extends StatefulWidget {

  const AddressSearchPage({super.key, required this.title});
  final String title;

  @override
  State<AddressSearchPage> createState() => _AddressSearchPageState();
}

class _AddressSearchPageState extends State<AddressSearchPage> {
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        onPressed: () {
          context.read<AddressSearchCubit>().clear();
          FocusScope.of(context).unfocus();
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color:
                        Theme.of(
                          context,
                        ).colorScheme.onSurface, // customize color
                    width: 0.1, // customize thickness
                  ),
                ),
              ),
              child: AddressSearchField(focusNode: _searchFocusNode),
            ),
            Expanded(
              child: BlocConsumer<AddressSearchCubit, AddressSearchState>(
                listenWhen:
                    (previous, current) =>
                        previous.selectedAddress != current.selectedAddress,
                listener: (context, state) {
                  if (state.selectedAddress != null) {
                    Navigator.of(context).pop(state.selectedAddress);
                  }
                },
                builder: (context, state) {
                  var loading = state.status == AddressSearchStatus.loading;

                  if (state.addressSuggestions.isEmpty) {
                    return ListView(
                      children: [
                        SavedAddressesList(
                          canEdit: false,
                          onSelect:
                              loading
                                  ? null
                                  : (address) {
                                    Navigator.of(context).pop(address);
                                  },
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.addressSuggestions.length,
                    itemBuilder: (context, index) {
                      final suggestedAddress = state.addressSuggestions[index];

                      return ListTile(
                        title: Text(suggestedAddress.mainText),
                        subtitle: Text(suggestedAddress.secondaryText),
                        leading: const Icon(Icons.location_on_outlined),
                        trailing: const Icon(Icons.chevron_right),
                        onTap:
                            loading
                                ? null
                                : () {
                                  context
                                      .read<AddressSearchCubit>()
                                      .selectAddress(suggestedAddress);
                                },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
