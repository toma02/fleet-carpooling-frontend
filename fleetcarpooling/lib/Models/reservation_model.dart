import 'package:flutter/material.dart';

class Reservation {
  final String? id;
  final String vin;
  final String email;
  final DateTime pickupDate;
  final DateTime returnDate;
  final TimeOfDay pickupTime;
  final TimeOfDay returnTime;
  final String? name;

  Reservation({
    this.id,
    required this.vin,
    required this.email,
    required this.pickupDate,
    required this.returnDate,
    required this.pickupTime,
    required this.returnTime,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'vin': vin,
      'email': email,
      'pickupDate': pickupDate,
      'returnDate': returnDate,
      'pickupTime': pickupTime,
      'returnTime': returnTime,
    };
  }
}
