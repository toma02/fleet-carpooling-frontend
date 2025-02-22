import 'package:core/ui_elements/buttons.dart';
import 'package:core/models/vehicle.dart';
import 'package:fleetcarpooling/services/vehicle_managament_service.dart';
import 'package:fleetcarpooling/chat/service/notification_service.dart';
import 'package:fleetcarpooling/screens/admin/admin_home_page.dart';
import 'package:fleetcarpooling/screens/admin/admin_selected_vehicle_page.dart';
import 'package:core/ui_elements/colors';
import 'package:fleetcarpooling/screens/profile/profile_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

// ignore: must_be_immutable
class DeleteDisableForm extends StatefulWidget {
  List<Vehicle> cars = List.empty();

  DeleteDisableForm({super.key});
  @override
  State<DeleteDisableForm> createState() => _DeleteDisableForm();
}

class _DeleteDisableForm extends State<DeleteDisableForm> {
  final notification = NotificationsService(FirebaseDatabase.instance);
  late Stream<List<Vehicle>> _vehiclesStream;
  final TextEditingController _searchController = TextEditingController();
  String vinCar = "";
  @override
  void initState() {
    super.initState();
    notification.firebaseNotification(context);
    _vehiclesStream = getVehicles(FirebaseDatabase.instance);
  }

  void _handleSearch(String input) {
    setState(() {
      _vehiclesStream = getVehicles(FirebaseDatabase.instance).map((vehicles) =>
          vehicles
              .where((vehicle) =>
                  vehicle.model.toLowerCase().contains(input.toLowerCase()) ||
                  vehicle.brand.toLowerCase().contains(input.toLowerCase()))
              .toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double padding2 = screenHeight * 0.02;
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
                          top: padding2, bottom: padding2, right: 10),
                      child: Stack(
                        fit: StackFit.loose,
                        children: [
                          Row(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 51.34,
                                    height: 49.51,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: CircularIconButton(
                                        onPressed: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          Future.delayed(
                                              const Duration(milliseconds: 50), () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminHomePage(),
                                              ),
                                            );
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.65),
                                        child: const Text(
                                          "Here you can manage all cars.",
                                          style: TextStyle(
                                            color: AppColors.mainTextColor,
                                            fontSize: 24,
                                          ),
                                          maxLines: 10,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10.0),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ProfilePage(),
                                          ),
                                        );
                                      },
                                      child: Image.asset(
                                        'assets/icons/profile.png',
                                        height: 30,
                                        width: 30,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth,
                    padding:
                        const EdgeInsets.only(left: 24, right: 24, bottom: 0),
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
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                            child: InkWell(
                              onTap: () {
                                vinCar = snapshot.data![index].vin;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AdminSelectedVehiclePage(
                                            vin: vinCar,
                                          )),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(30.0),
                                  border: Border.all(
                                    color: AppColors.mainTextColor,
                                    width: 0.5,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "${snapshot.data![index].brand} ${snapshot.data![index].model}",
                                              style: const TextStyle(
                                                  color:
                                                      AppColors.mainTextColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24),
                                            ),
                                          ),
                                          Text(
                                            snapshot.data![index].transType,
                                            style: const TextStyle(
                                                color: AppColors.mainTextColor,
                                                fontSize: 18),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
