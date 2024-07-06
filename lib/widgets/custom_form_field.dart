import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final RegExp validationRegExp;
  final bool obscureText;
  final void Function(String? value) onSaved;

  const CustomFormField({
    super.key,
    required this.hintText,
    required this.validationRegExp,
    this.obscureText = false,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value != null && validationRegExp.hasMatch(value)) return null;

        return "Enter a valid ${hintText.toLowerCase()}";
      },
      onSaved: onSaved,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 0.2,
          ),
        ),
        hintText: hintText,
      ),
    );
  }
}
