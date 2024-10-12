import 'package:flutter/material.dart';

class RequiredText extends StatelessWidget {
  const RequiredText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Required *",
      style: TextStyle(
        fontSize: 10.0,
        color: Colors.red,
      ),
    );
  }
}
