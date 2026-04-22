import 'package:tabibi/features/doctor/appointments/domain/entities/appointment_details_entity.dart';

abstract class AppointmentsRepository {
  Future<AppointmentDetailsEntity> getAppointmentDetails(String id);
}
