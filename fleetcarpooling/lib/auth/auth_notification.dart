// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthNotification {
  AuthNotification(this._auth, this.database) {
    _subscribeToNotificationChanges();
  }
  final FirebaseAuth _auth;
  FirebaseDatabase database;
  final StreamController<List<Map<String, dynamic>>>
      _notificationStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get notificationStream =>
      _notificationStreamController.stream;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  void _subscribeToNotificationChanges() {
    database.ref().child('Notifications').onValue.listen((event) async {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? notifications =
            event.snapshot.value as Map<dynamic, dynamic>?;

        if (notifications != null) {
          User? currentUser = getCurrentUser();
          List<Map<String, dynamic>> userNotifications = [];

          for (var entry in notifications.entries) {
            var key = entry.key;
            var value = entry.value;

            if (value['email'] == currentUser?.email) {
              DateTime now = DateTime.now();
              DateTime pickupDate = DateTime.parse(value['pickupDate']);
              String message = value['message'];

              if (message.startsWith('You')) {
                DateTime twoDaysFromNow = now.add(const Duration(days: 2));
                if (pickupDate.isBefore(twoDaysFromNow) &&
                    pickupDate.isAfter(now)) {
                  userNotifications.add({
                    'key': key,
                    'message': message,
                    'VinCar': value['VinCar'],
                    'pickupDate': value['pickupDate'],
                    'pickupTime': value['pickupTime'],
                    'returnDate': value['returnDate'],
                    'returnTime': value['returnTime'],
                  });
                }
              } else if (message.startsWith('Someone')) {
                if (pickupDate.isAfter(now)) {
                  userNotifications.add({
                    'key': key,
                    'message': message,
                    'VinCar': value['VinCar'],
                    'pickupDate': value['pickupDate'],
                    'pickupTime': value['pickupTime'],
                    'returnDate': value['returnDate'],
                    'returnTime': value['returnTime'],
                  });
                }
              }
            }
          }

          _notificationStreamController.add(userNotifications);
        }
      }
    });
  }

  Future<void> deleteAllUserNotifications(String email) async {
    try {
      DatabaseEvent snapshot = await database
          .ref()
          .child('Notifications')
          .orderByChild('email')
          .equalTo(email)
          .once();

      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic>? notifications =
            snapshot.snapshot.value as Map<dynamic, dynamic>?;

        notifications?.forEach((key, value) async {
          await database.ref().child('Notifications').child(key).remove();
        });
      }
    } catch (e) {
      throw Exception('Error deleting notifications: $e');
    }
  }

  Future<Map<String, dynamic>?> getCarDetails(String vinCar) async {
    if (vinCar.isEmpty) {
      throw Exception('vinCar cannot be null or empty');
    }

    try {
      DatabaseEvent snapshot =
          await database.ref().child('Vehicles').child(vinCar).once();

      // ignore: unnecessary_null_comparison
      if (snapshot.snapshot != null) {
        Map<Object?, Object?>? carDetails =
            snapshot.snapshot.value as Map<Object?, Object?>?;

        if (carDetails != null) {
          Map<String, dynamic> carDetailsMap =
              Map<String, dynamic>.from(carDetails);
          return carDetailsMap;
        }
      }

      return null;
    } catch (e) {
      throw Exception('Error fetching car details: $e');
    }
  }

  Future<void> deleteNotifications(
    String vinCar,
    String returnDate,
    String returnTime,
    String pickupDate,
    String pickupTime,
  ) async {
    try {
      DatabaseReference notificationRef =
          FirebaseDatabase.instance.ref('Notifications');

      var notificationsQuery =
          await notificationRef.orderByChild('VinCar').equalTo(vinCar).once();

      if (notificationsQuery.snapshot.value != null) {
        Map<dynamic, dynamic>? notifications =
            notificationsQuery.snapshot.value as Map<dynamic, dynamic>?;

        for (var entry in notifications!.entries) {
          var value = entry.value;

          if (value['message'] != null && value['message'].startsWith('You')) {
            if (value['returnDate'] == returnDate &&
                value['returnTime'] == returnTime &&
                value['pickupDate'] == pickupDate &&
                value['pickupTime'] == pickupTime) {
              await notificationRef.child(entry.key).remove();
            }
          }
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error deleting notifications: $e');
      rethrow;
    }
  }
}
