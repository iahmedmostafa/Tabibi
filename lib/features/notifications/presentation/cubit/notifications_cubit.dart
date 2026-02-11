import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/notifications/domain/entities/notification_entity.dart';
import 'package:tabibi/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:tabibi/features/notifications/domain/usecases/get_notifications_use_case.dart';
import 'package:tabibi/features/notifications/domain/usecases/get_unread_notification_count_use_case.dart';
import 'package:tabibi/features/notifications/domain/usecases/mark_all_notifications_as_read_use_case.dart';
import 'package:tabibi/features/notifications/domain/usecases/mark_notification_as_read_use_case.dart';
import 'package:tabibi/features/notifications/presentation/cubit/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;
  final MarkAllNotificationsAsReadUseCase markAllNotificationsAsReadUseCase;
  final GetUnreadNotificationCountUseCase getUnreadNotificationCountUseCase;

  final NotificationsRepository _repository;
  StreamSubscription? _notificationSubscription;

  NotificationsCubit(
    this.getNotificationsUseCase,
    this.markNotificationAsReadUseCase,
    this.markAllNotificationsAsReadUseCase,
    this.getUnreadNotificationCountUseCase,
    this._repository,
  ) : super(const NotificationsState()) {
    _subscribeToNotifications();
  }

  void _subscribeToNotifications() {
    _notificationSubscription = _repository.onNotificationReceived.listen((
      event,
    ) {
      if (isClosed) return;
      emit(state.copyWith(unreadCount: state.unreadCount + 1));
    });
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }

  Future<void> getNotifications() async {
    emit(state.copyWith(status: NotificationsStatus.loading));
    final result = await getNotificationsUseCase(
      const GetNotificationsParams(),
    );
    // ... rest of method

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: NotificationsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (response) => emit(NotificationsState.fromResponse(response)),
    );
  }

  Future<void> markAsRead(String id) async {
    final result = await markNotificationAsReadUseCase(id);
    result.fold(
      (failure) {
        // Optionally handle error, maybe show a snackbar
      },
      (_) {
        final updatedNotifications = state.notifications.map((n) {
          if (n.id == id) {
            return NotificationEntity(
              id: n.id,
              title: n.title,
              message: n.message,
              type: n.type,
              isRead: true, // Mark as read locally
              createdAt: n.createdAt,
              relatedEntityId: n.relatedEntityId,
            );
          }
          return n;
        }).toList();

        emit(
          state.copyWith(
            notifications: updatedNotifications,
            unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
          ),
        );
      },
    );
  }

  Future<void> markAllAsRead() async {
    final result = await markAllNotificationsAsReadUseCase(
      const NoParameters(),
    );
    result.fold(
      (failure) {
        // Optionally handle error
      },
      (_) {
        final updatedNotifications = state.notifications.map((n) {
          return NotificationEntity(
            id: n.id,
            title: n.title,
            message: n.message,
            type: n.type,
            isRead: true,
            createdAt: n.createdAt,
            relatedEntityId: n.relatedEntityId,
          );
        }).toList();

        emit(
          state.copyWith(notifications: updatedNotifications, unreadCount: 0),
        );
      },
    );
  }

  Future<void> getUnreadCount() async {
    final result = await getUnreadNotificationCountUseCase(
      const NoParameters(),
    );
    result.fold(
      (failure) {
        // Optionally handle error
      },
      (count) {
        emit(state.copyWith(unreadCount: count));
      },
    );
  }
}
