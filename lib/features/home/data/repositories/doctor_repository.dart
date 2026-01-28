import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/home/data/datasources/doctors_remote_data_source.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';

abstract class DoctorsRepository {
  Future<Either<Failure, List<DoctorModel>>> getDoctors();
}

class DoctorsRepositoryImpl implements DoctorsRepository {
  final DoctorsRemoteDataSource remoteDataSource;

  DoctorsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<DoctorModel>>> getDoctors() async {
    try {
      final response = await remoteDataSource.getDoctors();
      final doctors = response
          .map<DoctorModel>((json) => DoctorModel.fromJson(json))
          .toList();

      return Right(doctors);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
