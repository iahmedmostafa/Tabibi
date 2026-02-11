import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/booking/data/models/prescription_model.dart';

abstract class PrescriptionRepository {
  Future<Either<Failure, PrescriptionModel>> getPrescription({
    required String bookingId,
  });
}
