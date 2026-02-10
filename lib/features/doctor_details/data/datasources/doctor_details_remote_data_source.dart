import 'package:dio/dio.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/features/doctor_details/data/models/doctor_details_model.dart';
import 'package:tabibi/features/doctor_details/data/models/paginated_reviews_model.dart';

abstract class DoctorDetailsRemoteDataSource {
  Future<DoctorDetailsModel> getDoctorDetails(String id);
  Future<PaginatedReviewsModel> getDoctorReviews({
    required String doctorId,
    required int page,
    required int pageSize,
  });
}

class DoctorDetailsRemoteDataSourceImpl
    implements DoctorDetailsRemoteDataSource {
  final Dio dio;

  DoctorDetailsRemoteDataSourceImpl(this.dio);

  @override
  Future<DoctorDetailsModel> getDoctorDetails(String id) async {
    final response = await dio.get("${ApiConstance.doctorDetails}/$id");

    if (response.statusCode == 200) {
      return DoctorDetailsModel.fromJson(response.data);
    } else {
      throw Exception("Failed to load doctor details");
    }
  }

  @override
  Future<PaginatedReviewsModel> getDoctorReviews({
    required String doctorId,
    required int page,
    required int pageSize,
  }) async {
    final response = await dio.get(
      "${ApiConstance.doctorReviews}$doctorId",
      queryParameters: {'page': page, 'pageSize': pageSize},
    );

    try {
      if (response.statusCode == 200) {
        return PaginatedReviewsModel.fromJson(response.data);
      } else {
        throw Exception("Failed to load doctor reviews");
      }
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
