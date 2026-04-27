import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor/prescription/data/datasources/doctor_prescription_remote_data_source.dart';
import 'package:tabibi/features/doctor/prescription/data/models/create_prescription_request_model.dart';
import 'package:tabibi/features/doctor/prescription/domain/entities/create_prescription_request.dart';
import 'package:tabibi/features/doctor/prescription/domain/repositories/doctor_prescription_repository.dart';

class DoctorPrescriptionRepositoryImpl implements DoctorPrescriptionRepository {
  final DoctorPrescriptionRemoteDataSource remoteDataSource;

  DoctorPrescriptionRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> createPrescription({
    required String appointmentId,
    required CreatePrescriptionRequest request,
  }) async {
    try {
      await remoteDataSource.createPrescription(
        appointmentId: appointmentId,
        request: CreatePrescriptionRequestModel.fromEntity(request),
      );
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> completeAppointment({
    required String appointmentId,
  }) async {
    try {
      await remoteDataSource.completeAppointment(appointmentId: appointmentId);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
