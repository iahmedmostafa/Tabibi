import 'package:tabibi/features/doctor/patients/domain/entities/patient.dart';

class MockPatientData {
  static Patient getSarahJohnson() {
    return const Patient(
      id: '1',
      name: 'Sarah Johnson',
      patientId: '#PAT-2847',
      age: 45,
      gender: 'Female',
      bloodGroup: 'O+',
      weight: '68 kg',
      phone: '+1 (555) 123-4567',
      email: 'sarah.j@email.com',
      address: '123 Main St, Seattle, WA 98101',
      medicalHistory: [
        MedicalCondition(
          name: 'Hypertension',
          since: '2020',
          status: 'Managed',
        ),
        MedicalCondition(
          name: 'Type 2 Diabetes',
          since: '2018',
          status: 'Controlled',
        ),
      ],
      allergies: ['Penicillin', 'Peanuts'],
      previousVisits: [
        Visit(title: 'Regular Checkup', date: 'Oct 15, 2025'),
        Visit(title: 'Hypertension Follow-up', date: 'Aug 22, 2025'),
        Visit(title: 'Annual Physical', date: 'Jun 10, 2025'),
      ],
    );
  }
}
