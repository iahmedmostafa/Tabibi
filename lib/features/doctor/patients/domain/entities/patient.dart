import 'package:equatable/equatable.dart';

class Patient extends Equatable {
  final String id;
  final String name;
  final String patientId;
  final int age;
  final String gender;
  final String bloodGroup;
  final String weight;
  final String phone;
  final String email;
  final String address;
  final List<MedicalCondition> medicalHistory;
  final List<String> allergies;
  final List<Visit> previousVisits;

  const Patient({
    required this.id,
    required this.name,
    required this.patientId,
    required this.age,
    required this.gender,
    required this.bloodGroup,
    required this.weight,
    required this.phone,
    required this.email,
    required this.address,
    required this.medicalHistory,
    required this.allergies,
    required this.previousVisits,
  });

  @override
  List<Object?> get props => [id, name, patientId];
}

class MedicalCondition extends Equatable {
  final String name;
  final String since;
  final String status; // Managed, Controlled

  const MedicalCondition({
    required this.name,
    required this.since,
    required this.status,
  });

  @override
  List<Object?> get props => [name, since, status];
}

class Visit extends Equatable {
  final String title;
  final String date;

  const Visit({required this.title, required this.date});

  @override
  List<Object?> get props => [title, date];
}
