class VehicleLocation {
  String vin;
  String model;
  String brand;
  double latitude;
  double longitude;
  bool locked;

  VehicleLocation(
      {required this.vin,
      required this.model,
      required this.brand,
      required this.latitude,
      required this.longitude,
      required this.locked,
  });

  Map<String, dynamic> toMap() {
    return {
      'vin': vin,
      'model': model,
      'brand': brand,
      'latitude': latitude,
      'longitude': longitude,
      'locked': locked,
    };
  }
}
