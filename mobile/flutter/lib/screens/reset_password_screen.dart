import 'package:flutter/material.dart';

import '../core/routes/app_routes.dart';
import '../services/backend_service.dart';
import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';

/// Redefinição de senha com o token de recuperação. O [token] pode vir
/// pré-preenchido (fluxo de desenvolvimento, em que o backend devolve o token),
/// ou ser colado manualmente pelo utilizador (a partir do email, em produção).
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, this.token});

  final String? token;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late final TextEditingController _token = TextEditingController(text: widget.token ?? '');
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _token.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final token = _token.text.trim();
    final password = _password.text;
    if (token.isEmpty) {
      _snack('Introduza o código de recuperação.');
      return;
    }
    if (password.length < 8) {
      _snack('A senha deve ter pelo menos 8 caracteres.');
      return;
    }
    if (password != _confirm.text) {
      _snack('As senhas não coincidem.');
      return;
    }
    setState(() => _loading = true);
    final navigator = Navigator.of(context);
    try {
      await BackendService.instance.resetPassword(token: token, newPassword: password);
      if (!mounted) return;
      _snack('Senha redefinida com sucesso. Inicie sessão com a nova senha.');
      // Volta ao login, limpando a pilha de recuperação.
      navigator.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      _snack(_friendlyError(error.toString()));
    }
  }

  String _friendlyError(String raw) {
    if (raw.contains('Invalid or expired')) {
      return 'Código inválido ou expirado. Peça um novo link de recuperação.';
    }
    return raw;
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Redefinir senha', showBack: true, showNotifications: false, children: [
      Text('Nova senha', style: Theme.of(context).textTheme.displayLarge),
      const SizedBox(height: 10),
      const Text('Introduza o código de recuperação e defina uma nova senha.'),
      const SizedBox(height: 24),
      TextField(
        controller: _token,
        decoration: const InputDecoration(labelText: 'Código de recuperação', prefixIcon: Icon(Icons.vpn_key_outlined)),
      ),
      const SizedBox(height: 16),
      TextField(
        controller: _password,
        obscureText: _obscure,
        decoration: InputDecoration(
          labelText: 'Nova senha',
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
      ),
      const SizedBox(height: 16),
      TextField(
        controller: _confirm,
        obscureText: _obscure,
        onSubmitted: (_) => _submit(),
        decoration: const InputDecoration(labelText: 'Confirmar nova senha', prefixIcon: Icon(Icons.lock_outline)),
      ),
      const SizedBox(height: 24),
      EhButton(label: _loading ? 'A redefinir...' : 'Redefinir senha', onPressed: _loading ? null : _submit),
    ]);
  }
}
