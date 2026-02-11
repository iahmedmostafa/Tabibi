import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/notifications/data/models/notifications_response.dart';
import 'package:tabibi/features/notifications/domain/repositories/notifications_repository.dart';

class GetNotificationsUseCase
    extends BaseUseCase<NotificationsResponse, GetNotificationsParams> {
  final NotificationsRepository repository;

  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, NotificationsResponse>> call(
    GetNotificationsParams parameters,
  ) async {
    return await repository.getNotifications(
      page: parameters.page,
      pageSize: parameters.pageSize,
    );
  }
}

class GetNotificationsParams extends Equatable {
  final int page;
  final int pageSize;

  const GetNotificationsParams({this.page = 1, this.pageSize = 20});

  @override
  List<Object> get props => [page, pageSize];
}
