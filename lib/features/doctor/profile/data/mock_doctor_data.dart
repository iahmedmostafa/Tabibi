import 'package:tabibi/features/doctor/profile/domain/entities/doctor_profile.dart';

class MockDoctorData {
  static DoctorProfile getDoctorProfile() {
    return const DoctorProfile(
      id: '1',
      name: 'Dr. David Miller',
      specialty: 'Cardiologist',
      doctorId: '#DOC-1847',
      rating: 4.9,
      reviews: 151,
      yearsOfExperience: 8,
      clinicName: 'Medical Center',
      workingHours: '9 AM - 5 PM',
    );
  }
}
