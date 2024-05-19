import 'package:fitness_app/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  bool? obscureText;
  final String? Function(String?)? validator;
  final bool icon;
  final String? label;
  final Icon? prefixIcon;

  AuthTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obscureText,
    required this.icon,
    this.validator,
    this.label,
    this.prefixIcon,
  }) : super(key: key);

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText!,
      validator: widget.validator,
      decoration: InputDecoration(
        fillColor: Colors.grey.shade100,
        filled: true,
        labelText: widget.label,
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.black26, fontSize: 17),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black12, // Default border color
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black12, // Default border color
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: MyColors.primary,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.icon
            ? IconButton(
                onPressed: () {
                  setState(() {
                    widget.obscureText = !widget.obscureText!;
                  });
                },
                icon: widget.obscureText!
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
              )
            : const SizedBox(),
      ),
    );
  }
}
