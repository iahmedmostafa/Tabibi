import 'package:tabibi/features/doctor_profile/domain/entities/doctor_profile.dart';

class ClinicModel extends Clinic {
  const ClinicModel({
    required super.name,
    super.description,
    required super.address,
    super.imageUrl,
    required super.latitude,
    required super.longitude,
    required super.phoneNumber,
    required super.cityId,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String,
      imageUrl: json['imageUrl'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      phoneNumber: json['phoneNumber'] as String,
      cityId: json['cityId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
}
