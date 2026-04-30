import 'package:tabibi/features/doctor/appointments/domain/entities/appointment_details_entity.dart';
import 'package:tabibi/features/doctor/patients/domain/entities/patient.dart'
    as doctor_patient;

class AppointmentPatientMapper {
  const AppointmentPatientMapper._();

  static doctor_patient.Patient toDoctorPatient(PatientEntity patient) {
    return doctor_patient.Patient(
      id: patient.id,
      name: patient.name,
      patientId: patient.id.isNotEmpty ? '#${patient.id}' : '#PATIENT',
      age: _calculateAge(patient.dateOfBirth),
      gender: _genderLabel(patient.gender),
      bloodGroup: 'Not specified',
      weight: 'Not specified',
      phone: 'Not specified',
      email: patient.email ?? 'Not specified',
      address: patient.city ?? 'Not specified',
      medicalHistory: const [],
      allergies: const [],
      previousVisits: const [],
    );
  }

  static int _calculateAge(DateTime? dateOfBirth) {
    if (dateOfBirth == null) return 0;
    final now = DateTime.now();
    var age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  static String _genderLabel(int? gender) {
    switch (gender) {
      case 1:
        return 'Male';
      case 2:
        return 'Female';
      default:
        return 'Not specified';
    }
  }
}
