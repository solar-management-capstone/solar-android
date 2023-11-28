import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final bool? readOnly;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.obscureText = false,
    this.keyboardType,
    this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText ?? false, // equal ? : expression
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black38),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black38),
        ),
        labelText: hintText,
      ),
      validator: (String? value) {
        if (value!.trim().isEmpty) {
          return 'Vui lòng nhập ${hintText.toLowerCase()}';
        }
        return null;
      },
      maxLines: maxLines,
      keyboardType: keyboardType,
      readOnly: readOnly ?? false,
    );
  }
}
