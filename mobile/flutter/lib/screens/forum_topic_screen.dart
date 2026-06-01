import 'package:flutter/material.dart';

import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

class ForumTopicScreen extends StatelessWidget {
  const ForumTopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Topico', showBack: true, children: [
      Text('O impacto das ferrovias no sec. XX?', style: Theme.of(context).textTheme.displayLarge),
      const SizedBox(height: 16),
      const EhCard(child: Text('As ferrovias foram decisivas para ligar zonas produtivas aos portos, reorganizando mercados regionais e rotas de trabalho.')),
      const SizedBox(height: 16),
      const EhCard(child: Text('Comentario de Ana: Tambem vale olhar para o Caminho de Ferro de Benguela como corredor regional.')),
      const SizedBox(height: 16),
      const TextField(maxLines: 3, decoration: InputDecoration(hintText: 'Escreva uma resposta')),
    ]);
  }
}
