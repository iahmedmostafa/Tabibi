import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/error_message_model.dart';
import 'package:tabibi/features/doctor/earnings/data/models/earnings_models.dart';
import 'package:tabibi/features/doctor/earnings/domain/entities/earnings.dart';

abstract class EarningsRemoteDataSource {
  Future<EarningsSummaryModel> getSummary();
  Future<List<ChartDataPointModel>> getAnalytics(EarningsPeriod period);
  Future<EarningsTransactionsPageModel> getTransactions({
    required int page,
    required int pageSize,
  });
}

class EarningsRemoteDataSourceImpl implements EarningsRemoteDataSource {
  final Dio dio;

  EarningsRemoteDataSourceImpl(this.dio);

  @override
  Future<EarningsSummaryModel> getSummary() async {
    try {
      final response = await dio.get(
        ApiConstance.doctorEarningsSummary,
        queryParameters: {'status': 3},
      );
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return EarningsSummaryModel.fromJson(response.data);
      }
      _throwServerException(response.statusCode, response.data);
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }

  @override
  Future<List<ChartDataPointModel>> getAnalytics(EarningsPeriod period) async {
    try {
      final response = await dio.get(
        ApiConstance.doctorEarningsAnalytics,
        queryParameters: {'period': period.name, 'status': 3},
      );
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .whereType<Map<String, dynamic>>()
            .map(ChartDataPointModel.fromJson)
            .toList();
      }
      _throwServerException(response.statusCode, response.data);
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }

  @override
  Future<EarningsTransactionsPageModel> getTransactions({
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await dio.get(
        ApiConstance.doctorTransactions,
        queryParameters: {'page': page, 'pageSize': pageSize, 'status': 3},
      );
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return EarningsTransactionsPageModel.fromJson(response.data);
      }
      _throwServerException(response.statusCode, response.data);
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }

  Never _throwServerException(int? statusCode, dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(responseData),
      );
    }

    throw ServerException(
      errorMessageModel: ErrorMessageModel(
        statusCode: statusCode ?? 400,
        statusMessage: responseData?.toString() ?? 'Unexpected response',
      ),
    );
  }
}
