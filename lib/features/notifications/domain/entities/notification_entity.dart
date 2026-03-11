import 'package:equatable/equatable.dart';

enum NotificationType {
  bookingAlert(0),
  system(1),
  chatMessage(2),
  payment(3);

  final int value;
  const NotificationType(this.value);

  factory NotificationType.fromInt(int value) {
    return NotificationType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => NotificationType.system,
    );
  }
}

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final String? relatedEntityId;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.relatedEntityId,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    message,
    type,
    isRead,
    createdAt,
    relatedEntityId,
  ];
}
