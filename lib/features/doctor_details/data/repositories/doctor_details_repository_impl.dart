import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor_details/data/datasources/doctor_details_remote_data_source.dart';
import 'package:tabibi/features/doctor_details/domain/entities/doctor_details_entity.dart';
import 'package:tabibi/features/doctor_details/domain/entities/paginated_reviews_entity.dart';
import 'package:tabibi/features/doctor_details/domain/repositories/doctor_details_repository.dart';

class DoctorDetailsRepositoryImpl implements DoctorDetailsRepository {
  final DoctorDetailsRemoteDataSource remoteDataSource;

  DoctorDetailsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, DoctorDetails>> getDoctorDetails(String id) async {
    try {
      final result = await remoteDataSource.getDoctorDetails(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedReviews>> getDoctorReviews({
    required String doctorId,
    required int page,
    required int pageSize,
  }) async {
    try {
      final result = await remoteDataSource.getDoctorReviews(
        doctorId: doctorId,
        page: page,
        pageSize: pageSize,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
