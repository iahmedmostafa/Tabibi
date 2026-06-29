import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/patient_profile/data/datasources/medical_profile_remote_data_source.dart';
import 'package:tabibi/features/patient_profile/data/models/medical_profile_model.dart';
import 'package:tabibi/features/patient_profile/data/models/update_medical_profile_params.dart';
import 'package:tabibi/features/patient_profile/domain/repositories/base_medical_profile_repository.dart';

class MedicalProfileRepository implements BaseMedicalProfileRepository {
  final BaseMedicalProfileDataSource medicalProfileDataSource;

  MedicalProfileRepository(this.medicalProfileDataSource);

  @override
  Future<Either<Failure, MedicalProfileModel>> getMedicalProfile() async {
    try {
      final MedicalProfileModel profile =
          await medicalProfileDataSource.getMedicalProfile();
      return Right(profile);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.formattedErrors));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateMedicalProfile(
    UpdateMedicalProfileParams params,
  ) async {
    try {
      final String message =
          await medicalProfileDataSource.updateMedicalProfile(params);
      return Right(message);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.formattedErrors));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
