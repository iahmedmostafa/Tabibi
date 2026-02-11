import 'package:equatable/equatable.dart';
import 'package:tabibi/features/notifications/data/models/notifications_response.dart';
import 'package:tabibi/features/notifications/domain/entities/notification_entity.dart';

enum NotificationsStatus { initial, loading, loaded, error }

class NotificationsState extends Equatable {
  final NotificationsStatus status;
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final String errorMessage;
  final int currentPage;
  final bool hasNextPage;

  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
    this.unreadCount = 0,
    this.errorMessage = '',
    this.currentPage = 1,
    this.hasNextPage = false,
  });

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationEntity>? notifications,
    int? unreadCount,
    String? errorMessage,
    int? currentPage,
    bool? hasNextPage,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }

  factory NotificationsState.fromResponse(NotificationsResponse response) {
    return NotificationsState(
      status: NotificationsStatus.loaded,
      notifications: response.items,
      unreadCount: response.unreadCount,
      currentPage: response.page,
      hasNextPage: response.hasNextPage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    notifications,
    unreadCount,
    errorMessage,
    currentPage,
    hasNextPage,
  ];
}
