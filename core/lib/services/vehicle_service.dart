import 'package:core/event/vehicle_event.dart';
import 'package:core/services/vehicle_location_service.dart';
import 'package:core/models/vehicle.dart';
import 'package:core/models/vehicle_location_model.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class VehicleRepository {
  Future<void> addVehicle(AddVehicleEvent event);
}

class VehicleService implements VehicleRepository {
  VehicleService(this.database);
  FirebaseDatabase database;
  @override
  Future<void> addVehicle(AddVehicleEvent event) async {
    DatabaseReference carsRef = database.ref().child("Vehicles");
    DatabaseReference newCarRef = carsRef.child(event.vehicle.vin);
    Vehicle vehicle = Vehicle(
        vin: event.vehicle.vin,
        model: event.vehicle.model,
        brand: event.vehicle.brand,
        capacity: event.vehicle.capacity,
        transType: event.vehicle.transType,
        fuelConsumption: event.vehicle.fuelConsumption,
        registration: event.vehicle.registration,
        year: event.vehicle.year,
        active: event.vehicle.active,
        imageUrl: event.vehicle.imageUrl,
        distanceTraveled: event.vehicle.distanceTraveled,
        latitude: event.vehicle.latitude,
        longitude: event.vehicle.longitude,
        locked: event.vehicle.locked,
        token: {"asd": "asd"});

    newCarRef.set(vehicle.toMap());

    VehicleLocation newVehicleLocation = VehicleLocation(
        vin: event.vehicle.vin,
        model: event.vehicle.model,
        brand: event.vehicle.brand,
        latitude: event.vehicle.latitude,
        longitude: event.vehicle.longitude,
        locked: event.vehicle.locked);

    final VehicleLocationService service = VehicleLocationService(database);
    service.initializeVehicleLocation(newVehicleLocation);
  }
}
