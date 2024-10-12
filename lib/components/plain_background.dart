import 'package:flutter/material.dart';

class PlainBackground extends StatelessWidget {
  const PlainBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/Background.png",
      height: MediaQuery.of(context).size.height / 1.04,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );
  }
}
