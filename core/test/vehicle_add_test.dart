import 'package:core/event/vehicle_event.dart';
import 'package:core/services/vehicle_service.dart';
import 'package:core/models/vehicle.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';

void main() {
  FirebaseDatabase firebaseDatabase;

  VehicleService? vehicleService;
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
    vehicleService = VehicleService(firebaseDatabase);
  });
  group("AddVehicle", () {
    test('Should check if vehicle is successfully added', () async {
      final expectedVehicle = Vehicle(
          vin: 'ABC1234',
          model: 'Model14',
          brand: 'Brand14',
          capacity: 5,
          transType: 'manual',
          fuelConsumption: 3,
          registration: 'asdasd',
          year: 2015,
          active: true,
          imageUrl: "asdasdasd",
          latitude: 46.3897,
          longitude: 16.4380,
          locked: true);

      await vehicleService
          ?.addVehicle(AddVehicleEvent(vehicle: expectedVehicle));

      DatabaseEvent snapshot = await firebaseDatabase
          .ref()
          .child('Vehicles')
          .child(expectedVehicle.vin)
          .once();

      expect(snapshot.snapshot.value != null, true);
      DatabaseReference ref =
          firebaseDatabase.ref().child('Vehicles').child(expectedVehicle.vin);
      await ref.remove();
    });

    test('Should check if vehicle number increase', () async {
      final expectedVehicle = Vehicle(
          vin: 'STU901',
          model: 'Model7',
          brand: 'Brand7',
          capacity: 5,
          transType: 'manual',
          fuelConsumption: 3,
          registration: 'asdasd',
          year: 2015,
          active: true,
          imageUrl: "asdasdasd",
          latitude: 46.3897,
          longitude: 16.4380,
          locked: true);

      await vehicleService
          ?.addVehicle(AddVehicleEvent(vehicle: expectedVehicle));
      DatabaseEvent snapshot =
          await firebaseDatabase.ref().child('Vehicles').once();

      Map<dynamic, dynamic> values =
          snapshot.snapshot.value as Map<dynamic, dynamic>;

      expect(values.length, 3);
    });
  });
}
