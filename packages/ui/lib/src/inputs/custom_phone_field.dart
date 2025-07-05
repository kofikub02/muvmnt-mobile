import 'package:flutter/material.dart';
import 'custom_dropdown.dart';
import 'custom_text_field.dart';

class CustomPhoneField extends StatelessWidget {
  final bool enabled;
  final bool verified;
  final String? selectedCountryCode;
  final String? initialPhoneNumber;
  final TextEditingController? phoneNumberController;
  final ValueChanged<String> onCountryChanged;
  final ValueChanged<String>? onPhoneChanged;
  final FocusNode? focusNode;
  final List<Map<String, String>> options;

  const CustomPhoneField({
    super.key,
    this.enabled = true,
    this.verified = false,
    required this.selectedCountryCode,
    this.initialPhoneNumber,
    this.phoneNumberController,
    required this.onCountryChanged,
    this.onPhoneChanged,
    this.focusNode,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: CustomDropdown(
            enabled: enabled,
            label: "Country",
            options: [],
            onChanged: onCountryChanged,
            selectedOption: selectedCountryCode ?? '',
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          flex: 2,
          child: CustomTextField(
            enabled: enabled,
            focusNode: focusNode,
            verified: verified,
            label: "Phone Number",
            controller: phoneNumberController,
            initialValue: initialPhoneNumber,
            keyboardType: TextInputType.phone,
            onChanged: onPhoneChanged,
          ),
        ),
      ],
    );
  }
}
