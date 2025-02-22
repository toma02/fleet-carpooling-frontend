import 'package:core/ui_elements/colors';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fleetcarpooling/auth/auth_notification.dart';

class NotificationPage extends StatefulWidget {
  final FirebaseDatabase database;
  const NotificationPage({Key? key, required this.database}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  AuthNotification authNotification = AuthNotification(FirebaseAuth.instance, FirebaseDatabase.instance);
  String notificationMessage = '';
  late Stream<List<Map<String, dynamic>>> _notificationStream;

  @override
  void initState() {
    super.initState();
    _notificationStream = authNotification.notificationStream;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double padding1 = screenHeight * 0.02;
    double padding2 = screenHeight * 0.03;

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
            Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.buttonColor),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: padding2, bottom: padding1),
                    child: const Text(
                      "NOTIFICATIONS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.mainTextColor,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _notificationStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        notificationMessage = 'Error: ${snapshot.error}';
                        return Text(notificationMessage);
                      } else {
                        List<Map<String, dynamic>> notifications =
                            snapshot.data ?? [];

                        notificationMessage =
                            'Notifications received: ${notifications.length}';

                        if (notifications.isEmpty) {
                          return const Center(
                            child: Text(
                              "No notifications",
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.mainTextColor,
                              ),
                            ),
                          );
                        } else {
                          return ListView(
                            padding: EdgeInsets.only(top: padding2),
                            children: notifications.map((notification) {
                              String message = notification['message'];

                              return GestureDetector(
                                onTap: () {
                                  _showNotificationDetailsPopup(
                                      context, notification);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 13,
                                    right: 14,
                                    bottom: 12,
                                  ),
                                  child: Card(
                                    margin: const EdgeInsets.only(
                                      left: 13,
                                      right: 14,
                                      bottom: 12,
                                    ),
                                    color: AppColors.backgroundColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        message,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: AppColors.mainTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationDetailsPopup(
    BuildContext context,
    Map<String, dynamic> notification,
  ) async {
    String vinCar = notification['VinCar'].toString();
    Map<String, dynamic>? carDetails = await authNotification.getCarDetails(vinCar);

    String pickupDate = notification['pickupDate'].toString();
    String pickupTime = notification['pickupTime'].toString();
    String returnDate = notification['returnDate'].toString();
    String returnTime = notification['returnTime'].toString();
    String model = carDetails?['model'].toString() ?? '';
    String brand = carDetails?['brand'].toString() ?? '';
    String year = carDetails?['year'].toString() ?? '';

    // ignore: use_build_context_synchronously
    double notificationWidth = MediaQuery.of(context).size.width * 1.5;

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundColor,
          title: const Text(
            'Notification Details',
            style: TextStyle(
              color: AppColors.mainTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: notificationWidth,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Pickup Date:', pickupDate),
                  _buildDetailRow('Pickup Time:', pickupTime),
                  _buildDetailRow('Return Date:', returnDate),
                  _buildDetailRow('Return Time:', returnTime),
                  const SizedBox(height: 16),
                  _buildDetailRow('Model:', model),
                  _buildDetailRow('Brand:', brand),
                  _buildDetailRow('Year:', year),
                ],
              ),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 8.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.mainTextColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: AppColors.mainTextColor, fontSize: 20),
          children: [
            TextSpan(
              text: '$label ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
