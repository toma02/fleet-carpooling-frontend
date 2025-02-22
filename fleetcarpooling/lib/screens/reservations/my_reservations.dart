import 'package:core/ui_elements/colors';
import 'package:core/ui_elements/custom_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleetcarpooling/Models/reservation_model.dart';
import 'package:fleetcarpooling/services/vehicle_managament_service.dart';
import 'package:flutter/material.dart';
import 'package:fleetcarpooling/services/reservation_service.dart';
import 'package:fleetcarpooling/utils/datetime_utils.dart';

class MyReservationsPage extends StatefulWidget {
  const MyReservationsPage({super.key});

  @override
  State<MyReservationsPage> createState() => _MyReservationsPageState();
}

class _MyReservationsPageState extends State<MyReservationsPage> {
  late final ReservationService _service = ReservationService();
  User? user = FirebaseAuth.instance.currentUser;
  late Stream<List<Reservation>> _reservationsStream;

  @override
  Widget build(BuildContext context) {
    _reservationsStream = _service.getUserReservations(user!.email!);

    DateTimeUtils dateTimeUtils = DateTimeUtils();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 25),
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
              child: Column(
                children: [
                  Container(
                    height: 50,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: AppColors.buttonColor))),
                    margin: const EdgeInsets.only(bottom: 28),
                    child: const Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "MY RESERVATIONS",
                        style: TextStyle(
                            color: AppColors.mainTextColor, fontSize: 24),
                      ),
                    ),
                  ),
                  StreamBuilder<List<Reservation>>(
                    stream: _reservationsStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No reservations made yet.'));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder<String?>(
                            future: getVehicleModelAndBrand(
                                snapshot.data![index].vin),
                            builder: (context, snapshotInfo) {
                              if (snapshotInfo.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              double opacity = snapshot.data![index].pickupDate
                                      .isAfter(DateTime.now())
                                  ? 1.0
                                  : 0.7;
                              return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(24, 0, 24, 12),
                                  child: Opacity(
                                    opacity: opacity,
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.backgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12),
                                          child: Column(
                                            children: [
                                              Text(
                                                snapshotInfo.data ??
                                                    "Could not fetch car informations",
                                                style: const TextStyle(
                                                  color:
                                                      AppColors.mainTextColor,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 24,
                                                    bottom: 12,
                                                    top: 12),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${dateTimeUtils.getShortWeekday(snapshot.data![index].pickupDate)}, ${snapshot.data![index].pickupDate.day}. ${snapshot.data![index].pickupDate.month}",
                                                      style: const TextStyle(
                                                        color: AppColors
                                                            .mainTextColor,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const Icon(
                                                      Icons.arrow_forward,
                                                      color: AppColors
                                                          .mainTextColor,
                                                      size: 16,
                                                    ),
                                                    Text(
                                                      "${dateTimeUtils.getShortWeekday(snapshot.data![index].returnDate)}, ${snapshot.data![index].returnDate.day}. ${snapshot.data![index].returnDate.month}",
                                                      style: const TextStyle(
                                                        color: AppColors
                                                            .mainTextColor,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (snapshot
                                                  .data![index].pickupDate
                                                  .isAfter(DateTime.now()))
                                                Column(
                                                  children: [
                                                    const Divider(
                                                      height: 0.5,
                                                      color: AppColors
                                                          .mainTextColor,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 12,
                                                              bottom: 24),
                                                      child: InkWell(
                                                        child: const Text(
                                                          "Cancel reservation",
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .mainTextColor,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Center(
                                                                child:
                                                                    Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.8,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          16.0),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: AppColors
                                                                        .backgroundColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30.0),
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      const Padding(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            80,
                                                                            28,
                                                                            80,
                                                                            28),
                                                                        child:
                                                                            Text(
                                                                          'ARE YOU SURE?',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                AppColors.mainTextColor,
                                                                            fontSize:
                                                                                24,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const Divider(
                                                                        height:
                                                                            0.5,
                                                                        color: AppColors
                                                                            .mainTextColor,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              _service.deleteReservation(snapshot.data![index].id!);
                                                                              Navigator.of(context).pop();

                                                                              CustomToast().showFlutterToast(
                                                                                "You successfully canceled reservation",
                                                                              );
                                                                            },
                                                                            child:
                                                                                const Padding(
                                                                              padding: EdgeInsets.only(top: 20, bottom: 20),
                                                                              child: Text(
                                                                                'YES',
                                                                                style: TextStyle(
                                                                                  color: AppColors.mainTextColor,
                                                                                  fontSize: 24,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            height:
                                                                                70,
                                                                            width:
                                                                                0.5,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              border: Border.all(
                                                                                color: AppColors.mainTextColor,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                const Padding(
                                                                              padding: EdgeInsets.only(top: 20, bottom: 20),
                                                                              child: Text(
                                                                                'NO',
                                                                                style: TextStyle(
                                                                                  color: AppColors.mainTextColor,
                                                                                  fontSize: 24,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        )),
                                  ));
                            },
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
