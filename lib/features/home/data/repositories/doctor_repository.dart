import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/home/data/datasources/doctors_remote_data_source.dart';
import 'package:tabibi/features/home/data/models/doctors_filter_params.dart';
import '../models/doctors_response_model.dart';

abstract class DoctorsRepository {
  /// Fetches paginated doctors list with optional filters
  Future<Either<Failure, DoctorsResponseModel>> getDoctors({
    int page = 1,
    int pageSize = 10,
    String? departmentId,
    String? query,
    int? gender,
    String? cityId,
    String? sort,
    String? fields,
    DoctorsFilterParams? filters,
  });
}

class DoctorsRepositoryImpl implements DoctorsRepository {
  final DoctorsRemoteDataSource remoteDataSource;

  DoctorsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, DoctorsResponseModel>> getDoctors({
    int page = 1,
    int pageSize = 10,
    String? departmentId,
    String? query,
    int? gender,
    String? cityId,
    String? sort,
    String? fields,
    DoctorsFilterParams? filters,
  }) async {
    try {
      final response = await remoteDataSource.getDoctors(
        page: page,
        pageSize: pageSize,
        departmentId: departmentId,
        query: query,
        gender: gender,
        cityId: cityId,
        sort: sort,
        fields: fields,
        filters: filters,
      );

      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
