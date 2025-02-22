abstract class VehicleState {}

class VehicleInitialState extends VehicleState {}

class VehicleLoadingState extends VehicleState {}

class VehicleLoadedState extends VehicleState {
  final String successMessage;

  VehicleLoadedState({required this.successMessage});
}

class VehicleErrorState extends VehicleState {
  final String errorMessage;

  VehicleErrorState({required this.errorMessage});
}
