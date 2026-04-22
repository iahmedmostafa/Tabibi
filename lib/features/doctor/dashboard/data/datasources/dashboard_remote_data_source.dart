import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/error_message_model.dart';
import 'package:tabibi/features/doctor/dashboard/data/models/dashboard_response_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardResponseModel> getDoctorDashboard();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;

  DashboardRemoteDataSourceImpl(this.dio);

  @override
  Future<DashboardResponseModel> getDoctorDashboard() async {
    try {
      final response = await dio.get(ApiConstance.doctorHome);

      if (response.statusCode == 200) {
        return DashboardResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
        );
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            statusMessage: e.message ?? "Unknown Error",
            statusCode: 500,
          ),
        );
      }
    }
  }
}
