import 'package:dio/dio.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/network/error_message_model.dart';

abstract class FavoriteRemoteDataSource {
  Future<List<DoctorModel>> getFavorites();
  Future<void> addFavorite(String doctorId);
  Future<void> removeFavorite(String doctorId);
}

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  final Dio dio;

  FavoriteRemoteDataSourceImpl(this.dio);

  @override
  Future<List<DoctorModel>> getFavorites() async {
    try {
      final response = await dio.get(ApiConstance.favorites);
      if (response.statusCode == 200) {
        return List<DoctorModel>.from(
          (response.data as List).map((e) => DoctorModel.fromJson(e)),
        );
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(e.response?.data ?? {}),
        );
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            statusCode: 500,
            statusMessage: e.message ?? 'Unknown Error',
            errors: {},
          ),
        );
      }
    }
  }

  @override
  Future<void> addFavorite(String doctorId) async {
    try {
      final response = await dio.post(
        ApiConstance.favorites,
        data: {'doctorId': doctorId},
      );
      if (response.statusCode != 200 &&
          response.statusCode != 201 &&
          response.statusCode != 204) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(e.response?.data ?? {}),
        );
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            statusCode: 500,
            statusMessage: e.message ?? 'Unknown Error',
            errors: {},
          ),
        );
      }
    }
  }

  @override
  Future<void> removeFavorite(String doctorId) async {
    try {
      final response = await dio.delete(ApiConstance.removeFavorite(doctorId));
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(e.response?.data ?? {}),
        );
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            statusCode: 500,
            statusMessage: e.message ?? 'Unknown Error',
            errors: {},
          ),
        );
      }
    }
  }
}
