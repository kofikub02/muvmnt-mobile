import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/core/util/device/device_utility.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/constants/constants.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/methods/payment_methods_cubit.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/methods/payment_methods_state.dart';
import 'package:mvmnt_cli/ui/forms/custom_dropdown.dart';
import 'package:mvmnt_cli/ui/forms/custom_phone_field.dart';

class MobileMoneyTile extends StatelessWidget {
  const MobileMoneyTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgIcon(name: 'smartphone'),
      title: Text('Mobile Money'),
      trailing: SvgIcon(name: 'chevron-right'),
      onTap: () async {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder:
              (context) => _AddMobileMoneySheetContent(
                key: Key('_add_mobile_money_sheet'),
              ),
        );
      },
    );
  }
}

class _AddMobileMoneySheetContent extends StatefulWidget {
  const _AddMobileMoneySheetContent({super.key});

  @override
  State<_AddMobileMoneySheetContent> createState() =>
      _AddMobileMoneySheetContentState();
}

class _AddMobileMoneySheetContentState
    extends State<_AddMobileMoneySheetContent> {
  late final TextEditingController _phoneNumberController;
  String _selectedNetwork = 'mtn';
  String _selectedCountryCode = "+233";

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _onNetworkChanged(String? value) {
    setState(() {
      _selectedNetwork = value ?? '';
    });
  }

  void _onCountryCodeChanged(String value) {
    setState(() {
      _selectedCountryCode = value;
    });
  }

  void _onSave() {
    // final newPaymentMethod = PaymentMethodEntity(
    //   id: '$_selectedNetwork${_phoneNumberController.text}',
    //   icon: _selectedNetwork,
    //   name:
    //       mobileMoneyNetworks.firstWhere(
    //         (network) => network['code'] == _selectedNetwork,
    //         orElse: () => {},
    //       )['display']!,
    //   meta: '$_selectedCountryCode${_phoneNumberController.text}',
    //   type: PaymentMethodType.momo,
    // );
    // context.read<PaymentMethodsCubit>().addMethod(newPaymentMethod);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentMethodsCubit, PaymentMethodsState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == PaymentMethodsStatus.updated) {
          context.pop(context);
        }
      },
      builder: (context, state) {
        bool isUpdating = state.status == PaymentMethodsStatus.loading;

        return Padding(
          padding: EdgeInsets.only(
            bottom: TDeviceUtils.getKeyboardHeight(context),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add mobile money',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
                          child: SvgIcon(name: 'x'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        flex: 1,
                        child: CustomDropdown(
                          enabled: !isUpdating,
                          label: "Network Provider",
                          options: mobileMoneyNetworks,
                          onChanged: _onNetworkChanged,
                          selectedOption: _selectedNetwork,
                        ),
                      ),
                    ],
                  ),
                  CustomPhoneField(
                    enabled: !isUpdating,
                    selectedCountryCode: _selectedCountryCode,
                    phoneNumberController: _phoneNumberController,
                    onCountryChanged: _onCountryCodeChanged,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'By providing your mobile money information, you allow Muvmnt to charge your wallet for future payments in accordance with their terms.',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isUpdating ? null : _onSave,
                        child:
                            isUpdating
                                ? CircularProgressIndicator.adaptive()
                                : Text('Save'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
