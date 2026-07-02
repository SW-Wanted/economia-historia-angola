import 'package:flutter/material.dart';

import '../core/routes/app_routes.dart';
import '../services/api_client.dart';
import '../services/backend_service.dart';
import '../widgets/app_loading_indicator.dart';
import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordFocus = FocusNode();
  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    final password = _password.text;
    if (email.isEmpty || password.isEmpty) {
      _snack('Preencha o email e a senha.');
      return;
    }
    setState(() => _loading = true);
    try {
      await BackendService.instance.login(email: email, password: password);
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } on ApiException catch (e) {
      // Erro com resposta do servidor (ex.: credenciais inválidas).
      if (!mounted) return;
      setState(() => _loading = false);
      _passwordFocus.requestFocus();
      _snack(e.statusCode == 401 ? 'Email ou senha incorretos.' : e.message);
    } catch (_) {
      // Sem ligação ao servidor — segue em modo offline (offline-first).
      if (!mounted) return;
      setState(() => _loading = false);
      _snack('Sem ligação ao servidor. A entrar em modo offline.');
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _form(context),
        // Loading de ecrã inteiro entre o login e o dashboard: bloqueia a
        // interação e sinaliza a transição enquanto a sessão é autenticada e o
        // perfil real é carregado.
        if (_loading)
          const Positioned.fill(
            child: AppLoadingOverlay(message: 'A entrar...'),
          ),
      ],
    );
  }

  Widget _form(BuildContext context) {
    return ScreenFrame(title: 'Entrar', showBack: true, showNotifications: false, children: [
      Text('Bem-vindo de volta', style: Theme.of(context).textTheme.displayLarge),
      const SizedBox(height: 8),
      Text('Continue a explorar a história económica de Angola.', style: Theme.of(context).textTheme.bodyLarge),
      const SizedBox(height: 28),
      TextField(
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline)),
      ),
      const SizedBox(height: 14),
      TextField(
        controller: _password,
        focusNode: _passwordFocus,
        obscureText: _obscurePassword,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.done,
        autocorrect: false,
        enableSuggestions: false,
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          labelText: 'Senha',
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_password.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _password.clear();
                    setState(() {});
                    _passwordFocus.requestFocus();
                  },
                  tooltip: 'Limpar senha',
                ),
              IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                tooltip: _obscurePassword ? 'Mostrar' : 'Ocultar',
              ),
            ],
          ),
        ),
        onChanged: (_) => setState(() {}),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
          child: const Text('Esqueci a senha'),
        ),
      ),
      const SizedBox(height: 8),
      EhButton(label: _loading ? 'A entrar...' : 'Entrar', onPressed: _loading ? null : _submit),
      const SizedBox(height: 12),
      EhButton(label: 'Criar conta', secondary: true, onPressed: () => Navigator.pushNamed(context, AppRoutes.register1)),
    ]);
  }
}
