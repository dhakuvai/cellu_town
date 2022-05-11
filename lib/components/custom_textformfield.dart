import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPhoneNumber;
  final customValidator;
  final bool obscureText;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.obscureText = false,
    this.customValidator,
    this.isPhoneNumber = false,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: isPhoneNumber ? TextInputType.phone : TextInputType.text,
        inputFormatters: isPhoneNumber
            ? [
                FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
              ]
            : null,
        validator: (value) => value!.isEmpty
            ? 'Please fill the field'
            : (customValidator != null ? customValidator(value) : null),
        decoration: InputDecoration(
            fillColor: Colors.white,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFFE436B),
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            hintText: hintText,
            filled: true));
  }
}
