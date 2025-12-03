import 'package:tabibi/features/home/data/models/work_schedule_dto.dart';

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
  final String? clinicAddress;
  final String? clinicPhoneNumber;
  final String? clinicCity;
  final List<WorkScheduleDto>? schedule;
  //final String? clinicWorkingHours;

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
    this.clinicAddress,
    this.clinicPhoneNumber,
    this.clinicCity,
    this.schedule,
    //this.clinicWorkingHours,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'name': name,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'consultationFee': consultationFee,
      'credentialImageUrl': credentialImageUrl,
      'yearsOfExperience': yearsOfExperience,
      'departmentId': departmentId,
      'clinic': {
        'name': clinicName,
        'address': clinicAddress,
        'phoneNumber': clinicPhoneNumber,
        'cityId': clinicCity,
      },
      'schedule': schedule?.map((e) => e.toJson()).toList(),
      //'clinicWorkingHours': clinicWorkingHours,
    };

    // Remove nulls from top level
    data.removeWhere((key, value) => value == null);

    // Remove nulls from clinic object
    if (data['clinic'] != null && data['clinic'] is Map) {
      (data['clinic'] as Map).removeWhere((key, value) => value == null);
    }

    return data;
  }
}
