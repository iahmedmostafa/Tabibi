import 'package:dio/dio.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/features/booking/data/models/prescription_model.dart';

abstract class PrescriptionRemoteDataSource {
  Future<PrescriptionModel> getPrescription({required String bookingId});
}

class PrescriptionRemoteDataSourceImpl implements PrescriptionRemoteDataSource {
  final Dio dio;

  PrescriptionRemoteDataSourceImpl(this.dio);

  @override
  Future<PrescriptionModel> getPrescription({required String bookingId}) async {
    try {
      final response = await dio.get(ApiConstance.prescription(bookingId));
      return PrescriptionModel.fromJson(response.data);
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
