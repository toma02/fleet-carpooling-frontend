import 'package:firebase_auth/firebase_auth.dart';
import 'package:core/models/vehicle_location_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/services/reservation_service.dart';
import 'package:fleetcarpooling/screens/map_functionality/udp_manager.dart';
import 'package:core/ui_elements/custom_toast.dart';
import 'package:fleetcarpooling/screens/map_functionality/udp_message_handler.dart';
import 'package:core/services/vehicle_location_service.dart';
import 'package:fleetcarpooling/ui_elements/vehicle_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  final LatLng center = const LatLng(46.3904261, 16.4471181);

  Set<Marker> markers = {};
  bool showController = false;
  late MarkerId selectedMarkerId;

  late UDPManager udpManager;
  late BitmapDescriptor icon;

  bool refreshUI = false;
  Future<bool>? reservationCheckFuture;

  User? user = FirebaseAuth.instance.currentUser;
  late UDPMessageHandler udpMessageHandler = UDPMessageHandler();

  @override
  void initState() {
    super.initState();
    initializeUDP();
    initializeAssets();
    updateMapWithVehicleMarkers();
  }

  void initializeUDP() {
    String finalIpAddress = dotenv.env['DEVICE_IP_ADRESS']!;
    int port = int.parse(dotenv.env['DEVICE_PORT']!);
    udpManager = UDPManager(finalIpAddress, port);
    udpManager.connectUDP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              onMapCreated: onMapCreated,
              initialCameraPosition: CameraPosition(
                target: center,
                zoom: 12.0,
              ),
              onTap: (_) {
                setState(() {
                  showController = false;
                  selectedMarkerId = const MarkerId('');
                });
              },
              markers: markers,
            ),
          ),
          if (showController)
            FutureBuilder<bool>(
              future: reservationCheckFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return snapshot.data == true
                      ? VehicleController(
                          selectedMarkerId: selectedMarkerId,
                          onCommand: (command) {
                            udpManager.sendCommand(command, selectedMarkerId);
                          },
                          refreshUI: refreshUI,
                        )
                      : Container();
                }
              },
            )
        ],
      ),
    );
  }

  initializeAssets() {
    selectedMarkerId = const MarkerId('');
    getIcons();
  }

  getIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/icons/vehicle_icon90.png");
    setState(() {
      this.icon = icon;
    });
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Marker createVehicleMarker(VehicleLocation vehicleLocation) {
    return Marker(
      icon: icon,
      markerId: MarkerId(vehicleLocation.vin),
      position: LatLng(vehicleLocation.latitude, vehicleLocation.longitude),
      infoWindow: InfoWindow(
          title: "${vehicleLocation.brand} ${vehicleLocation.model}"),
      onTap: () async {
        setState(() {
          reservationCheckFuture = ReservationService()
              .checkReservation("${user!.email}", vehicleLocation.vin);
        });

        bool hasReservation = await reservationCheckFuture!;

        setState(() {
          if (!hasReservation) {
            showController = false;
            CustomToast().showFlutterToast(
                "You dont have reservation for this vehicle!");
          } else {
            showController = true;
            selectedMarkerId = MarkerId(vehicleLocation.vin);
          }
        });
      },
    );
  }

  void updateMapWithVehicleMarkers() {
    VehicleLocationService(FirebaseDatabase.instance)
        .getVehicleLocations()
        .listen((vehicleLocations) {
      final newMarkers = vehicleLocations.map(createVehicleMarker).toSet();

      if (newMarkers.isNotEmpty) {
        if (mounted) {
          setState(() {
            markers = newMarkers;
          });
        }
      }
    });
  }
}
