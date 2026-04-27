import 'package:tabibi/features/doctor/patients/domain/entities/patient.dart';

class CreatePrescriptionArgs {
  final String appointmentId;
  final Patient patient;

  const CreatePrescriptionArgs({
    required this.appointmentId,
    required this.patient,
  });
}
