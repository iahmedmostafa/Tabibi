import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/doctor_map_repository.dart';
import 'doctor_map_state.dart';

class DoctorMapCubit extends Cubit<DoctorMapState> {
  final DoctorMapRepository repository;

  DoctorMapCubit(this.repository) : super(DoctorMapInitial());

  Future<void> getDoctorsOnMap({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
  }) async {
    emit(DoctorMapLoading());
    try {
      final doctors = await repository.getDoctorsOnMap(
        minLat: minLat,
        maxLat: maxLat,
        minLng: minLng,
        maxLng: maxLng,
      );
      emit(DoctorMapSuccess(doctors));
    } catch (e) {
      emit(DoctorMapError(e.toString()));
    }
  }
}
