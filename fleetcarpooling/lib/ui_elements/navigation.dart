import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:core/ui_elements/colors';
import 'package:fleetcarpooling/screens/map_functionality/map.dart';
import 'package:fleetcarpooling/screens/reservations/my_reservations.dart';
import 'package:fleetcarpooling/screens/notifications/notification_page.dart';
import 'package:fleetcarpooling/screens/home/home_page.dart';

class NavigationPage extends StatefulWidget {
  final DateTime pickupTime;
  final DateTime returnTime;
  const NavigationPage({
    Key? key,
    required this.pickupTime,
    required this.returnTime,
  }) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int pressed = 0;
  late List<StatefulWidget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(
        pickupTime: widget.pickupTime,
        returnTime: widget.returnTime,
      ),
      NotificationPage(database: FirebaseDatabase.instance),
      const MapPage(),
      const MyReservationsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[pressed],
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: Container(
          height: 80,
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.buttonColor))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      pressed = 0;
                    });
                  },
                  icon: pressed == 0
                      ? Image.asset(
                          'assets/icons/home_active.png',
                          height: 28,
                          width: 33,
                        )
                      : Image.asset(
                          'assets/icons/home.png',
                          height: 28,
                          width: 33,
                        )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      pressed = 1;
                    });
                  },
                  icon: pressed == 1
                      ? Image.asset(
                          'assets/icons/notification_active.png',
                          height: 27.5,
                          width: 24,
                        )
                      : Image.asset(
                          'assets/icons/notification.png',
                          height: 27.5,
                          width: 24,
                        )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      pressed = 2;
                    });
                  },
                  icon: pressed == 2
                      ? Image.asset(
                          'assets/icons/map_active.png',
                          height: 33,
                          width: 27,
                        )
                      : Image.asset(
                          'assets/icons/map.png',
                          height: 33,
                          width: 27,
                        )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      pressed = 3;
                    });
                  },
                  icon: pressed == 3
                      ? Image.asset(
                          'assets/icons/key_active.png',
                          height: 25,
                          width: 24,
                        )
                      : Image.asset(
                          'assets/icons/key.png',
                          height: 25,
                          width: 24,
                        ))
            ],
          ),
        ));
  }
}
