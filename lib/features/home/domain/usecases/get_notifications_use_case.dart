import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/home/domain/entities/notification_entity.dart';
import 'package:tabibi/features/home/domain/repositories/notifications_repository.dart';

class GetNotificationsUseCase
    extends BaseUseCase<List<NotificationEntity>, NoParameters> {
  final NotificationsRepository repository;

  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
    NoParameters parameters,
  ) async {
    return await repository.getNotifications();
  }
}
