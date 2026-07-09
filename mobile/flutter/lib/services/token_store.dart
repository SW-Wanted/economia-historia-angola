import 'package:shared_preferences/shared_preferences.dart';

/// Persistência da sessão (tokens de acesso e refresh) entre execuções da app.
///
/// Usa [SharedPreferences] — suficiente para tokens rotativos de curta duração.
/// O access token expira em 15 min; o refresh token permite renovar a sessão
/// silenciosamente durante ~30 dias sem novo login.
class TokenStore {
  const TokenStore._();

  static const _accessKey = 'auth.accessToken';
  static const _refreshKey = 'auth.refreshToken';

  static Future<({String? accessToken, String? refreshToken})> read() async {
    final prefs = await SharedPreferences.getInstance();
    return (
      accessToken: prefs.getString(_accessKey),
      refreshToken: prefs.getString(_refreshKey),
    );
  }

  static Future<void> write({
    required String? accessToken,
    required String? refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (accessToken == null || accessToken.isEmpty) {
      await prefs.remove(_accessKey);
    } else {
      await prefs.setString(_accessKey, accessToken);
    }
    if (refreshToken == null || refreshToken.isEmpty) {
      await prefs.remove(_refreshKey);
    } else {
      await prefs.setString(_refreshKey, refreshToken);
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
  }
}
