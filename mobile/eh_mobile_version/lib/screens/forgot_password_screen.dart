import 'package:flutter/material.dart';

import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Recuperar senha', showBack: true, children: [
      Text('Recupere o acesso', style: Theme.of(context).textTheme.displayLarge),
      const SizedBox(height: 10),
      const Text('Enviaremos um link seguro para redefinir a sua senha.'),
      const SizedBox(height: 24),
      const TextField(decoration: InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline))),
      const SizedBox(height: 24),
      EhButton(label: 'Enviar link', onPressed: () => Navigator.pop(context)),
    ]);
  }
}
