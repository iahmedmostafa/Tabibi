import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/booking/data/models/booking_model.dart';
import 'package:tabibi/features/booking/domain/repositories/base_booking_repo.dart';

class GetMyBookingsUseCase {
  final BaseBookingRepo baseBookingRepo;

  GetMyBookingsUseCase(this.baseBookingRepo);
  Future<Either<Failure, List<BookingModel>>> getMyBookings(String type) async {
    return await baseBookingRepo.getMyBooking(type);
  }
}
