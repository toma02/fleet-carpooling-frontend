class Vehicle {
  String vin;
  String model;
  String brand;
  int capacity;
  String transType;
  int fuelConsumption;
  String registration;
  int year;
  bool active;
  String imageUrl;
  int distanceTraveled;
  double latitude;
  double longitude;
  bool locked;
  Map<String, String>? token;

  Vehicle(
      {required this.vin,
      required this.model,
      required this.brand,
      required this.capacity,
      required this.transType,
      required this.fuelConsumption,
      required this.registration,
      required this.year,
      required this.active,
      required this.imageUrl,
      this.distanceTraveled = 0,
      required this.latitude,
      required this.longitude,
      required this.locked,
      this.token});

  Map<String, dynamic> toMap() {
    return {
      'vin': vin,
      'model': model,
      'brand': brand,
      'capacity': capacity,
      'transtype': transType,
      'fuelConsumption': fuelConsumption,
      'registration': registration,
      'year': year,
      'active': active,
      'imageUrl': imageUrl,
      'distanceTraveled': distanceTraveled,
      'latitude': latitude,
      'longitude': longitude,
      'locked': locked,
      'token': token,
    };
  }
}
