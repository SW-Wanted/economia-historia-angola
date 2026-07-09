import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  const ApiConfig._();

  /// Sufixo de versão da API do backend NestJS (prefixo global `api/v1`).
  static const _apiPath = '/api/v1';

  /// Porta padrão do backend (ver backend `PORT`, default 3001).
  static const _port = 3001;

  /// Permite fixar o endpoint em build/CI:
  ///   flutter run --dart-define=API_BASE_URL=https://api.exemplo.ao/api/v1
  static const _override = String.fromEnvironment('API_BASE_URL');

  /// URL base resolvida por plataforma quando não há override explícito:
  /// - Android emulador: `10.0.2.2` (alias do host a partir da VM Android).
  /// - iOS simulador / desktop / web: `localhost`.
  ///
  /// Para dispositivo físico, passe o IP da máquina via `--dart-define`.
  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    final host = _defaultHost();
    return 'http://$host:$_port$_apiPath';
  }

  static String _defaultHost() {
    if (kIsWeb) return 'localhost';
    try {
      if (Platform.isAndroid) return '10.0.2.2';
    } catch (_) {
      // Platform indisponível (ex.: testes): usa localhost.
    }
    return 'localhost';
  }
}
