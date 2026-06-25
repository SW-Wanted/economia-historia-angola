import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/config/api_config.dart';

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({http.Client? httpClient, String? baseUrl})
      : _http = httpClient ?? http.Client(),
        baseUrl = baseUrl ?? ApiConfig.baseUrl;

  final http.Client _http;
  final String baseUrl;
  String? accessToken;
  String? refreshToken;

  bool get isAuthenticated => accessToken != null && refreshToken != null;

  Future<Map<String, dynamic>> getJson(String path, {Map<String, String?> query = const {}}) async {
    final value = await _send('GET', path, query: query);
    return value is Map<String, dynamic> ? value : {'items': value};
  }

  Future<List<dynamic>> getList(String path, {Map<String, String?> query = const {}}) async {
    final value = await _send('GET', path, query: query);
    if (value is List<dynamic>) return value;
    if (value is Map<String, dynamic> && value['items'] is List<dynamic>) {
      return value['items'] as List<dynamic>;
    }
    return const [];
  }

  Future<Map<String, dynamic>> postJson(String path, Map<String, dynamic> body) async {
    final value = await _send('POST', path, body: body);
    return value is Map<String, dynamic> ? value : <String, dynamic>{};
  }

  Future<Map<String, dynamic>> patchJson(String path, Map<String, dynamic> body) async {
    final value = await _send('PATCH', path, body: body);
    return value is Map<String, dynamic> ? value : <String, dynamic>{};
  }

  Uri _uri(String path, Map<String, String?> query) {
    final base = Uri.parse(baseUrl);
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    final apiPath = [
      if (base.path.isNotEmpty) base.path.replaceAll(RegExp(r'^/+|/+$'), ''),
      normalizedPath,
    ].join('/');
    return base.replace(
      path: '/$apiPath',
      queryParameters: {
        for (final entry in query.entries)
          if (entry.value != null && entry.value!.isNotEmpty) entry.key: entry.value,
      },
    );
  }

  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String?> query = const {},
  }) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      if (body != null) 'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };
    final uri = _uri(path, query);
    final encodedBody = body == null ? null : jsonEncode(body);
    final response = switch (method) {
      'GET' => await _http.get(uri, headers: headers),
      'POST' => await _http.post(uri, headers: headers, body: encodedBody),
      'PATCH' => await _http.patch(uri, headers: headers, body: encodedBody),
      _ => throw const ApiException('Metodo HTTP nao suportado.'),
    };

    final decoded = response.body.isEmpty ? null : jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) return decoded;

    final message = decoded is Map<String, dynamic>
        ? (decoded['message'] is List ? (decoded['message'] as List).join(', ') : decoded['message']?.toString())
        : null;
    throw ApiException(message ?? 'Erro ao comunicar com o backend.', statusCode: response.statusCode);
  }
}
