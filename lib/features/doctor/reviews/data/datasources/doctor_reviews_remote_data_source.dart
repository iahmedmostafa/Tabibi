import 'package:dio/dio.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/features/doctor/reviews/data/models/doctor_reviews_response_model.dart';

abstract class DoctorReviewsRemoteDataSource {
  Future<DoctorReviewsResponseModel> getMyReviews({
    required int page,
    required int pageSize,
    int? rating,
  });
}

class DoctorReviewsRemoteDataSourceImpl implements DoctorReviewsRemoteDataSource {
  final Dio dio;

  DoctorReviewsRemoteDataSourceImpl(this.dio);

  @override
  Future<DoctorReviewsResponseModel> getMyReviews({
    required int page,
    required int pageSize,
    int? rating,
  }) async {
    try {
      final response = await dio.get(
        ApiConstance.myReviews,
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          if (rating != null) 'rating': rating,
        },
      );
      return DoctorReviewsResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
