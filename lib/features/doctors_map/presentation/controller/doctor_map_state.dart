// Since I didn't create a separate domain model (Entity), I'll use the data model for simplicity or move it to domain if required.
// For now, let's use the one in data/models.

import '../../data/models/doctor_map_model.dart';

abstract class DoctorMapState {}

class DoctorMapInitial extends DoctorMapState {}

class DoctorMapLoading extends DoctorMapState {}

class DoctorMapSuccess extends DoctorMapState {
  final List<DoctorMapModel> doctors;
  DoctorMapSuccess(this.doctors);
}

class DoctorMapError extends DoctorMapState {
  final String message;
  DoctorMapError(this.message);
}
