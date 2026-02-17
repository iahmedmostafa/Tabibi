import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/booking/data/models/prescription_model.dart';
import 'package:tabibi/features/booking/domain/repositories/prescription_repository.dart';

class GetPrescriptionUseCase {
  final PrescriptionRepository prescriptionRepository;

  GetPrescriptionUseCase(this.prescriptionRepository);

  Future<Either<Failure, PrescriptionModel>> call({
    required String bookingId,
  }) async {
    return await prescriptionRepository.getPrescription(bookingId: bookingId);
  }
}
