import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:core/models/vehicle.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/services/vehicle_managament_service.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';

void main() {
  
const fakeDataVehicle = {
    'Vehicles': {
      '12345678': {
        'vin': '1HGCM82633A123456',
        'model': 'Model S',
        'brand': 'Tesla',
        'capacity': 5,
        'transtype': 'Automatic',
        'fuelConsumption': 10,
        'registration': '2022-01-01',
        'year': 2022,
        'active': true,
        'imageUrl': 'https://example.com/image.jpg',
        'distanceTraveled': 1000,
        'latitude': 37.7749,
        'longitude': 122.4194,
        'locked': false,
      },
      '11223344': {
        'vin': '1HGCM82788A123456',
        'model': 'M1',
        'brand': 'B1',
        'capacity': 5,
        'transtype': 'Automatic',
        'fuelConsumption': 10,
        'registration': '2022-01-01',
        'year': 2022,
        'active': true,
        'imageUrl': 'https://example.com/image.jpg',
        'distanceTraveled': 1000,
        'latitude': 37.7749,
        'longitude': 122.4194,
        'locked': false,
      }
    }
  };
  FirebaseDatabase firebaseDatabaseVehicle = MockFirebaseDatabase.instance;

setUp(() {
      MockFirebaseDatabase.instance.ref().set(fakeDataVehicle);
    });
    test('getVehicle test', () async {
  Stream<Vehicle?> vehicle = getVehicle('1HGCM82788A123456', firebaseDatabaseVehicle);

  expectLater(vehicle, emits(isInstanceOf<Vehicle>()));
});

    test('getVehicle test', () async {
  Stream<Vehicle?> vehicle = getVehicle('1HGCM82788A123456', firebaseDatabaseVehicle);

  expectLater(vehicle, emits(isInstanceOf<Vehicle>()));
});

  test('_formatDate test', () {
    expect(_formatDate('2022-01-15'), '2022-01-15');
    expect(_formatDate('2023-05-02'), '2023-05-02');
  });

  test('_formatTime test', () {
    expect(_formatTime('2022-01-15 08:30'), '08:30');
    expect(_formatTime('2023-05-02 15:45'), '15:45');
  });

  test('_formatNumber test', () {
    expect(_formatNumber(5), '05');
    expect(_formatNumber(12), '12');
    expect(_formatNumber(0), '00');
    expect(_formatNumber(9), '09');
  });
}

String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  String _formatTime(String time) {
    DateTime parsedTime = DateFormat('yyyy-MM-dd HH:mm').parse(time);
    return DateFormat('HH:mm').format(parsedTime);
  }

String _formatNumber(int number) {
    return number.toString().padLeft(2, '0');
  }
