import 'package:flutter/material.dart';

class LabeledInputField extends StatelessWidget {
  final String label;
  final String placeholder;
  final bool obscureText;
  final TextEditingController controller;
  final Widget? suffixIcon;

  const LabeledInputField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8.0),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            // 高さを調整
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
            hintText: placeholder,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
