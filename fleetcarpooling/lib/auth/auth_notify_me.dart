import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/services/reservation_service.dart';
import 'package:intl/intl.dart';

class AuthNotifyMe {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final StreamController<List<Map<String, dynamic>>>
      _notifyMeNotificationStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get notifyMeNotificationStream =>
      _notifyMeNotificationStreamController.stream;

  Future<void> saveNotifyMeData(
    String vinCar,
    String pickupDate,
    String pickupTime,
    String returnDate,
    String returnTime,
  ) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();

        Map<String, dynamic> notifyMeData = {
          'VinCar': vinCar,
          'email': user.email,
          'pickupDate': _formatDate(pickupDate),
          'pickupTime': _formatTime(pickupTime),
          'returnDate': _formatDate(returnDate),
          'returnTime': _formatTime(returnTime),
        };

        DatabaseReference notifyMeRef =
            _database.child("NotifyMe").child(uniqueName);
        await notifyMeRef.set(notifyMeData);
      } else {
        throw Exception("User not authenticated");
      }
    } catch (e) {
      throw Exception("Error saving NotifyMe data");
    }
  }

  Future<void> checkReservationDeletion(
    String vinCar,
    String reservationDateStart,
    String reservationDateEnd,
    String reservationTimeStart,
    String reservationTimeEnd,
  ) async {
    try {
      DataSnapshot snapshot =
          (await _database.child("NotifyMe").once()).snapshot;
      Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        for (var entry in data.entries) {

          String notifyMeStart = _formatDate(entry.value['pickupDate']);
          String notifyMeEnd = _formatDate(entry.value['returnDate']);
          String notifyMeTimeStart = entry.value['pickupTime'];
          String notifyMeTimeEnd = entry.value['returnTime'];

          if (entry.value['VinCar'] == vinCar &&
              await timeRangesOverlap(
                  reservationDateStart,
                  reservationDateEnd,
                  notifyMeStart,
                  notifyMeEnd,
                  reservationTimeStart,
                  reservationTimeEnd,
                  notifyMeTimeStart,
                  notifyMeTimeEnd,
                  vinCar)) {
            await transferDataToNotificationTable(entry.value);
            await _database.child("NotifyMe").child(entry.key).remove();
          } else {
          }
        }
      }
    } catch (e) {
      throw Exception("Error checking and notifying reservation deletion");
    }
  }

  Future<bool> timeRangesOverlap(
  String reservationDateStart,
  String reservationDateEnd,
  String notifyMeStart,
  String notifyMeEnd,
  String reservationTimeStart,
  String reservationTimeEnd,
  String notifyMeTimeStart,
  String notifyMeTimeEnd,
  String vinCar,
) async {
  try {
    ReservationService reservationService = ReservationService();
    bool? noReservation;

    noReservation = await reservationService.checkReservationOverlap(
      vinCar,
      notifyMeEnd,
      notifyMeTimeEnd,
    );
    return noReservation;
  } catch (e) {
    return false;
  }
}


  Future<void> transferDataToNotificationTable(
      Map<dynamic, dynamic> data) async {
    try {
      DatabaseReference notifyMeNotificationRef =
          _database.child("Notifications");

      String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();

      Map<String, dynamic> notificationData = {
        'VinCar': data['VinCar'],
        'email': data['email'],
        'pickupDate': _formatDate(data['pickupDate']),
        'pickupTime': _formatTime(data['pickupTime']),
        'returnDate': _formatDate(data['returnDate']),
        'returnTime': _formatTime(data['returnTime']),
        'message':
            "Someone canceled for ${_formatDate(data['pickupDate'])}. You can book from ${_formatTime(data['pickupTime'])} to ${_formatDate(data['returnDate'])} ${_formatTime(data['returnTime'])}.",
      };

      await notifyMeNotificationRef.child(uniqueName).set(notificationData);
    } catch (e) {
      throw Exception("Error transferring data to NotifyMeNotification table");
    }
  }

  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  String _formatTime(String time) {
    try {
      String formattedTime = time.padLeft(5, '0');
      DateTime parsedTime = DateFormat('HH:mm').parse(formattedTime);
      return DateFormat('HH:mm').format(parsedTime);
    } catch (e) {
      return time;
    }
  }

  Future<void> deleteAllUserNotifyMeNotifications(String userEmail) async {
    try {
      DatabaseEvent snapshot = await _database
          .child("NotifyMe")
          .orderByChild('email')
          .equalTo(userEmail)
          .once();

      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic>? notifications =
            snapshot.snapshot.value as Map<dynamic, dynamic>?;

        if (notifications != null) {
          notifications.forEach((key, value) async {
            await _database.child('NotifyMe').child(key).remove();
          });
        }
      }
    } catch (e) {
      throw Exception('Error deleting all user NotifyMeNotifications: $e');
    }
  }

  Future<void> deleteAllCarsNotifyMeNotifications(String vin) async {
    try {
      DatabaseEvent snapshot = await _database
          .child("NotifyMe")
          .orderByChild('vinCar')
          .equalTo(vin)
          .once();

      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic>? notifications =
            snapshot.snapshot.value as Map<dynamic, dynamic>?;

        if (notifications != null) {
          notifications.forEach((key, value) async {
            await _database.child('NotifyMe').child(key).remove();
          });
        }
      }
    } catch (e) {
      throw Exception('Error deleting all user NotifyMeNotifications: $e');
    }
  }
}
