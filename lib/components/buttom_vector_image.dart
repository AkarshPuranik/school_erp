import 'package:flutter/material.dart';

class BottomVectorImage extends StatelessWidget {
  const BottomVectorImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset(
        "assets/vector.png",
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
    );
  }
}
