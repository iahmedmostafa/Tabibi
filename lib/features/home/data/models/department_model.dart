class DepartmentModel {
  final List<Department> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  DepartmentModel({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      items: (json['items'] as List)
          .map((e) => Department.fromJson(e))
          .toList(),
      page: json['page'],
      pageSize: json['pageSize'],
      totalCount: json['totalCount'],
      totalPages: json['totalPages'],
      hasPreviousPage: json['hasPreviousPage'],
      hasNextPage: json['hasNextPage'],
    );
  }
}

class Department {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final DateTime createdAtUtc;

  Department({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.createdAtUtc,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      createdAtUtc: DateTime.parse(json['createdAtUtc']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'createdAtUtc': createdAtUtc.toIso8601String(),
    };
  }
}

////////////////////
