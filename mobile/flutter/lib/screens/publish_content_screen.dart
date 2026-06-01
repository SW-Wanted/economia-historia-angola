import 'package:flutter/material.dart';

import '../core/routes/app_routes.dart';
import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';

class PublishContentScreen extends StatelessWidget {
  const PublishContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Publicar conteudo', showBack: true, children: [
      const TextField(decoration: InputDecoration(labelText: 'Titulo')),
      const SizedBox(height: 14),
      const TextField(decoration: InputDecoration(labelText: 'Categoria')),
      const SizedBox(height: 14),
      const TextField(maxLines: 8, decoration: InputDecoration(labelText: 'Corpo do texto')),
      const SizedBox(height: 14),
      const SwitchListTile(value: true, onChanged: null, title: Text('Marcar como Jindungo premium')),
      const SizedBox(height: 20),
      EhButton(label: 'Publicar agora', onPressed: () => Navigator.pushNamed(context, AppRoutes.publishConfirmation)),
    ]);
  }
}
