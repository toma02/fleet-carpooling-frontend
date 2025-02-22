import 'package:core/ui_elements/buttons.dart';
import 'package:core/ui_elements/custom_toast.dart';
import 'package:core/models/vehicle.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/chat/service/notification_service.dart';
import 'package:core/ui_elements/colors';
import 'package:fleetcarpooling/screens/reservations/reservation_form.dart';
import 'package:fleetcarpooling/ui_elements/calendar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleetcarpooling/services/reservation_service.dart';
import 'package:fleetcarpooling/services/vehicle_managament_service.dart';
import 'package:fleetcarpooling/auth/auth_reservation_notification.dart';
import 'package:fleetcarpooling/screens/notifications/notify_me_page.dart';
import 'package:fleetcarpooling/chat/pages/chat_screen.dart';

// ignore: must_be_immutable
class SelectedVehiclePage extends StatefulWidget {
  final String vin;
  bool isFree;
  final DateTime pickupTime;
  final DateTime returnTime;

  SelectedVehiclePage({
    Key? key,
    required this.vin,
    required this.isFree,
    required this.pickupTime,
    required this.returnTime,
  }) : super(key: key);

  @override
  State<SelectedVehiclePage> createState() => _SelectedVehiclePageState();
}

class _SelectedVehiclePageState extends State<SelectedVehiclePage> {
  final notification = NotificationsService(FirebaseDatabase.instance);
  final ReservationService service = ReservationService();
  final AuthReservationNotification authReservationNotification =
      AuthReservationNotification();
  bool postoji = false;
  String email = FirebaseAuth.instance.currentUser!.email!;

  void checkReservationStatus() async {
    postoji = await service.checkReservationForUserAndCar(
        widget.vin, widget.pickupTime, widget.returnTime, email);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    notification.firebaseNotification(context);
    checkReservationStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<Vehicle?>(
              stream: getVehicle(widget.vin, FirebaseDatabase.instance),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text('No data available'));
                }

                Vehicle vehicle = snapshot.data!;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          CircularIconButton(
                            onPressed: () {
                              Navigator.pop(context, widget.isFree);
                            },
                          ),
                          Expanded(
                            child: Text(
                              "${vehicle.brand} ${vehicle.model}",
                              style: const TextStyle(
                                fontSize: 24,
                                color: AppColors.mainTextColor,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      vin: vehicle.vin,
                                      brand: vehicle.brand,
                                      model: vehicle.model,
                                    ),
                                  ),
                                );
                              },
                              child: Image.asset("assets/icons/chat.png"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.network(
                      vehicle.imageUrl,
                      fit: BoxFit.cover,
                      height: 150,
                      width: 300,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        border: Border(
                          top: BorderSide(color: AppColors.mainTextColor),
                          left: BorderSide(color: AppColors.mainTextColor),
                          right: BorderSide(color: AppColors.mainTextColor),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 28, 32, 20),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset("assets/icons/fuel.png"),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8.0, top: 4),
                                  child: Text(
                                    "${vehicle.fuelConsumption} l/100km",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.mainTextColor,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      Image.asset("assets/icons/distance.png"),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8.0, top: 4),
                                  child: Text(
                                    "${vehicle.distanceTraveled} km",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.mainTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(),
                border: Border(
                  left: BorderSide(color: AppColors.mainTextColor),
                  right: BorderSide(color: AppColors.mainTextColor),
                ),
              ),
              child: MyCalendar(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  vin: widget.vin),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(),
                border: Border(
                  left: BorderSide(color: AppColors.mainTextColor),
                  right: BorderSide(color: AppColors.mainTextColor),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReservationScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Change date",
                      style: TextStyle(
                        color: AppColors.mainTextColor,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.mainTextColor,
                        decorationThickness: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(),
                border: Border(
                  left: BorderSide(color: AppColors.mainTextColor),
                  right: BorderSide(color: AppColors.mainTextColor),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Visibility(
                  visible: !(widget.pickupTime.day == widget.returnTime.day &&
                      widget.pickupTime.month == widget.returnTime.month &&
                      widget.pickupTime.year == widget.returnTime.year &&
                      widget.pickupTime.hour == widget.returnTime.hour),
                  child: MyElevatedButton(
                    onPressed: () async {
                      if (postoji) {
                        service.checkAndDeleteReservation(widget.vin,
                            widget.pickupTime, widget.returnTime, email);
                        setState(() {
                          widget.isFree = true;
                          postoji = false;
                        });
                        CustomToast().showFlutterToast(
                            "You succesfully canceled reservation.");
                      } else {
                        if (widget.isFree == true) {
                          await service.addReservation(
                            widget.vin,
                            widget.pickupTime,
                            widget.returnTime,
                          );
                          await service.confirmRegistration(
                            email,
                            widget.pickupTime,
                            widget.returnTime,
                          );
                          await authReservationNotification
                              .saveNotificationToDatabase({
                            'vinCar': widget.vin,
                            'pickupDate':
                                widget.pickupTime.toLocal().toString(),
                            'pickupTime':
                                widget.pickupTime.toLocal().toString(),
                            'returnDate':
                                widget.returnTime.toLocal().toString(),
                            'returnTime':
                                widget.returnTime.toLocal().toString(),
                          });
                          setState(() {
                            widget.isFree = false;
                            postoji = true;
                          });
                          CustomToast().showFlutterToast(
                              "You succesfully reserved vehicle.");
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotifyMe(
                                vinCar: widget.vin,
                                pickupDateTime: widget.pickupTime.toLocal(),
                                returnDateTime: widget.returnTime.toLocal(),
                              ),
                            ),
                          );
                        }
                      }
                    },
                    label: postoji
                        ? "CANCEL RESERVATION"
                        : (widget.isFree ? "MAKE A RESERVATION" : "NOTIFY ME"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
