import 'package:fleetcarpooling/auth/auth_notify_me.dart';
import 'package:core/ui_elements/colors';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotifyMe extends StatelessWidget {
  final String vinCar;
  final DateTime pickupDateTime;
  final DateTime returnDateTime;

  const NotifyMe({
    super.key,
    required this.vinCar,
    required this.pickupDateTime,
    required this.returnDateTime,
  });

  String _formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  String _formatTime(DateTime dateTime) {
    return "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
  }

  String get pickupDate => _formatDate(pickupDateTime);
  String get returnDate => _formatDate(returnDateTime);
  String get pickupTime => _formatTime(pickupDateTime);
  String get returnTime => _formatTime(returnDateTime);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    AuthNotifyMe authNotifyMe = AuthNotifyMe();

    Future<void> saveNotifyMeData() async {
      await authNotifyMe.saveNotifyMeData(
        vinCar,
        pickupDate,
        pickupTime,
        returnDate,
        returnTime,
      );
    }

    saveNotifyMeData();

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: AppColors.backgroundColor,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: screenHeight * 0.2,
                child: Container(
                  height: 105,
                  width: 129,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icons/check_mark.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'YOU TURNED NOTIFICATIONS ON! WE WILL NOTIFY YOU AS SOON AS CAR IS AVAILABLE FOR YOUR DATE!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.mainTextColor,
                    fontSize: 36.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
