import 'package:dio/dio.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/features/booking/data/models/booking_model.dart';

abstract class BaseBookingDataSource {
  Future<List<BookingModel>> getMyBooking(int status);
}

class BookingDataSource implements BaseBookingDataSource {
  final Dio dio;

  BookingDataSource(this.dio);
  @override
  Future<List<BookingModel>> getMyBooking(int status) async {
    try {
      final response = await dio.get(
        ApiConstance.mybooking,
        queryParameters: {"status": status},
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
