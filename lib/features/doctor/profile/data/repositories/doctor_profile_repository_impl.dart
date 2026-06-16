import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor/profile/data/datasources/doctor_profile_remote_data_source.dart';
import 'package:tabibi/features/doctor/profile/data/models/update_doctor_profile_request.dart';
import 'package:tabibi/features/doctor/profile/domain/entities/doctor_profile_entity.dart';
import 'package:tabibi/features/doctor/profile/domain/repositories/doctor_profile_repository.dart';

class DoctorProfileRepositoryImpl implements DoctorProfileRepository {
  final DoctorProfileRemoteDataSource remoteDataSource;

  DoctorProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, DoctorProfileEntity>> getDoctorProfile() async {
    try {
      final result = await remoteDataSource.getDoctorProfile();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateDoctorProfile(UpdateDoctorProfileRequest request) async {
    try {
      await remoteDataSource.updateDoctorProfile(request);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
