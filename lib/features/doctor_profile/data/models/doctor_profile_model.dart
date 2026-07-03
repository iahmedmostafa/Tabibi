import 'package:tabibi/features/doctor_profile/domain/entities/doctor_profile.dart';

class DoctorProfileModel extends DoctorProfile {
  const DoctorProfileModel({
    required super.name,
    required super.email,
    super.avatarUrl,
    required super.gender,
    super.dateOfBirth,
    super.bio,
    required super.consultationFee,
    required super.credentialImageUrl,
    required super.yearsOfExperience,
    required super.departmentId,
    required super.departmentName,
    required super.clinic,
    required super.schedule,
  });

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    final source = _unwrapPayload(json);
    final sourceDeptMap = source['department'] as Map<String, dynamic>?;
    final deptId = source['departmentId'] as String? ??
        sourceDeptMap?['id'] as String? ??
        '';
    final deptName = sourceDeptMap?['name'] as String? ?? '';

    return DoctorProfileModel(
      name: source['name'] as String? ?? '',
      email: source['email'] as String? ?? '',
      avatarUrl: source['avatarUrl'] as String?,
      gender: _toInt(source['gender'], fallback: 1),
      dateOfBirth: source['dateOfBirth'] as String?,
      bio: source['bio'] as String?,
      consultationFee: _toDouble(source['consultationFee']),
      credentialImageUrl: source['credentialImageUrl'] as String? ?? '',
      yearsOfExperience: _toInt(source['yearsOfExperience']),
      departmentId: deptId,
      departmentName: deptName,
      clinic: source['clinic'] is Map<String, dynamic>
          ? _clinicFromJson(source['clinic'] as Map<String, dynamic>)
          : const Clinic(
              name: '',
              address: '',
              latitude: 0.0,
              longitude: 0.0,
              phoneNumber: '',
              cityId: '',
            ),
      schedule: (source['schedule'] as List<dynamic>?)
              ?.whereType<Map>()
              .map((item) => _scheduleFromJson(Map<String, dynamic>.from(item)))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'bio': bio,
      'consultationFee': consultationFee,
      'credentialImageUrl': credentialImageUrl,
      'yearsOfExperience': yearsOfExperience,
      'departmentId': departmentId,
      'departmentName': departmentName,
      'clinic': _clinicToJson(clinic),
      'schedule': schedule.map(_scheduleToJson).toList(),
    };
  }

  static Map<String, dynamic> _unwrapPayload(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) return data;
    return json;
  }

  static Clinic _clinicFromJson(Map<String, dynamic> json) {
    final cityMap = json['city'] as Map<String, dynamic>?;
    return Clinic(
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      address: json['address'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      phoneNumber: json['phoneNumber'] as String? ?? '',
      cityId: json['cityId'] as String? ?? cityMap?['id'] as String? ?? '',
    );
  }

  static Schedule _scheduleFromJson(Map<String, dynamic> json) {
    return Schedule(
      dayOfWeek: _toInt(json['dayOfWeek']),
      openTime: json['openTime'] as String? ?? '',
      closeTime: json['closeTime'] as String? ?? '',
    );
  }

  static Map<String, dynamic> _clinicToJson(Clinic clinic) {
    return {
      'name': clinic.name,
      'description': clinic.description,
      'address': clinic.address,
      'imageUrl': clinic.imageUrl,
      'latitude': clinic.latitude,
      'longitude': clinic.longitude,
      'phoneNumber': clinic.phoneNumber,
      'cityId': clinic.cityId,
    };
  }

  static Map<String, dynamic> _scheduleToJson(Schedule schedule) {
    return {
      'dayOfWeek': schedule.dayOfWeek,
      'openTime': schedule.openTime,
      'closeTime': schedule.closeTime,
    };
  }

  static int _toInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  static double _toDouble(dynamic value, {double fallback = 0.0}) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }
}
