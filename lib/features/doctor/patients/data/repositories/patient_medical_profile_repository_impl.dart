import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor/patients/data/datasources/patient_medical_profile_remote_data_source.dart';
import 'package:tabibi/features/doctor/patients/domain/repositories/patient_medical_profile_repository.dart';
import 'package:tabibi/features/patient_profile/data/models/medical_profile_model.dart';

class PatientMedicalProfileRepositoryImpl
    implements PatientMedicalProfileRepository {
  final PatientMedicalProfileRemoteDataSource remoteDataSource;

  PatientMedicalProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, MedicalProfileModel>> getMedicalProfile(
    String patientId,
  ) async {
    try {
      final result = await remoteDataSource.getMedicalProfile(patientId);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(
        ServerFailure(failure.errorMessageModel.statusMessage),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
