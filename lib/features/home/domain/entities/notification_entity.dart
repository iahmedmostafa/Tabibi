enum NotificationType { success, cancelled, changed }

class NotificationEntity {
  final String id;
  final String title;
  final String description;
  final String time;
  final NotificationType type;
  final bool isNew;
  final bool isToday; // Simplification for UI grouping

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.type,
    this.isNew = false,
    this.isToday = true,
  });
}
