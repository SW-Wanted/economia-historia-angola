import 'package:flutter/material.dart';

import '../core/routes/app_routes.dart';
import '../services/backend_service.dart';
import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _snack('Indique um email válido.');
      return;
    }
    setState(() => _loading = true);
    String? devToken;
    try {
      // Em ambiente de desenvolvimento o backend devolve o token diretamente,
      // permitindo concluir a redefinição sem servidor de email.
      devToken = await BackendService.instance.forgotPassword(email);
    } catch (_) {
      // O endpoint responde de forma neutra; ignoramos falhas de rede aqui.
    }
    if (!mounted) return;
    setState(() => _loading = false);
    _snack('Se o email existir, enviámos um link de recuperação.');
    // Avança para a redefinição. Com token de dev, pré-preenche-o; caso
    // contrário o utilizador cola o código recebido por email.
    Navigator.pushReplacementNamed(context, AppRoutes.resetPassword, arguments: devToken);
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Recuperar senha', showBack: true, showNotifications: false, children: [
      Text('Recupere o acesso', style: Theme.of(context).textTheme.displayLarge),
      const SizedBox(height: 10),
      const Text('Enviaremos um link seguro para redefinir a sua senha.'),
      const SizedBox(height: 24),
      TextField(
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        onSubmitted: (_) => _submit(),
        decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline)),
      ),
      const SizedBox(height: 24),
      EhButton(label: _loading ? 'A enviar...' : 'Enviar link', onPressed: _loading ? null : _submit),
    ]);
  }
}
