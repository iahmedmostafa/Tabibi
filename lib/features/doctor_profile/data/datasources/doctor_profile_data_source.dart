import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/error_message_model.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/doctor_profile/data/datasources/base_doctor_profile_data_source.dart';
import 'package:tabibi/features/doctor_profile/data/models/doctor_profile_model.dart';
import 'package:tabibi/features/doctor_profile/domain/entities/update_doctor_profile_params.dart';

class DoctorProfileDataSource implements BaseDoctorProfileDataSource {
  final Dio dio;

  DoctorProfileDataSource(this.dio);

  @override
  Future<DoctorProfileModel> getDoctorProfile() async {
    try {
      final response = await dio.get(ApiConstance.doctorProfile);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DoctorProfileModel.fromJson(
          _asMap(response.data),
        );
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(_asMap(response.data)),
        );
      }
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }

  @override
  Future<String> updateDoctorProfile(UpdateDoctorProfileParams params) async {
    try {
      final response = await dio.put(
        ApiConstance.updateDoctorProfile,
        data: params.toJson(),
      );

      if (response.statusCode == 204) {
        return "The Account Information Is Uploaded Successfully";
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(_asMap(response.data)),
        );
      }
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }

  @override
  Future<DoctorStatus> doctorStatus() async {
    try {
      final response = await dio.get(ApiConstance.doctorStatus);

      if (response.statusCode == 200) {
        return _doctorStatusFromJson(_asMap(response.data));
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(_asMap(response.data)),
        );
      }
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return {
      'status': 500,
      'detail': data?.toString() ?? 'Unexpected server response',
    };
  }

  DoctorStatus _doctorStatusFromJson(Map<String, dynamic> json) {
    final statusCode = _toInt(json['statusCode']);
    if (statusCode != null &&
        statusCode >= 0 &&
        statusCode < DoctorStatus.values.length) {
      return DoctorStatus.values[statusCode];
    }

    final status = json['status']?.toString().toLowerCase();
    return DoctorStatus.values.firstWhere(
      (value) => value.name.toLowerCase() == status,
      orElse: () => DoctorStatus.Pending,
    );
  }

  int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
