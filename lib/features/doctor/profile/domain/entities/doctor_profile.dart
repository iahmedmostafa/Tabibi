import 'package:equatable/equatable.dart';

class DoctorProfile extends Equatable {
  final String id;
  final String name;
  final String specialty;
  final String doctorId;
  final double rating;
  final int reviews;
  final int yearsOfExperience;
  final String clinicName;
  final String workingHours;

  const DoctorProfile({
    required this.id,
    required this.name,
    required this.specialty,
    required this.doctorId,
    required this.rating,
    required this.reviews,
    required this.yearsOfExperience,
    required this.clinicName,
    required this.workingHours,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  @override
  List<Object?> get props => [id, name, specialty, doctorId];
}
