import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_config.dart';
import 'package:tabibi/core/network/error_message_model.dart';
import 'package:tabibi/features/ai_symptom_checker/data/models/symptom_check_result_model.dart';

abstract class BaseAiRemoteDataSource {
  Future<SymptomCheckResultModel> checkSymptoms(String symptomsText);
}

class AiRemoteDataSourceImpl implements BaseAiRemoteDataSource {
  final Dio dio;

  AiRemoteDataSourceImpl() : dio = Dio();

  @override
  Future<SymptomCheckResultModel> checkSymptoms(String symptomsText) async {
    try {
      final String url = "${await ApiConfig.getBaseUrl()}/chat/";

      final response = await dio.post(url, data: {'message': symptomsText});

      if (response.statusCode == 200 || response.statusCode == 201) {
        dynamic data = response.data;
        if (data is String) {
          data = jsonDecode(data);
        }
        return SymptomCheckResultModel.fromJson(data);
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
