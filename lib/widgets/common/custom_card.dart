import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Column column;

  const CustomCard({super.key, required this.column});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: column,
      ),
    );
  }
}
