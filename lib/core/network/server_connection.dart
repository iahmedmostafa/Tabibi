import 'dart:async';
import 'dart:developer';

import 'package:signalr_netcore/signalr_client.dart';
import 'package:tabibi/core/network/api_constance.dart';

class ServerConnection {
  // ✅ Singleton
  static final ServerConnection _instance = ServerConnection._internal();
  factory ServerConnection() => _instance;
  ServerConnection._internal();

  HubConnection? _hubConnection;

  // Stream for notification events
  final _notificationStreamController = StreamController<dynamic>.broadcast();
  Stream<dynamic> get onNotificationReceived =>
      _notificationStreamController.stream;

  Future<void> connect({required String accessToken}) async {
    if (_hubConnection != null &&
        _hubConnection!.state == HubConnectionState.Connected) {
      log("SignalR already connected");
      return;
    }

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          ApiConstance.serverUrl,
          options: HttpConnectionOptions(
            accessTokenFactory: () async => accessToken,
            requestTimeout: 100000,
          ),
        )
        .withAutomaticReconnect()
        .build();

    _hubConnection!.on("ReceiveNotification", (data) {
      log("📩 Notification received: $data");
      if (data != null && data.isNotEmpty) {
        _notificationStreamController.add(data[0]);
      }
    });

    _hubConnection!.onclose(({error}) {
      log("❌ SignalR connection closed: $error");
    });

    _hubConnection!.onreconnecting(({error}) {
      log("🔄 SignalR reconnecting: $error");
    });

    _hubConnection!.onreconnected(({connectionId}) {
      log("✅ SignalR reconnected: $connectionId");
    });

    try {
      await _hubConnection!.start();
      log("✅ SignalR connected successfully");
    } catch (e) {
      log("❌ SignalR connection failed: $e");
    }
  }

  Future<void> disconnect() async {
    if (_hubConnection != null) {
      await _hubConnection!.stop();
      _hubConnection = null;
      log("🛑 SignalR disconnected");
    }
    await _notificationStreamController.close();
  }
}
