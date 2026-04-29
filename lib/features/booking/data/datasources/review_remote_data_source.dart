import 'package:dio/dio.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/features/booking/data/models/create_review_params.dart';

abstract class ReviewRemoteDataSource {
  Future<void> createReview(CreateReviewParams params);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final Dio dio;

  ReviewRemoteDataSourceImpl(this.dio);

  @override
  Future<void> createReview(CreateReviewParams params) async {
    try {
      await dio.post(ApiConstance.reviews, data: params.toJson());
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
