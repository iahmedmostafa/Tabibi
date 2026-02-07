class DoctorProfile {
  final String name;
  final String? avatarUrl;
  final int gender;
  final String? dateOfBirth;
  final String? bio;
  final double consultationFee;
  final String credentialImageUrl;
  final int yearsOfExperience;
  final String departmentId;
  final Clinic clinic;
  final List<Schedule> schedule;

  const DoctorProfile({
    required this.name,
    this.avatarUrl,
    required this.gender,
    this.dateOfBirth,
    this.bio,
    required this.consultationFee,
    required this.credentialImageUrl,
    required this.yearsOfExperience,
    required this.departmentId,
    required this.clinic,
    required this.schedule,
  });
}

class Clinic {
  final String name;
  final String? description;
  final String address;
  final String? imageUrl;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final String cityId;

  const Clinic({
    required this.name,
    this.description,
    required this.address,
    this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.cityId,
  });
}

class Schedule {
  final int dayOfWeek;
  final String openTime;
  final String closeTime;

  const Schedule({
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
  });
}
