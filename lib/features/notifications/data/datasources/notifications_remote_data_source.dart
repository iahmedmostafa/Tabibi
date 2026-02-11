import 'package:dio/dio.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/features/notifications/data/models/notifications_response.dart';

abstract class NotificationsRemoteDataSource {
  Future<NotificationsResponse> getNotifications({int page, int pageSize});
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
  Future<int> getUnreadCount();
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final Dio dio;

  NotificationsRemoteDataSourceImpl(this.dio);

  @override
  Future<NotificationsResponse> getNotifications({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await dio.get(
        ApiConstance.notifications,
        queryParameters: {'page': page, 'pageSize': pageSize},
      );
      return NotificationsResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  @override
  Future<void> markAsRead(String id) async {
    try {
      await dio.patch(ApiConstance.markNotificationAsRead(id));
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await dio.patch(ApiConstance.markAllNotificationsAsRead);
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await dio.get(ApiConstance.unreadNotificationCount);
      return response.data["count"];
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
