import 'package:dio/dio.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/features/doctor_details/data/models/doctor_details_model.dart';

abstract class DoctorDetailsRemoteDataSource {
  Future<DoctorDetailsModel> getDoctorDetails(String id);
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
}
