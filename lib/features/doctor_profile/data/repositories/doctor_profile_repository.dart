import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/doctor_profile/data/datasources/base_doctor_profile_data_source.dart';
import 'package:tabibi/features/doctor_profile/domain/entities/doctor_profile.dart';
import 'package:tabibi/features/doctor_profile/domain/entities/update_doctor_profile_params.dart';
import 'package:tabibi/features/doctor_profile/domain/repositories/base_doctor_profile_repository.dart';

class DoctorProfileRepository implements BaseDoctorProfileRepository {
  final BaseDoctorProfileDataSource baseDoctorProfileDataSource;

  DoctorProfileRepository(this.baseDoctorProfileDataSource);

  @override
  Future<Either<Failure, DoctorProfile>> getDoctorProfile() async {
    try {
      final result = await baseDoctorProfileDataSource.getDoctorProfile();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioException catch (failure) {
      return Left(ServerFailure(failure.message ?? 'Dio Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateDoctorProfile(
    UpdateDoctorProfileParams params,
  ) async {
    try {
      final result = await baseDoctorProfileDataSource.updateDoctorProfile(
        params,
      );
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioException catch (failure) {
      return Left(ServerFailure(failure.message ?? 'Dio Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DoctorStatus>> doctorStatus() async {
    try {
      final result = await baseDoctorProfileDataSource.doctorStatus();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioException catch (failure) {
      return Left(ServerFailure(failure.message ?? 'Dio Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
