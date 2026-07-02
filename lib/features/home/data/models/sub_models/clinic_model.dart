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
    final latRaw = json['latitude'];
    double parsedLat = 0.0;
    if (latRaw is num) {
      parsedLat = latRaw.toDouble();
    } else if (latRaw is String) {
      parsedLat = double.tryParse(latRaw) ?? 0.0;
    }

    final lngRaw = json['longitude'];
    double parsedLng = 0.0;
    if (lngRaw is num) {
      parsedLng = lngRaw.toDouble();
    } else if (lngRaw is String) {
      parsedLng = double.tryParse(lngRaw) ?? 0.0;
    }

    final cityMap = json['city'] as Map<String, dynamic>?;
    final cityId = json['cityId'] as String? ?? cityMap?['id'] as String? ?? '';

    return ClinicModel(
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      address: json['address'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      latitude: parsedLat,
      longitude: parsedLng,
      phoneNumber: json['phoneNumber'] as String? ?? '',
      cityId: cityId,
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
