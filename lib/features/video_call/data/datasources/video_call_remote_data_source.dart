import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/features/video_call/data/models/video_call_model.dart';

abstract class VideoCallRemoteDataSource {
  Future<VideoCallModel> getVideoToken(String bookingId);
}

class VideoCallRemoteDataSourceImpl implements VideoCallRemoteDataSource {
  final Dio dio;

  VideoCallRemoteDataSourceImpl({required this.dio});

  @override
  Future<VideoCallModel> getVideoToken(String bookingId) async {
    try {
      final response = await dio.get(ApiConstance.videoToken(bookingId));
      if (response.statusCode == 200) {
        return VideoCallModel.fromJson(response.data);
      } else {
        throw ServerFailure(
          response.data['message'] ?? 'Failed to get video token',
        );
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw const ServerFailure('Network Error');
    } catch (e) {
      log('Error getting video token: $e');
      throw ServerFailure(e.toString());
    }
  }
}
