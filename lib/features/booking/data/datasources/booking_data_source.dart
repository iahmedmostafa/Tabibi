import 'package:dio/dio.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/dio_interceptors.dart';
import 'package:tabibi/features/booking/data/models/booking_model.dart';

abstract class BaseBookingDataSource {
  Future<List<BookingModel>> getMyBooking(String type);
}

class BookingDataSource implements BaseBookingDataSource {
  final Dio dio;

  BookingDataSource(this.dio) {
    dio.options.baseUrl = ApiConstance.baseUrl;
    dio.interceptors.add(DioInterceptors(dio).interceptor);
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);
  }
  @override
  Future<List<BookingModel>> getMyBooking(String type) async {
    try {
      final response = await dio.get(
        ApiConstance.mybooking,
        queryParameters: {"type": type},
      );
      return (response.data as List)
          .map((e) => BookingModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
