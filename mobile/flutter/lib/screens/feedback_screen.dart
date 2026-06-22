import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

/// Espaço de Comentários — feedback sobre a app e sugestões de novos temas (acta, ponto 3).
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _rating = 0;
  String _type = 'Sugestao de tema';

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Comentarios e Sugestoes',
      showBack: true,
      children: [
        const SectionTitle('A sua opiniao conta'),
        const SizedBox(height: 8),
        Text(
          'Ajude-nos a melhorar a aplicacao e a escolher novos temas para os proximos conteudos.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary),
        ),
        const SizedBox(height: 20),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (i) {
              final filled = i < _rating;
              return IconButton(
                onPressed: () => setState(() => _rating = i + 1),
                icon: Icon(filled ? Icons.star : Icons.star_border, size: 34, color: AppColors.warning),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),
        Text('Tipo de comentario', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textMuted)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: _type,
          items: const ['Sugestao de tema', 'Problema tecnico', 'Elogio', 'Outro']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _type = v ?? _type),
        ),
        const SizedBox(height: 16),
        const TextField(maxLines: 6, decoration: InputDecoration(hintText: 'Escreva o seu comentario ou sugestao...')),
        const SizedBox(height: 24),
        EhButton(
          label: 'Enviar feedback',
          icon: Icons.send,
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Obrigado! O seu feedback foi enviado.'), behavior: SnackBarBehavior.floating),
            );
          },
        ),
      ],
    );
  }
}
