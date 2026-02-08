class ClinicModel {
  final int id;
  final String name;
  final String address;
  final String phone;
  final int cityId;

  ClinicModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.cityId,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      cityId: json['cityId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'cityId': cityId,
    };
  }
}
