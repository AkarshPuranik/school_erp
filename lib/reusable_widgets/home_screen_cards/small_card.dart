import 'package:flutter/material.dart';

class HomeScreenSmallCard extends StatelessWidget {
  final IconData icon;
  final String buttonText;
  final VoidCallback? onTap;
  final String tooltext;

  const HomeScreenSmallCard(
      {super.key,
      required this.icon,
      required this.buttonText,
      this.onTap,
      required this.tooltext});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2.4,
        height: MediaQuery.of(context).size.width / 3,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: const Color(0xFF345FB4).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Tooltip(
          preferBelow: true,
          message: tooltext,
          waitDuration: Durations.long1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 50.0,
                color: const Color(0xFF345FB4),
              ),
              const SizedBox(height: 10.0),
              Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
