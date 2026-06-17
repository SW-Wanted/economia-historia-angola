import 'package:flutter/material.dart';

import '../core/routes/app_routes.dart';
import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Entrar', showBack: true, children: [
      Text('Bem-vindo de volta', style: Theme.of(context).textTheme.displayLarge),
      const SizedBox(height: 8),
      Text('Continue a explorar a historia economica de Angola.', style: Theme.of(context).textTheme.bodyLarge),
      const SizedBox(height: 28),
      const TextField(decoration: InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline))),
      const SizedBox(height: 14),
      const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Senha', prefixIcon: Icon(Icons.lock_outline))),
      Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword), child: const Text('Esqueci a senha'))),
      const SizedBox(height: 8),
      EhButton(label: 'Entrar', onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.dashboard)),
      const SizedBox(height: 12),
      EhButton(label: 'Criar conta', secondary: true, onPressed: () => Navigator.pushNamed(context, AppRoutes.register1)),
    ]);
  }
}
