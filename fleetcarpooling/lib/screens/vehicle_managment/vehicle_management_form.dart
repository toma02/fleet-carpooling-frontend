import 'package:core/widgets/add_vehicle_selection.dart';
import 'package:core/ui_elements/buttons.dart';
import 'package:core/ui_elements/colors';
import 'package:fleetcarpooling/screens/admin/delete_disable_form.dart';
import 'package:flutter/material.dart';

class VehicleManagementForm extends StatelessWidget {
  const VehicleManagementForm({super.key});

  @override
  Widget build(BuildContext context) {
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
            Text("VEHICLE MANAGEMENT",
                style:
                    TextStyle(color: AppColors.mainTextColor, fontSize: 22.0)),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 50),
          MyElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddVehicleSelection()),
                );
              },
              label: 'Add car manually or with QR'),
          MyElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeleteDisableForm()),
                );
              },
              label: 'Delete/disable car'),
          Expanded(
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
