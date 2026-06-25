import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';

/// Solicitação de acesso a fórum/categoria privada.
class PrivateForumAccessScreen extends StatelessWidget {
  const PrivateForumAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Acesso Privado',
      showBack: true,
      children: [
        const SizedBox(height: 8),
        Center(
          child: Container(
            width: 96, height: 96,
            decoration: BoxDecoration(color: AppColors.navy.withValues(alpha: .1), shape: BoxShape.circle),
            child: const Icon(Icons.lock_outline, color: AppColors.navy, size: 44),
          ),
        ),
        const SizedBox(height: 20),
        Text('Conteúdo restrito', textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24)),
        const SizedBox(height: 8),
        Text(
          'Este espaco e privado. Solicite acesso ou introduza um código de convite. '
          'A entrada é aprovada pela administração responsável.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary, height: 1.5),
        ),
        const SizedBox(height: 28),
        const TextField(
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(hintText: 'Código de convite (opcional)', prefixIcon: Icon(Icons.vpn_key_outlined)),
        ),
        const SizedBox(height: 16),
        EhButton(
          label: 'Solicitar acesso',
          icon: Icons.outgoing_mail,
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Pedido enviado. Aguarde aprovacao.'), behavior: SnackBarBehavior.floating));
          },
        ),
        const SizedBox(height: 12),
        Center(
          child: Text('O autor sera notificado do seu pedido.',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
        ),
      ],
    );
  }
}
