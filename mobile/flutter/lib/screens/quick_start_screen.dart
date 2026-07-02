import 'package:flutter/material.dart';

import '../core/routes/app_routes.dart';
import '../widgets/eh_button.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

class QuickStartScreen extends StatelessWidget {
  const QuickStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const steps = ['Leia um artigo essencial', 'Explore uma província no mapa', 'Participe no quiz semanal', 'Guarde conteúdos na biblioteca'];
    return ScreenFrame(title: 'Guia rápido', showBack: true, children: [
      Text('Comece em poucos minutos', style: Theme.of(context).textTheme.displayLarge),
      const SizedBox(height: 18),
      for (var i = 0; i < steps.length; i++) ...[
        EhCard(child: Row(children: [CircleAvatar(child: Text('${i + 1}')), const SizedBox(width: 12), Expanded(child: Text(steps[i]))])),
        const SizedBox(height: 10),
      ],
      const SizedBox(height: 20),
      EhButton(label: 'Concluir guia', onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.dashboard)),
    ]);
  }
}
