@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';

import 'package:eh_mobile_version/models/app_user.dart';
import 'package:eh_mobile_version/services/backend_service.dart';

/// Teste de integração REAL contra o backend a correr em
/// http://localhost:3001/api/v1 (use o mesmo API_BASE_URL por omissão).
///
/// Pré-requisito: backend ligado (`npm run start:dev`).
/// Execução: flutter test test/backend_integration_test.dart
void main() {
  final email = 'flutter_it_${DateTime.now().millisecondsSinceEpoch}@isptec.co.ao';
  const password = 'Teste1234';
  final service = BackendService.instance;

  test('registo cria sessão e devolve utilizador', () async {
    final user = await service.register(
      name: 'Teste Flutter',
      email: email,
      password: password,
    );
    expect(service.isAuthenticated, isTrue);
    expect(user.email, email);
    expect(user.name, 'Teste Flutter');
    expect(user.role, UserRole.utilizador);
  });

  test('logout limpa a sessão', () async {
    await service.logout();
    expect(service.isAuthenticated, isFalse);
  });

  test('login autentica e devolve o perfil', () async {
    final user = await service.login(email: email, password: password);
    expect(service.isAuthenticated, isTrue);
    expect(user.email, email);
  });

  test('currentUser devolve o perfil autenticado', () async {
    final user = await service.currentUser();
    expect(user.email, email);
    expect(user.name, 'Teste Flutter');
  });

  // Endpoints de dados usados pelas telas (com fallback offline garantido):
  // nunca devem lançar e devem devolver listas não vazias.
  test('contents() devolve lista', () async {
    final list = await service.contents();
    expect(list, isNotEmpty);
  });

  test('forumTopics() devolve lista', () async {
    final list = await service.forumTopics();
    expect(list, isNotEmpty);
  });

  test('ranking() devolve lista', () async {
    final list = await service.ranking();
    expect(list, isNotEmpty);
  });

  test('notifications() devolve lista', () async {
    final list = await service.notifications();
    expect(list, isNotEmpty);
  });
}
