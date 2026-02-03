import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/home/domain/entities/notification_entity.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, void>> markAllAsRead();
}
