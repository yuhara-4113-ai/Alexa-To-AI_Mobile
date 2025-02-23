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

  // Stateを無駄に再構築しないようにconstで定義
  static const _inputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
  );

  @override
  Widget build(BuildContext context) {
    // selectedがoptions内に存在しなければ、options.firstを使用する
    final selectedViewValue =
        options.contains(selected) ? selected : options.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 6.0),
        DropdownButtonFormField<String>(
          decoration: _inputDecoration,
          value: selectedViewValue,
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
