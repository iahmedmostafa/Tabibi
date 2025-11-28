import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/home/data/datasources/base_patient_profile_data_source.dart';
import 'package:tabibi/features/home/data/models/patient_profile_model.dart';
import 'package:tabibi/features/home/domain/repositories/base_patient_profile_repository.dart';

class PatientProfileRepository implements BasePatientProfileRepository {
  final BasePatientProfileDataSource patientProfileDataSource;

  PatientProfileRepository(this.patientProfileDataSource);

  @override
  Future<Either<Failure, PatientProfileModel>> getPatientProfile() async {
    try {
      final PatientProfileModel profile = await patientProfileDataSource
          .getPatientProfile();

      return Right(profile);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.formattedErrors));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
