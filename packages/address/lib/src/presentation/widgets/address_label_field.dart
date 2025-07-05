import 'package:flutter/material.dart';
import 'package:mvmnt_cli/ui/forms/custom_text_field.dart';
import 'package:mvmnt_cli/ui/widgets/search_suffix_icon.dart';

class AddressLabelField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const AddressLabelField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: 'Address label',
      controller: controller,
      hintText: 'e.g. Home, Work, Church',
      suffixIcon: SearchSuffixIcon(
        isLoading: false,
        hasText: controller.text.isNotEmpty,
        action: () {
          controller.clear();
        },
      ),
      onChanged: onChanged,
    );
  }
}
