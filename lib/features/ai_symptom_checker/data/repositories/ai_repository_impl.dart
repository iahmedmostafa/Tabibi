import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/ai_symptom_checker/data/datasources/ai_remote_data_source.dart';
import 'package:tabibi/features/ai_symptom_checker/domain/entities/symptom_check_result.dart';
import 'package:tabibi/features/ai_symptom_checker/domain/repositories/base_ai_repository.dart';

class AiRepositoryImpl implements BaseAiRepository {
  final BaseAiRemoteDataSource remoteDataSource;

  AiRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, SymptomCheckResult>> checkSymptoms(
      String symptomsText) async {
    try {
      final result = await remoteDataSource.checkSymptoms(symptomsText);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.formattedErrors));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
