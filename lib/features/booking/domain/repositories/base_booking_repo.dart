import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/booking/data/models/booking_model.dart';

abstract class BaseBookingRepo {
  Future<Either<Failure, List<BookingModel>>> getMyBooking(int status);
}
