class DoctorMapModel {
  final String id;
  final String name;
  final String? department;
  final String? specialty;
  final String? clinicName;
  final String? address;
  final double latitude;
  final double longitude;
  final String? avatarUrl;
  final double consultationFee;
  final double? rating;
  final int? reviewsCount;
  final double? distanceKm;

  DoctorMapModel({
    required this.id,
    required this.name,
    this.department,
    this.specialty,
    this.clinicName,
    this.address,
    required this.latitude,
    required this.longitude,
    this.avatarUrl,
    required this.consultationFee,
    this.rating,
    this.reviewsCount,
    this.distanceKm,
  });

  String get displaySpecialty => specialty ?? department ?? 'Specialist';

  String get displayLocation => clinicName ?? address ?? 'Location unavailable';

  String get displayFee => 'EGP ${consultationFee.toStringAsFixed(0)}';

  String get displayRating => rating != null ? rating!.toStringAsFixed(1) : '5.0';

  String get displayDistance => distanceKm != null
      ? '${distanceKm!.toStringAsFixed(distanceKm! >= 10 ? 0 : 1)} km'
      : '-- km';

  factory DoctorMapModel.fromJson(Map<String, dynamic> json) {
    final rawRating = json['rating'] ?? json['averageRating'];
    final rawReviews = json['reviewsCount'] ?? json['reviewCount'];
    final rawDistance = json['distanceKm'] ?? json['distance'];

    return DoctorMapModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      department: json['department']?.toString(),
      specialty: json['specialty']?.toString(),
      clinicName: json['clinicName']?.toString(),
      address: json['address']?.toString() ?? json['clinicAddress']?.toString(),
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      avatarUrl: json['avatarUrl']?.toString(),
      consultationFee: (json['consultationFee'] as num?)?.toDouble() ?? 0.0,
      rating: (rawRating as num?)?.toDouble(),
      reviewsCount: (rawReviews as num?)?.toInt(),
      distanceKm: (rawDistance as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'department': department,
      'specialty': specialty,
      'clinicName': clinicName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'avatarUrl': avatarUrl,
      'consultationFee': consultationFee,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'distanceKm': distanceKm,
    };
  }
}
