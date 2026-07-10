import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../core/config/api_config.dart';
import '../models/notification_item.dart';
import 'backend_service.dart';

/// Cliente de tempo real (Socket.IO) ligado ao namespace `/realtime` do
/// backend. Autentica o handshake com o access token da sessão e expõe um
/// fluxo de notificações que chegam ao vivo (evento `notification.created`),
/// permitindo que a UI atualize o sino/lista sem sondagem.
///
/// É resiliente: se o backend estiver inacessível o Socket.IO reconecta
/// automaticamente em segundo plano; a app continua a funcionar via REST.
class RealtimeService {
  RealtimeService._();

  static final RealtimeService instance = RealtimeService._();

  io.Socket? _socket;

  final _notifications = StreamController<NotificationItem>.broadcast();
  final _connected = StreamController<bool>.broadcast();

  /// Notificações recebidas ao vivo (já mapeadas para o modelo da app).
  Stream<NotificationItem> get onNotification => _notifications.stream;

  /// Estado da ligação realtime (true = ligado). Útil para um indicador de UI.
  Stream<bool> get onConnectionChange => _connected.stream;

  bool get isConnected => _socket?.connected ?? false;

  /// Estabelece (ou restabelece) a ligação realtime com o token atual. Idempotente:
  /// se já houver um socket ligado com uma sessão válida, não faz nada. Deve ser
  /// chamado após o login e no arranque, quando a sessão é restaurada.
  void connect() {
    final token = BackendService.instance.accessToken;
    if (token == null || token.isEmpty) return;

    // Já ligado: garante apenas que está ativo.
    if (_socket != null) {
      _socket!.auth = {'token': token};
      if (!_socket!.connected) _socket!.connect();
      return;
    }

    final socket = io.io(
      '${ApiConfig.realtimeOrigin}/realtime',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .enableReconnection()
          .build(),
    );

    socket.onConnect((_) => _connected.add(true));
    socket.onDisconnect((_) => _connected.add(false));
    socket.on('notification.created', (data) {
      if (data is Map) _notifications.add(_notificationFrom(Map<String, dynamic>.from(data)));
    });

    _socket = socket;
    socket.connect();
  }

  /// Termina a ligação (ex.: no logout). Após isto, [connect] recria o socket
  /// com o novo token da próxima sessão.
  void disconnect() {
    _socket?.dispose();
    _socket = null;
    _connected.add(false);
  }

  NotificationItem _notificationFrom(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id']?.toString(),
      title: json['title']?.toString() ?? 'Notificação',
      body: json['body']?.toString() ?? '',
      timeAgo: 'agora',
      kind: _kindFrom(json['type']?.toString()),
      unread: json['readAt'] == null,
    );
  }

  NotificationKind _kindFrom(String? type) {
    final value = type?.toLowerCase() ?? '';
    if (value.contains('quiz')) return NotificationKind.quiz;
    if (value.contains('forum') || value.contains('reply')) return NotificationKind.forum;
    if (value.contains('content') || value.contains('moderation')) return NotificationKind.content;
    if (value.contains('access')) return NotificationKind.access;
    return NotificationKind.system;
  }
}
