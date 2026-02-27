class DoctorModel {
  final String id;
  final String name;
  final String? avatarUrl;
  final double consultationFee;
  final int yearsOfExperience;
  final String? address;
  final String? department;
  final double? latitude;
  final double? longitude;
  final bool isFavorited;

  DoctorModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.consultationFee,
    required this.yearsOfExperience,
    this.address,
    this.department,
    this.latitude,
    this.longitude,
    this.isFavorited = false,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    // Helper to safely parse numbers
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    // Helper to extract department name
    String? parseDepartment(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is Map) return value['name']?.toString();
      return value.toString();
    }

    // Helper to parse lat/long
    double? parseCoord(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    return DoctorModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString(),
      consultationFee: parseDouble(json['consultationFee']),
      yearsOfExperience: parseInt(json['yearsOfExperience']),
      address: json['address']?.toString(),
      department: parseDepartment(json['department']),
      latitude: parseCoord(json['latitude']),
      longitude: parseCoord(json['longitude']),
      isFavorited: json['isFavorited'] == true,
    );
  }
}

extension DoctorX on DoctorModel {
  String get departmentName => department ?? '';
}
