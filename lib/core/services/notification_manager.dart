import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/network/server_connection.dart';
import 'package:tabibi/core/routing/app_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/features/notifications/domain/entities/notification_entity.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  StreamSubscription? _signalRSubscription;

  // Android notification channel
  static const String _channelId = 'tabibi_notifications';
  static const String _channelName = 'Tabibi Notifications';
  static const String _channelDescription =
      'Notifications for appointments, messages, and updates';

  /// Initialize the local notification plugin (call once in main)
  Future<void> init() async {
    // Android settings
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS settings
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create the notification channel on Android
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
      enableLights: true,
      enableVibration: true,
    );

    final androidImpl = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImpl?.createNotificationChannel(androidChannel);

    // Request permission for Android 13+
    await androidImpl?.requestNotificationsPermission();

    log('🔔 NotificationManager initialized');
  }

  /// Start listening to SignalR notification stream
  void startListening() {
    // Cancel any previous subscription to avoid duplicates
    _signalRSubscription?.cancel();
    _signalRSubscription = ServerConnection().onNotificationReceived.listen((
      data,
    ) {
      log('🔔 NotificationManager received: $data');
      if (data is Map<String, dynamic>) {
        _showNotification(data);
      } else if (data is Map) {
        _showNotification(Map<String, dynamic>.from(data));
      }
    });
    log('🔔 NotificationManager listening to SignalR notifications');
  }

  /// Stop listening
  void stopListening() {
    _signalRSubscription?.cancel();
    _signalRSubscription = null;
  }

  /// Show a local notification from SignalR data
  Future<void> _showNotification(Map<String, dynamic> data) async {
    final String title = data['title'] ?? 'Tabibi';
    final String message = data['message'] ?? '';
    final int type = data['type'] is int
        ? data['type']
        : int.tryParse(data['type']?.toString() ?? '0') ?? 0;
    final String? relatedEntityId = data['relatedEntityId']?.toString();
    final String? id = data['id']?.toString();

    // Use hashCode of id as notification int id, or timestamp
    final int notificationId = id?.hashCode ?? DateTime.now().millisecond;

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      enableLights: true,
      colorized: true,
      color: Color(0xFF1A73E8),
    );

    const iosDetails = DarwinNotificationDetails(
      presentSound: true,
      presentBanner: true,
      presentBadge: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Encode type and relatedEntityId as payload
    final String payload = '$type|${relatedEntityId ?? ''}';

    await _localNotifications.show(
      id: notificationId,
      title: title,
      body: message,
      notificationDetails: details,
      payload: payload,
    );
  }

  /// Handle notification tap → navigate to the relevant screen
  void _onNotificationTap(NotificationResponse response) {
    final String? payload = response.payload;
    if (payload == null || payload.isEmpty) return;

    final parts = payload.split('|');
    final int type = int.tryParse(parts[0]) ?? 0;
    //final String relatedEntityId = parts.length > 1 ? parts[1] : '';

    final notificationType = NotificationType.fromInt(type);
    final context = navigatorKey.currentContext;
    if (context == null) return;

    switch (notificationType) {
      case NotificationType.bookingAlert:
        GoRouter.of(context).push(AppRoutes.myBookings);
        break;
      case NotificationType.chatMessage:
        // Navigate to notifications screen (can't open specific chat without full data)
        GoRouter.of(context).push(AppRoutes.notifications);
        break;
      case NotificationType.payment:
        GoRouter.of(context).push(AppRoutes.myBookings);
        break;
      case NotificationType.system:
        GoRouter.of(context).push(AppRoutes.notifications);
        break;
    }
  }
}
