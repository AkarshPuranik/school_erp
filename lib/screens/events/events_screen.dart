import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/components/custom_appbar.dart';
import 'package:school_erp/components/star_background.dart';
import 'package:school_erp/constants/colors.dart';
import 'package:school_erp/model/events_model.dart';
import '../../reusable_widgets/event_card.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  bool loading = true;

  //Firebase - Firestore initialization
  CollectionReference firestore =
      FirebaseFirestore.instance.collection('events');

  List<Events> eventList = [];

  @override
  void initState() {
    data();
    super.initState();
  }

  Future<void> data() async {
    await firestore.get().then((value) => value.docs.forEach((element) {
          setState(() {
            eventList.add(
                Events(element["title"], element["description"], element["time"], element["image"]));
          });
          debugPrint("EventList: ${eventList.toString()}");
          debugPrint("EventList: ${eventList[0].title}");
        }));
    setState(() {
      loading = false;
    });
    // final allData = querySnapshot.docs.map((doc) => doc.data());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7292CF),
      body: SafeArea(
        child: Stack(
          children: [
            const StarBackground(),
            Column(
              children: [
                const CustomAppBar(title: "Events & Programs"),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 30.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0)),
                    ),
                    child: loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : SingleChildScrollView(
                            child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10.0),
                                    ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: eventList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return EventCard(
                                          title: eventList[index].title!,
                                          date: eventList[index].time!,
                                          subtitle: eventList[index].subtitle!,
                                          image: eventList[index].image!,
                                          heroTag: "event$index",
                                        );
                                      },
                                    ),
                                    // EventCard(
                                    //     title: "Sleepover Night",
                                    //     date: "06 Jan 24, 09:00 AM",
                                    //     subtitle: "A sleepover is a great treat for kids. Many schools use such an event as the culminating activity of the school year.",
                                    // ),
                                    // EventCard(
                                    //   title: "Fishing Tournament",
                                    //   date: "12 Jan 24, 09:00 AM",
                                    //   subtitle: "Silver Sands Middle School in Port Orange, Florida, offers many special events, but one of the most unique ones is a springtime...",
                                    // ),
                                    // EventCard(
                                    //   title: "Rhyme Time: A Night of Poetry",
                                    //   date: "24 Jan 24, 09:00 AM",
                                    //   subtitle: "April is also National Poetry Month. Now there is a great theme for a fun family night! Combine poetry readings by students...",
                                    // ),
                                  ],
                                )),
                          ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
