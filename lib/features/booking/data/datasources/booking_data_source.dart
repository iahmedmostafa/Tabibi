import 'package:dio/dio.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/features/booking/data/models/booking_model.dart';
import 'package:tabibi/features/booking/data/models/upcoming_booking_summary_model.dart';

abstract class BaseBookingDataSource {
  Future<List<BookingModel>> getMyBooking(int status);
  Future<UpcomingBookingSummaryModel> getNextUpcomingBooking();
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

  @override
  Future<UpcomingBookingSummaryModel> getNextUpcomingBooking() async {
    try {
      final response = await dio.get(ApiConstance.nextUpcomingBooking);
      return UpcomingBookingSummaryModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
