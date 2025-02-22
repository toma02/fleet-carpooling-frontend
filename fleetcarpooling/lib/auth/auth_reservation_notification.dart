import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AuthReservationNotification {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final StreamController<List<Map<String, dynamic>>>
      _reservationStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get reservationStream =>
      _reservationStreamController.stream;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> saveNotificationToDatabase(
      Map<String, dynamic> reservationData) async {
    try {
      User? currentUser = getCurrentUser();

      if (currentUser != null) {
        String message = _constructNotificationMessage(reservationData);

        await _databaseReference.child('Notifications').push().set({
          'email': currentUser.email,
          'message': message,
          'VinCar': reservationData['vinCar'],
          'pickupDate': _formatDate(reservationData['pickupDate']),
          'pickupTime': _formatTime(reservationData['pickupTime']),
          'returnDate': _formatDate(reservationData['returnDate']),
          'returnTime': _formatTime(reservationData['returnTime']),
        });
      }
    } catch (e) {
      throw Exception('Error saving notification to database');
    }
  }

  String _constructNotificationMessage(Map<String, dynamic> reservationData) {
    String formattedPickupDate = _formatDate(reservationData['pickupDate']);
    String formattedReturnDate = _formatDate(reservationData['returnDate']);
    String formattedPickupTime = _formatTime(reservationData['pickupTime']);
    String formattedReturnTime = _formatTime(reservationData['returnTime']);

    return 'You have a reservation for $formattedPickupDate from $formattedPickupTime until $formattedReturnDate $formattedReturnTime.';
  }

  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  String _formatTime(String time) {
    DateTime parsedTime = DateFormat('yyyy-MM-dd HH:mm').parse(time);
    return DateFormat('HH:mm').format(parsedTime);
  }
}
