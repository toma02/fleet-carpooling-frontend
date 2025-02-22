import 'dart:convert';
import 'package:core/models/add_vehicle_interface.dart';
import 'package:core/bloc/vehicle_bloc.dart';
import 'package:core/event/vehicle_event.dart';
import 'package:core/state/vehicle_state.dart';
import 'package:core/ui_elements/buttons.dart';
import 'package:core/ui_elements/colors';
import 'package:core/models/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class AddVehicleQRForm extends AddVehicleInteface {
  const AddVehicleQRForm({super.key});

  @override
  State<StatefulWidget> createState() => _AddVehicleQRForm();

  @override
  String getName() {
    return "Add via QR code";
  }
}

class _AddVehicleQRForm extends State<AddVehicleQRForm> {
  late String qrText = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleBloc, VehicleState>(
      builder: (context, state) {
        if (state is VehicleLoadingState) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is VehicleErrorState) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: AlertDialog(
                title: const Text('Message'),
                content: Text(state.errorMessage),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          );
        } else if (state is VehicleLoadedState) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: AlertDialog(
                title: const Text('Message'),
                content: Text(state.successMessage),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          );
        } else {
          return _buildUI(context);
        }
      },
    );
  }

  Widget _buildUI(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircularIconButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("ADD NEW CAR WITH QR ",
                style:
                    TextStyle(color: AppColors.mainTextColor, fontSize: 18.0)),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: QrCamera(
              fit: BoxFit.cover,
              onError: (context, error) => Text(
                error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
              qrCodeCallback: (code) {
                handleScannedData(code!);
              },
            ),
          ),
        ],
      ),
    );
  }

  void handleScannedData(String scannedData) {
    Map<String, dynamic> decodedData = jsonDecode(scannedData);
    String vin = decodedData['vin'];
    String model = decodedData['model'];
    String brand = decodedData['brand'];
    int capacity = int.parse(decodedData['capacity']);
    String trans = decodedData['transType'];
    int fuel = int.parse(decodedData['fuelConsumption']);
    String registration = decodedData['registration'];
    int year = int.parse(decodedData['year']);
    String imageUrl = decodedData['imageUrl'];
    bool active = true;

    Vehicle newVehicle = Vehicle(
        vin: vin,
        model: model,
        brand: brand,
        capacity: capacity,
        transType: trans,
        fuelConsumption: fuel,
        registration: registration,
        year: year,
        active: active,
        imageUrl: imageUrl,
        latitude: 46.3897,
        longitude: 16.4380,
        locked: true);

    BlocProvider.of<VehicleBloc>(context)
        .add(AddVehicleEvent(vehicle: newVehicle));
  }
}
