import 'package:fitness_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;
  final Color? backColor;
  final Color? textColor;
  final Gradient? gradient;
  final Border? border;

  const AuthButton({
    Key? key,
    required this.onTap,
    required this.buttonText,
    this.backColor,
    this.textColor,
    this.gradient,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 65,
        width: 300,
        decoration: BoxDecoration(
          color: backColor,
          gradient: gradient,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
          border: border,
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
