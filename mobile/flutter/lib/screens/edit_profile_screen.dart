import 'package:flutter/material.dart';

import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Editar perfil', showBack: true, children: [
      const TextField(decoration: InputDecoration(labelText: 'Nome')),
      const SizedBox(height: 14),
      const TextField(decoration: InputDecoration(labelText: 'Provincia')),
      const SizedBox(height: 14),
      const TextField(decoration: InputDecoration(labelText: 'Bio')),
      const SizedBox(height: 24),
      EhButton(label: 'Guardar alteracoes', onPressed: () => Navigator.pop(context)),
    ]);
  }
}
