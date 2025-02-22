import 'package:core/models/vehicle.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/services/reservation_service.dart';
import 'package:fleetcarpooling/services/vehicle_managament_service.dart';
import 'package:fleetcarpooling/chat/service/notification_service.dart';
import 'package:fleetcarpooling/screens/profile/profile_form.dart';
import 'package:fleetcarpooling/screens/vehicle_managment/selected_vehicle_page.dart';
import 'package:fleetcarpooling/screens/reservations/reservation_form.dart';
import 'package:core/ui_elements/colors';
import 'package:flutter/material.dart';
import 'package:fleetcarpooling/utils/datetime_utils.dart';

class HomePage extends StatefulWidget {
  final DateTime pickupTime;
  final DateTime returnTime;

  const HomePage({
    Key? key,
    required this.pickupTime,
    required this.returnTime,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final notification = NotificationsService(FirebaseDatabase.instance);
  final TextEditingController _searchController = TextEditingController();
  late Stream<List<Vehicle>> _vehiclesStream;
  String vinCar = "";
  bool isEqual = false;

  void _handleSearch(String input) {
    setState(() {
      _vehiclesStream = getVehicles(FirebaseDatabase.instance).map((vehicles) => vehicles
          .where((vehicle) =>
              vehicle.model.toLowerCase().contains(input.toLowerCase()) ||
              vehicle.brand.toLowerCase().contains(input.toLowerCase()))
          .toList());
    });
  }

  @override
  void initState() {
    super.initState();
    notification.firebaseNotification(context);
    _vehiclesStream = getVehicles(FirebaseDatabase.instance);
    if (widget.pickupTime.day == widget.returnTime.day &&
        widget.pickupTime.month == widget.returnTime.month &&
        widget.pickupTime.year == widget.returnTime.year &&
        widget.pickupTime.hour == widget.returnTime.hour) {
      isEqual = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double padding2 = screenHeight * 0.02;

    DateTimeUtils dateTimeUtils = DateTimeUtils();

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 450),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: screenWidth,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: padding2, bottom: padding2, left: 24, right: 24),
                      child: Stack(
                        fit: StackFit.loose,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            const ReservationScreen(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(0.0, 1.0);
                                          const end = Offset.zero;
                                          const curve = Curves.ease;

                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));

                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Visibility(
                                        visible: isEqual,
                                        child: const Column(
                                          children: [
                                            Text(
                                              "Click to select a date",
                                              style: TextStyle(
                                                color: AppColors.mainTextColor,
                                                fontSize: 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: !isEqual,
                                        child: Column(
                                          children: [
                                            Text(
                                              "${dateTimeUtils.getShortWeekday(widget.pickupTime)}, ${widget.pickupTime.day}.${widget.pickupTime.month}",
                                              style: const TextStyle(
                                                color: AppColors.mainTextColor,
                                                fontSize: 24,
                                              ),
                                            ),
                                            Text(
                                              "${widget.pickupTime.hour}:${widget.pickupTime.minute}${widget.pickupTime.minute}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: AppColors.mainTextColor,
                                                fontSize: 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: !isEqual,
                                        child: const Column(
                                          children: [
                                            Icon(
                                              Icons.arrow_forward,
                                              color: AppColors.buttonColor,
                                            ),
                                            Text(
                                              " ",
                                              style: TextStyle(fontSize: 24),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: !isEqual,
                                        child: Column(
                                          children: [
                                            Text(
                                              "${dateTimeUtils.getShortWeekday(widget.returnTime)}, ${widget.returnTime.day}.${widget.returnTime.month}",
                                              style: const TextStyle(
                                                color: AppColors.mainTextColor,
                                                fontSize: 24,
                                              ),
                                            ),
                                            Text(
                                              "${widget.returnTime.hour}:${widget.returnTime.minute}${widget.returnTime.minute}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: AppColors.mainTextColor,
                                                fontSize: 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProfilePage(),
                                  ),
                                );
                              },
                              child: SizedBox(
                                child: Image.asset("assets/icons/profile.png"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth,
                    padding:
                        const EdgeInsets.only(left: 24, right: 24, bottom: 20),
                    child: SizedBox(
                      height: 43,
                      child: TextField(
                        controller: _searchController,
                        onChanged: _handleSearch,
                        style: const TextStyle(
                            color: AppColors.mainTextColor, fontSize: 16),
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12.0),
                          filled: false,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                                color: AppColors.mainTextColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                              color: AppColors.buttonColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                              color: AppColors.buttonColor,
                            ),
                          ),
                          hintText: "Search..",
                          hintStyle: const TextStyle(
                            color: AppColors.unavailableColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w100,
                            letterSpacing: 0.5,
                          ),
                          prefixIcon: const Icon(Icons.search),
                          prefixIconColor: AppColors.mainTextColor,
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder<List<Vehicle>>(
                    stream: _vehiclesStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No vehicles available.'));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder<bool>(
                            future: ReservationService().getReservationforCar(
                              snapshot.data![index].vin,
                              widget.pickupTime,
                              widget.returnTime,
                            ),
                            builder: (context, reservationSnapshot) {
                              if (reservationSnapshot.data == false) {
                                // Handle case when reservation data is false
                              }

                              if (reservationSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              bool isFree = reservationSnapshot.data ?? false;
                              double opacity = isFree ? 1.0 : 0.5;
                              return Opacity(
                                opacity: opacity,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(24, 0, 24, 12),
                                  child: InkWell(
                                    onTap: () {
                                      vinCar = snapshot.data![index].vin;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SelectedVehiclePage(
                                            vin: vinCar,
                                            isFree: isFree,
                                            pickupTime: widget.pickupTime,
                                            returnTime: widget.returnTime,
                                          ),
                                        ),
                                      ).then((result) {
                                        if (result != null) {
                                          setState(() {
                                            isFree = result;
                                          });
                                        }
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        border: Border.all(
                                          color: AppColors.mainTextColor,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 12),
                                            child: Image.network(
                                              snapshot.data![index].imageUrl,
                                              fit: BoxFit.cover,
                                              height: 122,
                                              width: 209,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                24, 20, 24, 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "${snapshot.data![index].brand} ${snapshot.data![index].model}",
                                                    style: const TextStyle(
                                                        color: AppColors
                                                            .mainTextColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 24),
                                                  ),
                                                ),
                                                Text(
                                                  snapshot
                                                      .data![index].transType,
                                                  style: const TextStyle(
                                                      color: AppColors
                                                          .mainTextColor,
                                                      fontSize: 18),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
