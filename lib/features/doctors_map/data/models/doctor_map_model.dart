class DoctorMapModel {
  final String id;
  final String name;
  final String? department;
  final String? clinicName;
  final double latitude;
  final double longitude;
  final String? avatarUrl;
  final double consultationFee;

  DoctorMapModel({
    required this.id,
    required this.name,
    this.department,
    this.clinicName,
    required this.latitude,
    required this.longitude,
    this.avatarUrl,
    required this.consultationFee,
  });

  factory DoctorMapModel.fromJson(Map<String, dynamic> json) {
    return DoctorMapModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      department: json['department'],
      clinicName: json['clinicName'],
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      avatarUrl: json['avatarUrl'],
      consultationFee: (json['consultationFee'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'department': department,
      'clinicName': clinicName,
      'latitude': latitude,
      'longitude': longitude,
      'avatarUrl': avatarUrl,
      'consultationFee': consultationFee,
    };
  }
}
