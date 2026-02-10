import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor_details/domain/entities/paginated_reviews_entity.dart';
import 'package:tabibi/features/doctor_details/domain/repositories/doctor_details_repository.dart';

class GetDoctorReviewsUseCase {
  final DoctorDetailsRepository repository;

  GetDoctorReviewsUseCase(this.repository);

  Future<Either<Failure, PaginatedReviews>> execute(
    GetDoctorReviewsParams params,
  ) async {
    return await repository.getDoctorReviews(
      doctorId: params.doctorId,
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}

class GetDoctorReviewsParams extends Equatable {
  final String doctorId;
  final int page;
  final int pageSize;

  const GetDoctorReviewsParams({
    required this.doctorId,
    required this.page,
    this.pageSize = 10,
  });

  @override
  List<Object?> get props => [doctorId, page, pageSize];
}
