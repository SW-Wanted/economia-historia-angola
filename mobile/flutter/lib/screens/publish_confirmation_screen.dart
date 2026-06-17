import 'package:flutter/material.dart';

import '../widgets/eh_button.dart';
import '../widgets/empty_state.dart';
import '../widgets/screen_frame.dart';

class PublishConfirmationScreen extends StatelessWidget {
  const PublishConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Confirmacao', showBack: true, children: [
      const EmptyState(icon: Icons.check_circle_outline, title: 'Conteudo publicado', message: 'O artigo foi enviado para a biblioteca e ja aparece nas recomendacoes.'),
      const SizedBox(height: 20),
      EhButton(label: 'Voltar ao painel', onPressed: () => Navigator.popUntil(context, (route) => route.isFirst)),
    ]);
  }
}
