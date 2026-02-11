import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/notifications/data/models/notifications_response.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, NotificationsResponse>> getNotifications({
    int page,
    int pageSize,
  });
  Future<Either<Failure, void>> markAsRead(String id);
  Future<Either<Failure, void>> markAllAsRead();
  Future<Either<Failure, int>> getUnreadCount();
  Stream<dynamic> get onNotificationReceived;
}
