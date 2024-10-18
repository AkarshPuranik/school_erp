import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CommonTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final bool? obscureText;
  final TextCapitalization? textCapitalization;
  final VoidCallback? onTap;
  final int? maxLines;
  final String? hintText;
  final TextStyle? textStyle; // Optional custom text style
  final TextStyle? hintTextStyle; // Optional custom hint text style
  final bool isPassword; // New property to indicate if it's a password field

  const CommonTextField({
    super.key,
    required this.controller,
    this.textInputAction,
    this.obscureText,
    this.textCapitalization,
    this.onTap,
    this.maxLines,
    this.hintText,
    this.textStyle, // Text style parameter
    this.hintTextStyle, // Hint text style parameter
    this.isPassword = false, // Default to false
  });

  @override
  _CommonTextFieldState createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool _obscureText = false; // Initialize with false

  @override
  void initState() {
    super.initState();
    _obscureText =
        widget.obscureText ?? false; // Initialize with obscureText value
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPassword) {
      _obscureText =
          !_obscureText; // Toggle obscureText when isPassword is true
    }

    return TextField(
      controller: widget.controller,
      cursorColor: primaryColor,
      textInputAction: widget.textInputAction,
      scrollPadding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).viewInsets.bottom),
      textCapitalization:
          widget.textCapitalization ?? TextCapitalization.sentences,
      obscureText: _obscureText,
      style: widget.textStyle,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: widget.hintTextStyle,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      onTap: widget.onTap,
      maxLines: widget.maxLines ?? 1,
    );
  }
}
