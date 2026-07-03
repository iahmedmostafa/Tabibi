class DoctorProfile {
  final String name;
  final String email;
  final String? avatarUrl;
  final int gender;
  final String? dateOfBirth;
  final String? bio;
  final double consultationFee;
  final String credentialImageUrl;
  final int yearsOfExperience;
  final String departmentId;
  final String departmentName;
  final Clinic clinic;
  final List<Schedule> schedule;

  const DoctorProfile({
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.gender,
    this.dateOfBirth,
    this.bio,
    required this.consultationFee,
    required this.credentialImageUrl,
    required this.yearsOfExperience,
    required this.departmentId,
    required this.departmentName,
    required this.clinic,
    required this.schedule,
  });

  String get initials {
    if (name.isEmpty) return 'DR';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      final first = parts[0].isNotEmpty ? parts[0][0] : '';
      final second = parts[1].isNotEmpty ? parts[1][0] : '';
      return '$first$second'.toUpperCase();
    }
    return name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();
  }
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
