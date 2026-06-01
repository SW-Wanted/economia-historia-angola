import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';

class PrivateForumAccessScreen extends StatefulWidget {
  const PrivateForumAccessScreen({super.key});

  @override
  State<PrivateForumAccessScreen> createState() => _PrivateForumAccessScreenState();
}

class _PrivateForumAccessScreenState extends State<PrivateForumAccessScreen> {
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitCode() {
    if (_formKey.currentState?.validate() ?? false) {
      final code = _codeController.text.trim();
      if (code.length < 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, introduza um código com 4-6 dígitos.')),
        );
        return;
      }

      // Simulate access verification
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Acesso autorizado! Bem-vindo ao grupo.')),
      );
      // Navigate to the forum topic
      Navigator.pushReplacementNamed(context, AppRoutes.forumTopic);
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.close, color: AppColors.primary),
        ),
        title: const Text(
          'Entrar no Grupo',
          style: TextStyle(
            color: AppColors.primary,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Central Access Card
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Locking Icon Circle
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock,
                          size: 36,
                          color: AppColors.primaryContainer,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Restrict Access Title
                      const Text(
                        'Acesso Restrito',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Description
                      const Text(
                        'Este é um grupo de estudo privado. Insira o código enviado pelo seu professor ou orientador.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Access Code Input
                      TextFormField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 6,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 8,
                          color: AppColors.primary,
                        ),
                        decoration: InputDecoration(
                          hintText: '000000',
                          hintStyle: TextStyle(
                            color: AppColors.secondary.withValues(alpha: 0.3),
                            letterSpacing: 8,
                          ),
                          counterText: '',
                          fillColor: AppColors.surface,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.outlineVariant),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.primaryContainer, width: 1.5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Insira o código de acesso';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Código de 4-6 dígitos',
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Primary action button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: _submitCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryContainer,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.login, size: 20),
                          label: const Text(
                            'Aceder Grupo',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Secondary link
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Pedido de convite enviado ao administrador.')),
                          );
                        },
                        child: const Text(
                          'Solicitar convite ao administrador',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Academic Visual Footer
              const Opacity(
                opacity: 0.6,
                child: Text(
                  'Parte do programa de estudos acadêmicos "Economia com História" (Angola, 2026).',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
