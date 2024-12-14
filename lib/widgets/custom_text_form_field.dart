import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final Icon icon;
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    required this.icon,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: icon,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            color: Colors.blue,
          ),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
