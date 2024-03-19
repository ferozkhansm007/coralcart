import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.label,
      required this.validate});

  final TextEditingController controller;
  final String hintText;
  final String label;
  final String? Function(String?) validate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        controller: controller,
        validator: validate,
        decoration: InputDecoration(
          label: Text(label),
          hintText: hintText,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
