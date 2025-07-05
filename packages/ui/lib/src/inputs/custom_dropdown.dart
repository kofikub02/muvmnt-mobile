import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final bool enabled;
  final String label;
  final String selectedOption;
  final List<Map<String, String>> options;
  final ValueChanged<String> onChanged;

  const CustomDropdown({
    super.key,
    this.enabled = true,
    required this.options,
    required this.onChanged,
    required this.selectedOption,
    required this.label,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).inputDecorationTheme.fillColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Map<String, String>>(
              isExpanded: true,
              value: widget.options.firstWhere(
                (option) => option["code"] == widget.selectedOption,
                orElse: () => widget.options[0],
              ),
              selectedItemBuilder: (context) {
                return widget.options.map((country) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      country["display"]!,
                      textAlign: TextAlign.center,
                    ),
                  );
                }).toList();
              },
              items:
                  widget.options.map((option) {
                    return DropdownMenuItem<Map<String, String>>(
                      value: option,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                        ), // ✅ MORE HEIGHT
                        child: Text(option["label"]!),
                      ),
                    );
                  }).toList(),
              onChanged:
                  !widget.enabled
                      ? null
                      : (value) {
                        setState(() {
                          widget.onChanged(
                            widget.options.firstWhere(
                              (e) => e['code'] == value?['code'],
                            )['code']!,
                          );
                        });
                      },
            ),
          ),
        ),
      ],
    );
  }
}
