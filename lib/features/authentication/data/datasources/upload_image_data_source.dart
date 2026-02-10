import 'dart:io';

import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/error_message_model.dart';

class UploadImageDataSource {
  final Dio dio;

  UploadImageDataSource(this.dio);

  Future<String> uploadImage(File image) async {
    try {
      final formData = FormData.fromMap({
        ApiKeys.file: await MultipartFile.fromFile(image.path),
      });
      final response = await dio.post(ApiConstance.uploadImage, data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data[ApiKeys.imageUrl];
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }
}
