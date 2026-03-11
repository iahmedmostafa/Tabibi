import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/features/booking/data/models/available_slot_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<List<AvailableSlotModel>> getAvailableSlots({
    required String doctorId,
    required String date,
  });

  Future<Map<String, dynamic>> createBooking({
    required String appointmentDate,
    required String doctorId,
    required int type,
  });

  Future<void> confirmPayment({required String bookingId});
  Future<void> cancelBooking({required String bookingId});
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final Dio dio;

  AppointmentRemoteDataSourceImpl(this.dio);

  @override
  Future<List<AvailableSlotModel>> getAvailableSlots({
    required String doctorId,
    required String date,
  }) async {
    try {
      final response = await dio.get(
        ApiConstance.availableSlots,
        queryParameters: {'doctorId': doctorId, 'date': date},
      );

      return (response.data as List)
          .map((e) => AvailableSlotModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  @override
  Future<Map<String, dynamic>> createBooking({
    required String appointmentDate,
    required String doctorId,
    required int type,
  }) async {
    try {
      final requestData = {
        'appointmentDate': appointmentDate,
        'doctorId': doctorId,
        'type': type,
      };
      final response = await dio.post(
        ApiConstance.booking,
        data: requestData,
        options: Options(
          headers: {'Content-Type': 'application/json-patch+json'},
        ),
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception("Failed to create booking: ${response.statusCode}");
      }
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> confirmPayment({required String bookingId}) async {
    try {
      await dio.patch(
        ApiConstance.confirmPayment(bookingId),
        options: Options(
          headers: {'Content-Type': 'application/json-patch+json'},
        ),
      );
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> cancelBooking({required String bookingId}) async {
    try {
      await dio.patch(
        ApiConstance.cancelBooking(bookingId),
        options: Options(
          headers: {'Content-Type': 'application/json-patch+json'},
        ),
      );
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
