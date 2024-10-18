import 'package:flutter/material.dart';
import 'package:school_erp/screens/events/event_detail_screen.dart';

import '../constants/colors.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String subtitle;
  final String image;
  final String heroTag;

  const EventCard({
    super.key,
    required this.title,
    required this.date,
    required this.subtitle,
    required this.image,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            // MaterialPageRoute(
            //   builder: (_) => EventDetailScreen(
            //     date: date,
            //     title: title,
            //     subtitle: subtitle,
            //     heroTag: heroTag,
            //   ),
            // ),
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (_, __, ___) => EventDetailScreen(
                date: date,
                title: title,
                subtitle: subtitle,
                image: image,
                heroTag: heroTag,
              ),
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE1E3E8)),
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: heroTag,
                  child: Container(
                    height: 80.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      color: const Color(0xFFCACACA),
                    ),
                    child: image == ""
                        ? null
                        : Image.network(
                            image,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(width: 14.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: primaryColor,
                            size: 18.0,
                          ),
                          const SizedBox(width: 6.0),
                          Text(
                            date,
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        subtitle,
                        maxLines: 3,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF777777),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
