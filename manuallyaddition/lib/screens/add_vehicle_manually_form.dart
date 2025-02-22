import 'package:core/models/add_vehicle_interface.dart';
import 'package:core/bloc/vehicle_bloc.dart';
import 'package:core/event/vehicle_event.dart';
import 'package:core/state/vehicle_state.dart';
import 'package:core/ui_elements/buttons.dart';
import 'package:core/ui_elements/colors';
import 'package:core/ui_elements/text_field.dart';
import 'package:core/models/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:manuallyaddition/services/image_service.dart';

class AddVehicleManuallyForm extends AddVehicleInteface {
  const AddVehicleManuallyForm({super.key});

  @override
  State<StatefulWidget> createState() => _AddVehicleManuallyForm();

  @override
  String getName() {
    return "Manual addition";
  }
}

class _AddVehicleManuallyForm extends State<AddVehicleManuallyForm> {
  final TextEditingController vinController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController registrationController = TextEditingController();
  final TextEditingController fuelConsumptionController =
      TextEditingController();
  late String imageUrlCar = "";
  List<String> years = List.empty();
  bool isImageUploaded = false;
  final List<String> capacity = ['1', '2', '3', '4', '5', '6', '7'];
  final UploadImage _repository = UploadImage();
  final List<String> transmissionType = ['Automatic', 'Manual'];
  String? selectedCapacity;
  String? selectedTransType;
  String? selectedYear;
  List<String> generateYearsList() {
    int currentYear = DateTime.now().year;
    List<String> yearsList = [];
    for (int year = 2012; year <= currentYear; year++) {
      yearsList.add(year.toString());
    }
    return yearsList;
  }

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
    if (years.isEmpty == true) years = generateYearsList();
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
            Text("ADD NEW CAR MANUALLY",
                style:
                    TextStyle(color: AppColors.mainTextColor, fontSize: 18.0)),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "VIN",
                    style: TextStyle(color: AppColors.mainTextColor),
                  ),
                ),
              ),
              const SizedBox(height: 3.0),
              SizedBox(
                height: 43,
                child: MyTextField(
                    controller: vinController, regex: RegExp(r'^.{17}$')),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Model",
                    style: TextStyle(color: AppColors.mainTextColor),
                  ),
                ),
              ),
              const SizedBox(height: 3.0),
              SizedBox(
                height: 43,
                child: MyTextField(controller: modelController),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Brand",
                    style: TextStyle(color: AppColors.mainTextColor),
                  ),
                ),
              ),
              const SizedBox(height: 3.0),
              SizedBox(
                height: 43,
                child: MyTextField(controller: brandController),
              ),
              const SizedBox(height: 20),
              const Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 24.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Capacity",
                            style: TextStyle(color: AppColors.mainTextColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                  Expanded(
                    flex: 6,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Transmission type",
                          style: TextStyle(color: AppColors.mainTextColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3.0),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.buttonColor, width: 1),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                items: capacity
                                    .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                value: selectedCapacity,
                                onChanged: (value) {
                                  setState(() {
                                    selectedCapacity = value;
                                  });
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  iconSize: 20,
                                  iconEnabledColor: AppColors.buttonColor,
                                  iconDisabledColor: Colors.grey,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 43,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    flex: 6,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 24),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.buttonColor, width: 1),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: const Row(
                                  children: [
                                    SizedBox(
                                      width: 4,
                                    ),
                                  ],
                                ),
                                items: transmissionType
                                    .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                value: selectedTransType,
                                onChanged: (value) {
                                  setState(() {
                                    selectedTransType = value;
                                  });
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  iconSize: 20,
                                  iconEnabledColor: AppColors.buttonColor,
                                  iconDisabledColor: Colors.grey,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 24),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Year",
                            style: TextStyle(color: AppColors.mainTextColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                  Expanded(
                    flex: 6,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Fuel consumption",
                          style: TextStyle(color: AppColors.mainTextColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3.0),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.buttonColor, width: 1),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                items: years
                                    .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                value: selectedYear,
                                onChanged: (value) {
                                  setState(() {
                                    selectedYear = value;
                                  });
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  iconSize: 20,
                                  iconEnabledColor: AppColors.buttonColor,
                                  iconDisabledColor: Colors.grey,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 43,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 6,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 43,
                          child: MyTextField(
                              controller: fuelConsumptionController,
                              onlyDigits: true,
                              keyboardType: TextInputType.number),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 24),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Registration",
                            style: TextStyle(color: AppColors.mainTextColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3.0),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 24),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            height: 43,
                            child:
                                MyTextField(controller: registrationController),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 4,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 43,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.camera_alt,
                                    color:
                                        isImageUploaded ? Colors.green : null),
                                onPressed: () async {
                                  imageUrlCar =
                                      await _repository.uploadImageCamera();
                                  if (imageUrlCar != "") {
                                    setState(() {
                                      isImageUploaded = true;
                                    });
                                  }
                                },
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                icon: Icon(Icons.upload,
                                    color:
                                        isImageUploaded ? Colors.green : null),
                                onPressed: () async {
                                  imageUrlCar =
                                      await _repository.uploadImageGallery();
                                  if (imageUrlCar != "") {
                                    setState(() {
                                      isImageUploaded = true;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40.0),
              MyElevatedButton(
                onPressed: () {
                  bool isVinValid =
                      RegExp(r'^.{17}$').hasMatch(vinController.text);

                  if (isVinValid &&
                      modelController.text.isEmpty == false &&
                      brandController.text.isEmpty == false &&
                      fuelConsumptionController.text.isEmpty == false &&
                      registrationController.text.isEmpty == false &&
                      selectedCapacity.toString().isEmpty == false &&
                      selectedYear.toString().isEmpty == false &&
                      selectedTransType.toString().isEmpty == false &&
                      imageUrlCar.isEmpty == false) {
                    String vin = vinController.text;
                    String model = modelController.text;
                    String brand = brandController.text;
                    int capacity = int.parse(selectedCapacity.toString());
                    String trans = selectedTransType.toString();
                    int fuel = int.parse(fuelConsumptionController.text);
                    String registration = registrationController.text;
                    int year = int.parse(selectedYear.toString());
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
                      imageUrl: imageUrlCar,
                      latitude: 46.3897,
                      longitude: 16.4380,
                      locked: true,
                    );

                    BlocProvider.of<VehicleBloc>(context)
                        .add(AddVehicleEvent(vehicle: newVehicle));
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text(
                              'Incorrect entry, VIN must contain 17 characters and all data must be entered.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                label: 'ADD NEW CAR',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
