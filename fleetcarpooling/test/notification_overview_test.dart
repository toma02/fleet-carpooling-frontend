import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/auth/auth_notification.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

void main() async {
  FirebaseDatabase firebaseDatabase;
  AuthNotification? notificationService;

  // Sign in.
  final user = MockUser(
    isAnonymous: false,
    uid: 'someuid',
    email: 'bob@somedomain.com',
    displayName: 'Bob',
  );
  final auth = MockFirebaseAuth(mockUser: user);

  const fakeData = {
    'Vehicles': {
      'vehicle1': {
        'vin': 'ABC123',
        'model': 'Model1',
        'brand': 'Brand1',
        'capacity': 5,
        'transType': 'manual',
        'fuelConsumption': 3,
        'registration': 'asdasd',
        'year': 2015,
        'active': true,
        'imageUrl': "asdasdasd",
        'latitude': 46.3897,
        'longitude': 16.4380,
        'locked': true
      },
      'vehicle2': {
        'vin': 'DEF456',
        'model': 'Model2',
        'brand': 'Brand2',
        'capacity': 5,
        'transType': 'manual',
        'fuelConsumption': 3,
        'registration': 'asdasd',
        'year': 2015,
        'active': true,
        'imageUrl': "asdasdasd",
        'latitude': 46.3897,
        'longitude': 16.4380,
        'locked': true
      },
    },
  };
  MockFirebaseDatabase.instance.ref().set(fakeData);
  firebaseDatabase = MockFirebaseDatabase.instance;

  setUp(() {
    notificationService = AuthNotification(auth, firebaseDatabase);
  });
  group("getCarDetails", () {
    test('Should retrieve vehicle1', () async {
      Map<String, dynamic>? vehicles =
          await notificationService?.getCarDetails("vehicle1");

      expect(vehicles, isNotEmpty);
    });

    test('Should retrieve and verify details for vehicle1', () async {
      Map<String, dynamic>? vehicles =
          await notificationService?.getCarDetails("vehicle1");

      expect(vehicles?['brand'], 'Brand1');
      expect(vehicles?['model'], 'Model1');
      expect(vehicles?['year'], 2015);
    });

    test('Should return null for non-existing vehicle', () async {
      Map<String, dynamic>? vehicleDetails =
          await notificationService?.getCarDetails("nonExistingVehicle");

      expect(vehicleDetails, isNull);
    });

    test('Should throw exception for null vinCar', () async {
      try {
        await notificationService?.getCarDetails("");
        fail('Expected exception not thrown');
      } catch (e) {
        expect(e, isA<Exception>());
        expect(e.toString(), contains('vinCar cannot be null or empty'));
      }
    });
  });
}
