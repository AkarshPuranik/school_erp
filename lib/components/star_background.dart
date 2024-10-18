import 'package:flutter/material.dart';

class StarBackground extends StatelessWidget {
  const StarBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/Star_Background.png",
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );
  }
}
