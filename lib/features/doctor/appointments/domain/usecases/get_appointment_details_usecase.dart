import 'package:tabibi/features/doctor/appointments/domain/entities/appointment_details_entity.dart';
import 'package:tabibi/features/doctor/appointments/domain/repositories/appointments_repository.dart';

class GetAppointmentDetailsUseCase {
  final AppointmentsRepository repository;

  GetAppointmentDetailsUseCase(this.repository);

  Future<AppointmentDetailsEntity> call(String id) {
    return repository.getAppointmentDetails(id);
  }
}
