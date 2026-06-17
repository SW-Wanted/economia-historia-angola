import 'package:flutter/material.dart';

import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';

class CreateTopicScreen extends StatelessWidget {
  const CreateTopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Criar topico', showBack: true, children: [
      const TextField(decoration: InputDecoration(labelText: 'Titulo')),
      const SizedBox(height: 14),
      const TextField(decoration: InputDecoration(labelText: 'Categoria')),
      const SizedBox(height: 14),
      const TextField(maxLines: 7, decoration: InputDecoration(labelText: 'Mensagem')),
      const SizedBox(height: 24),
      EhButton(label: 'Publicar', onPressed: () => Navigator.pop(context)),
    ]);
  }
}
