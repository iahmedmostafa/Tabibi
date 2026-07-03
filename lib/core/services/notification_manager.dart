import 'dart:async';
import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/network/server_connection.dart';
import 'package:tabibi/core/routing/app_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/features/notifications/data/datasources/fcm_token_data_source.dart';
import 'package:tabibi/features/notifications/domain/entities/notification_entity.dart';

const _channelKey = 'tabibi_notifications';

/// ───────────────── BACKGROUND HANDLER ─────────────────

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  // If the server sent a 'notification' payload, Android will automatically show it
  // using the default channel we just set in AndroidManifest (which creates a popup).
  // We return here to avoid showing a DUPLICATE notification.
  if (message.notification != null) return;

  await _initNotifications();

  final payload = _parsePayload(message.data);

  await _showNotification(payload);
}

/// ───────────────── NOTIFICATION MANAGER ─────────────────

class NotificationManager {
  NotificationManager._();
  static final instance = NotificationManager._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  StreamSubscription? _signalRSub;
  StreamSubscription? _tokenRefreshSub;

  /// INIT SYSTEM
  Future<void> init() async {
    await _initNotifications();
    await _initFcm();
  }

  /// START LISTENING
  void start(FcmTokenDataSource tokenSource) {
    _signalRSub?.cancel();
    _listenSignalR();
    _registerToken(tokenSource);
  }

  void stop() {
    _signalRSub?.cancel();
    _tokenRefreshSub?.cancel();
  }

  /// ───────────────── FCM SETUP ─────────────────

  Future<void> _initFcm() async {
    final settings = await _fcm.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.denied) return;

    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

    FirebaseMessaging.onMessage.listen(_handleForeground);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);

    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleTap(initialMessage);
    }
  }

  /// FOREGROUND MESSAGE
  void _handleForeground(RemoteMessage message) {
    final payloadMap = <String, dynamic>{...message.data};

    if (message.notification != null) {
      if (message.notification!.title != null) {
        payloadMap['title'] = message.notification!.title;
      }
      if (message.notification!.body != null) {
        payloadMap['body'] = message.notification!.body;
      }
    }

    final payload = _parsePayload(payloadMap);

    _showNotification(payload);
  }

  /// TAP HANDLER
  void _handleTap(RemoteMessage message) {
    final type = int.tryParse(message.data['type'] ?? '0') ?? 0;
    _navigate(type);
  }

  /// ───────────────── TOKEN REGISTRATION ─────────────────

  Future<void> _registerToken(FcmTokenDataSource source) async {
    try {
      final token = await _fcm.getToken();
      if (token != null) {
        await source.registerToken(token);
        log("FCM Token: $token");
      }
    } catch (e) {
      log('FCM token registration error: $e');
    }

    _tokenRefreshSub = _fcm.onTokenRefresh.listen((token) async {
      try {
        await source.registerToken(token);
      } catch (e) {
        log('FCM token refresh error: $e');
      }
    });
  }

  /// ───────────────── SIGNALR ─────────────────

  void _listenSignalR() {
    _signalRSub = ServerConnection().onNotificationReceived.listen((data) {
      if (data is Map) {
        final payload = _parsePayload(Map<String, dynamic>.from(data));
        _showNotification(payload);
      }
    });
  }

  /// ───────────────── NAVIGATION ─────────────────

  void _navigate(int type) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final notificationType = NotificationType.fromInt(type);

    switch (notificationType) {
      case NotificationType.bookingAlert:
      case NotificationType.payment:
        GoRouter.of(context).push(AppRoutes.myBookings);
        break;

      case NotificationType.chatMessage:
      case NotificationType.system:
        GoRouter.of(context).push(AppRoutes.notifications);
        break;
    }
  }
}

/// ───────────────── HELPERS ─────────────────

Future<void> _initNotifications() async {
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: _channelKey,
      channelName: 'Tabibi Notifications',
      channelDescription: 'App notifications',
      importance: NotificationImportance.Max,
      playSound: true,
      enableVibration: true,
    ),
  ]);

  if (!await AwesomeNotifications().isNotificationAllowed()) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  AwesomeNotifications().setListeners(
    onActionReceivedMethod: onNotificationActionReceived,
  );
}

Map<String, String> _parsePayload(Map data) {
  return {
    "title": data['title'] ?? "Tabibi",
    "body": data['body'] ?? "",
    "type": data['type']?.toString() ?? "0",
    "relatedEntityId": data['relatedEntityId']?.toString() ?? "",
  };
}

Future<void> _showNotification(Map<String, String> payload) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: _channelKey,
      title: payload['title'],
      body: payload['body'],
      payload: payload,
      notificationLayout: NotificationLayout.Default,
    ),
  );
}

/// ───────────────── TAP FROM AWESOME ─────────────────

@pragma('vm:entry-point')
Future<void> onNotificationActionReceived(ReceivedAction action) async {
  final payload = action.payload;
  if (payload == null) return;

  final type = int.tryParse(payload['type'] ?? "0") ?? 0;

  await Future.delayed(const Duration(milliseconds: 300));

  final context = navigatorKey.currentContext;
  if (context == null) return;

  final notificationType = NotificationType.fromInt(type);

  switch (notificationType) {
    case NotificationType.bookingAlert:
    case NotificationType.payment:
      GoRouter.of(context).push(AppRoutes.myBookings);
      break;

    case NotificationType.chatMessage:
    case NotificationType.system:
      GoRouter.of(context).push(AppRoutes.notifications);
      break;
  }
}
