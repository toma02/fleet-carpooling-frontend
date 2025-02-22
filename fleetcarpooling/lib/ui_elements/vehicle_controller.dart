import 'package:core/ui_elements/colors';
import 'package:fleetcarpooling/services/vehicle_managament_service.dart';
import 'package:core/ui_elements/custom_toast.dart';
import 'package:flutter/material.dart';

class VehicleController extends StatefulWidget {
  final Function(String) onCommand;
  // ignore: prefer_typing_uninitialized_variables
  final selectedMarkerId;
  final bool refreshUI;

  const VehicleController(
      {super.key,
      required this.onCommand,
      this.selectedMarkerId,
      required this.refreshUI});

  @override
  // ignore: library_private_types_in_public_api
  _VehicleControllerState createState() => _VehicleControllerState();
}

class _VehicleControllerState extends State<VehicleController> {
  TextEditingController locationController = TextEditingController();
  String destination = "";
  FocusNode locationFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10.0,
      left: 10.0,
      child: StreamBuilder<bool>(
        stream: getLockStateStream(widget.selectedMarkerId.value),
        builder: (context, snapshot) {
          bool isLocked = snapshot.data ?? false;
          return ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(19.0),
              topRight: Radius.circular(19.0),
              bottomLeft: Radius.circular(19.0),
              bottomRight: Radius.circular(19.0),
            ),
            child: Container(
              color: AppColors.primaryColor,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 140.0,
                        margin: const EdgeInsets.only(right: 8.0),
                        child: TextField(
                          controller: locationController,
                          focusNode: locationFocusNode,
                          decoration: const InputDecoration(
                            hintText: 'Enter destination',
                            hintStyle: TextStyle(
                              color: AppColors.buttonColor,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.buttonColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          var inputText = locationController.text.trim();
                          if (inputText != "" && inputText.isEmpty == false) {
                            inputText = inputText
                                .toLowerCase()
                                .replaceAll(' ', '_')
                                .replaceAll("č", "c")
                                .replaceAll("ć", "c")
                                .replaceAll("š", "s")
                                .replaceAll("đ", "dj")
                                .replaceAll("ž", "z")
                                .toUpperCase();
                            inputText = inputText[0].toUpperCase() +
                                inputText.substring(1);
                            widget.onCommand("set-destination $inputText");
                            locationController.text = "";
                            locationFocusNode.unfocus();
                          } else {
                            CustomToast().showFlutterToast(
                                "Destination field cant be empty!");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                        ),
                        child: const Icon(
                          Icons.change_circle,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => widget.onCommand("start"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                        ),
                        child: const Icon(
                          Icons.send,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: () => widget.onCommand("stop"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                        ),
                        child: const Icon(
                          Icons.stop,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: () => widget.onCommand("restart"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                        ),
                        child: const Icon(
                          Icons.restart_alt,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          widget.onCommand("lock");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                        ),
                        child: Icon(
                          isLocked ? Icons.lock : Icons.lock_open,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
