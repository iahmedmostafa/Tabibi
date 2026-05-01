import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/booking/data/models/upcoming_booking_summary_model.dart';
import 'package:tabibi/features/booking/domain/repositories/base_booking_repo.dart';

class GetNextUpcomingBookingUseCase {
  final BaseBookingRepo baseBookingRepo;

  GetNextUpcomingBookingUseCase(this.baseBookingRepo);

  Future<Either<Failure, UpcomingBookingSummaryModel>> call() {
    return baseBookingRepo.getNextUpcomingBooking();
  }
}
