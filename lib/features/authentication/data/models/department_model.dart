
class DepartmentModel {
  final String id;
  final String name;
  final String? imageUrl;

  const DepartmentModel({required this.id, required this.name, this.imageUrl});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'imageUrl': imageUrl};
  }
}
