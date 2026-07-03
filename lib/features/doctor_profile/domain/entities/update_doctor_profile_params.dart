import 'package:tabibi/features/doctor_profile/domain/entities/doctor_profile.dart';

class UpdateDoctorProfileParams {
  final String? name;
  final String? bio;
  final String? avatarUrl;
  final int? gender;
  final String? dateOfBirth;
  final double? consultationFee;
  final String? credentialImageUrl;
  final int? yearsOfExperience;
  final String? departmentId;
  final String? clinicName;
  final String? clinicImageUrl;
  final String? clinicAddress;
  final String? clinicPhoneNumber;
  final String? clinicCityId;
  final double? clinicLatitude;
  final double? clinicLongitude;
  final List<Schedule>? schedule;

  const UpdateDoctorProfileParams({
    this.name,
    this.bio,
    this.avatarUrl,
    this.gender,
    this.dateOfBirth,
    this.consultationFee,
    this.credentialImageUrl,
    this.yearsOfExperience,
    this.departmentId,
    this.clinicName,
    this.clinicImageUrl,
    this.clinicAddress,
    this.clinicPhoneNumber,
    this.clinicCityId,
    this.clinicLatitude,
    this.clinicLongitude,
    this.schedule,
  });

  factory UpdateDoctorProfileParams.fromProfile(
    DoctorProfile profile, {
    String? name,
    String? bio,
    String? avatarUrl,
    int? gender,
    String? dateOfBirth,
    double? consultationFee,
    String? credentialImageUrl,
    int? yearsOfExperience,
    String? departmentId,
    String? clinicName,
    String? clinicImageUrl,
    String? clinicAddress,
    String? clinicPhoneNumber,
    String? clinicCityId,
    double? clinicLatitude,
    double? clinicLongitude,
    List<Schedule>? schedule,
  }) {
    return UpdateDoctorProfileParams(
      name: name ?? profile.name,
      bio: bio ?? profile.bio,
      avatarUrl: avatarUrl ?? profile.avatarUrl,
      gender: gender ?? profile.gender,
      dateOfBirth: dateOfBirth ?? profile.dateOfBirth,
      consultationFee: consultationFee ?? profile.consultationFee,
      credentialImageUrl: credentialImageUrl ?? profile.credentialImageUrl,
      yearsOfExperience: yearsOfExperience ?? profile.yearsOfExperience,
      departmentId: departmentId ?? profile.departmentId,
      clinicName: clinicName ?? profile.clinic.name,
      clinicImageUrl: clinicImageUrl ?? profile.clinic.imageUrl,
      clinicAddress: clinicAddress ?? profile.clinic.address,
      clinicPhoneNumber: clinicPhoneNumber ?? profile.clinic.phoneNumber,
      clinicCityId: clinicCityId ?? profile.clinic.cityId,
      clinicLatitude: clinicLatitude ?? profile.clinic.latitude,
      clinicLongitude: clinicLongitude ?? profile.clinic.longitude,
      schedule: schedule ?? profile.schedule,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'name': name,
      'bio': bio,
      'avatarUrl': avatarUrl ?? '',
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'consultationFee': consultationFee,
      'credentialImageUrl': credentialImageUrl,
      'yearsOfExperience': yearsOfExperience,
      'departmentId': departmentId,
      'clinic': {
        'name': clinicName,
        'imageUrl': clinicImageUrl,
        'address': clinicAddress,
        'phoneNumber': clinicPhoneNumber,
        'cityId': clinicCityId,
        'latitude': clinicLatitude,
        'longitude': clinicLongitude,
      },
      'schedule': schedule?.map(_scheduleToJson).toList(),
    }..removeWhere((_, value) => value == null);

    if (data['clinic'] is Map<String, dynamic>) {
      (data['clinic'] as Map<String, dynamic>).removeWhere(
        (_, value) => value == null,
      );
    }

    return data;
  }

  Map<String, dynamic> _scheduleToJson(Schedule schedule) {
    return {
      'dayOfWeek': schedule.dayOfWeek,
      'openTime': schedule.openTime,
      'closeTime': schedule.closeTime,
    };
  }
}
