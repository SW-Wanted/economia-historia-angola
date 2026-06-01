import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../widgets/eh_button.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Gerir subscricao', showBack: true, children: [
      EhCard(
        color: AppColors.primary,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Plano Jindungo', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white)),
          const SizedBox(height: 10),
          Text('Textos premium, debates privados e analises aprofundadas.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: .86))),
        ]),
      ),
      const SizedBox(height: 20),
      EhButton(label: 'Ativar plano', onPressed: () => Navigator.pop(context)),
    ]);
  }
}
