import 'package:flutter/material.dart';

class CommonTitle extends StatelessWidget {
  final String title;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool? required;
  const CommonTitle({super.key, required this.title, this.required, this.color, this.fontSize, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize ?? 14.0,
          fontWeight: fontWeight ?? FontWeight.w500,
          color: color ?? const Color(0xFFA5A5A5),
        ),
        children: [
          TextSpan(
            text: "$title ",
          ),
          if (required != null && required == true)
            const TextSpan(
              text: "*",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }
}
