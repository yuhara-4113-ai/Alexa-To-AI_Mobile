import 'package:flutter/material.dart';

class LabeledDropdownField extends StatelessWidget {
  final String label;
  final String selected;
  final List<String> options;
  final void Function(String?) onChanged;

  const LabeledDropdownField(
      {super.key,
      required this.label,
      required this.options,
      required this.selected,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 6.0),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            // 高さを調整
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          ),
          value: selected,
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
