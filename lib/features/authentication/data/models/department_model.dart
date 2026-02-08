// class DepartmentModel {
//   final List<ItemModel> items;
//   final int page;
//   final int pageSize;
//   final int totalCount;
//   final int totalPages;
//   final bool hasPreviousPage;
//   final bool hasNextPage;
//
//   const DepartmentModel({
//     required this.items,
//     required this.page,
//     required this.pageSize,
//     required this.totalCount,
//     required this.totalPages,
//     required this.hasPreviousPage,
//     required this.hasNextPage,
//   });
//
//   factory DepartmentModel.fromJson(Map<String, dynamic> json) {
//     return DepartmentModel(
//       items: (json['items'] as List<dynamic>)
//           .map((e) => ItemModel.fromJson(e))
//           .toList(),
//       page: json['page'] as int,
//       pageSize: json['pageSize'] as int,
//       totalCount: json['totalCount'] as int,
//       totalPages: json['totalPages'] as int,
//       hasPreviousPage: json['hasPreviousPage'] as bool,
//       hasNextPage: json['hasNextPage'] as bool,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'items': items.map((e) => e.toJson()).toList(),
//       'page': page,
//       'pageSize': pageSize,
//       'totalCount': totalCount,
//       'totalPages': totalPages,
//       'hasPreviousPage': hasPreviousPage,
//       'hasNextPage': hasNextPage,
//     };
//   }
// }
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
