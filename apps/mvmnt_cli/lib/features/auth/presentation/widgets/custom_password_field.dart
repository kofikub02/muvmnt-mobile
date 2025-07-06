import 'package:flutter/material.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class CustomPasswordField extends StatefulWidget {
  final bool enabled;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const CustomPasswordField({
    super.key,
    this.enabled = true,
    this.controller,
    this.onChanged,
  });

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          "Password",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 6),
        TextFormField(
          enabled: widget.enabled,
          controller: widget.controller,
          onChanged: widget.onChanged,
          obscureText: _obscure,
          obscuringCharacter: '*',
          decoration: InputDecoration(
            suffixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                    child: SvgIcon(name: _obscure ? 'eye' : 'eye-off'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
