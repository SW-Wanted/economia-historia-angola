import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key, required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    final next = step == 1 ? AppRoutes.register2 : step == 2 ? AppRoutes.register3 : AppRoutes.quickStart;
    return ScreenFrame(title: 'Cadastro $step/3', showBack: true, children: [
      LinearProgressIndicator(value: step / 3, color: AppColors.primary, backgroundColor: AppColors.outlineVariant),
      const SizedBox(height: 24),
      Text(step == 1 ? 'Dados pessoais' : step == 2 ? 'Interesses' : 'Seguranca', style: Theme.of(context).textTheme.displayLarge),
      const SizedBox(height: 20),
      if (step == 1) ...const [
        TextField(decoration: InputDecoration(labelText: 'Nome completo', prefixIcon: Icon(Icons.person_outline))),
        SizedBox(height: 14),
        TextField(decoration: InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline))),
      ],
      if (step == 2) ...[
        Wrap(spacing: 10, runSpacing: 10, children: const [
          ChoiceChip(label: Text('Cafe'), selected: true),
          ChoiceChip(label: Text('Petroleo'), selected: false),
          ChoiceChip(label: Text('Moeda'), selected: true),
          ChoiceChip(label: Text('Ferrovias'), selected: false),
          ChoiceChip(label: Text('Historia colonial'), selected: false),
        ]),
        const SizedBox(height: 20),
        const TextField(maxLines: 3, decoration: InputDecoration(labelText: 'O que quer aprender primeiro?')),
      ],
      if (step == 3) ...const [
        TextField(obscureText: true, decoration: InputDecoration(labelText: 'Senha', prefixIcon: Icon(Icons.lock_outline))),
        SizedBox(height: 14),
        TextField(obscureText: true, decoration: InputDecoration(labelText: 'Confirmar senha', prefixIcon: Icon(Icons.verified_user_outlined))),
      ],
      const SizedBox(height: 28),
      EhButton(label: step == 3 ? 'Finalizar cadastro' : 'Continuar', onPressed: () => Navigator.pushNamed(context, next)),
    ]);
  }
}
