import 'package:flutter/widgets.dart';

import '../core/routes/app_routes.dart';

/// Abre o "Centro de Criação de Conteúdos".
///
/// Mantido como ponto de entrada do botão "Criar" (a lógica do FAB não muda):
/// encaminha para a página [AppRoutes.createContent], cujas opções são
/// construídas dinamicamente a partir das permissões do utilizador.
///
/// [excludeForum] esconde a opção de criar fórum (ex.: no separador Explorar,
/// onde a criação de fóruns não faz sentido).
Future<void> showCreateMenu(BuildContext context, {bool excludeForum = false}) =>
    Navigator.pushNamed(context, AppRoutes.createContent, arguments: {'excludeForum': excludeForum});
