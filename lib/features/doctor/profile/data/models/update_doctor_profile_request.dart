class UpdateDoctorProfileRequest {
  final String name;
  final String? avatarUrl;
  final int gender;
  final String? dateOfBirth;
  final String? bio;
  final String consultationFee;
  final String credentialImageUrl;
  final String yearsOfExperience;
  final String departmentId;
  final UpdateClinicRequest clinic;
  final List<UpdateScheduleRequest> schedule;

  const UpdateDoctorProfileRequest({
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

  Map<String, dynamic> toJson() => {
        'name': name,
        'avatarUrl': avatarUrl,
        'gender': gender,
        'dateOfBirth': dateOfBirth,
        'bio': bio,
        'consultationFee': consultationFee,
        'credentialImageUrl': credentialImageUrl,
        'yearsOfExperience': yearsOfExperience,
        'departmentId': departmentId,
        'clinic': clinic.toJson(),
        'schedule': schedule.map((s) => s.toJson()).toList(),
      };
}

class UpdateClinicRequest {
  final String name;
  final String? description;
  final String address;
  final String? imageUrl;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final String cityId;

  const UpdateClinicRequest({
    required this.name,
    this.description,
    required this.address,
    this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.cityId,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'address': address,
        'imageUrl': imageUrl,
        'latitude': latitude,
        'longitude': longitude,
        'phoneNumber': phoneNumber,
        'cityId': cityId,
      };
}

class UpdateScheduleRequest {
  final int dayOfWeek;
  final String openTime;
  final String closeTime;

  const UpdateScheduleRequest({
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
  });

  Map<String, dynamic> toJson() => {
        'dayOfWeek': dayOfWeek,
        'openTime': openTime,
        'closeTime': closeTime,
      };
}
