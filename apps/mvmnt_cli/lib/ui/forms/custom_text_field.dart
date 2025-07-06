import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? initialValue;
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLength;
  final int? maxLines;
  final bool enabled;
  final bool verified;
  final TextInputType keyboardType;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.label,
    this.initialValue,
    this.onChanged,
    this.controller,
    this.enabled = true,
    this.verified = false,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText = '',
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              if (verified) ...[
                Icon(
                  Icons.check_circle_outline,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
        ],
        TextFormField(
          initialValue: initialValue,
          controller: controller,
          onChanged: onChanged,
          enabled: enabled,
          focusNode: focusNode,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          buildCounter:
              (
                _, {
                required int currentLength,
                required bool isFocused,
                required int? maxLength,
              }) => null,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon:
                prefixIcon != null
                    ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(width: 20, height: 20, child: prefixIcon),
                    )
                    : null,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
