import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/booking/data/datasources/booking_data_source.dart';
import 'package:tabibi/features/booking/data/models/booking_model.dart';
import 'package:tabibi/features/booking/domain/repositories/base_booking_repo.dart';

class BookingRepoImpl implements BaseBookingRepo {
  final BaseBookingDataSource baseBookingDataSource;

  BookingRepoImpl(this.baseBookingDataSource);
  @override
  Future<Either<Failure, List<BookingModel>>> getMyBooking(int status) async {
    try {
      final result = await baseBookingDataSource.getMyBooking(status);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
