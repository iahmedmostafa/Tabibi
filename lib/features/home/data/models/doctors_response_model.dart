import 'doctor_model.dart';

/// Model for paginated doctors API response
class DoctorsResponseModel {
  final List<DoctorModel> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const DoctorsResponseModel({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory DoctorsResponseModel.fromJson(Map<String, dynamic> json) {
    return DoctorsResponseModel(
      items:
          (json['items'] as List?)
              ?.map((e) => DoctorModel.fromJson(e))
              .toList() ??
          [],
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalCount: json['totalCount'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
      hasNextPage: json['hasNextPage'] ?? false,
    );
  }
}
