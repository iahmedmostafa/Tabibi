import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/home/domain/entities/notification_entity.dart';
import 'package:tabibi/features/home/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return Right([
        const NotificationEntity(
          id: '1',
          title: "Appointment Success",
          description:
              "You have successfully booked your appointment with Dr. Emily Walker.",
          time: "1h",
          type: NotificationType.success,
          isNew: true,
          isToday: true,
        ),
        const NotificationEntity(
          id: '2',
          title: "Appointment Cancelled",
          description:
              "You have successfully cancelled your appointment with Dr. David Patel.",
          time: "2h",
          type: NotificationType.cancelled,
          isNew: true,
          isToday: true,
        ),
        const NotificationEntity(
          id: '3',
          title: "Scheduled Changed",
          description:
              "You have successfully changes your appointment with Dr. Jesica Turner.",
          time: "8h",
          type: NotificationType.changed,
          isNew: false,
          isToday: true,
        ),
        const NotificationEntity(
          id: '4',
          title: "Appointment success",
          description:
              "You have successfully booked your appointment with Dr. David Patel.",
          time: "1d",
          type: NotificationType.success,
          isNew: false,
          isToday: false, // Yesterday
        ),
      ]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const Right(null);
  }
}
