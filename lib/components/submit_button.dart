import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  const SubmitButton({super.key, required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(
            horizontal: 14.0),
        padding: const EdgeInsets.symmetric(
            vertical: 18.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            Color(0xFF2855AE),
            Color(0xFF7292CF),
          ]),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
