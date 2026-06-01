import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../widgets/eh_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
                child: const Icon(Icons.history_edu, color: AppColors.primary, size: 56),
              ),
              const SizedBox(height: 28),
              Text('Economia com Historia', textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white)),
              const SizedBox(height: 10),
              Text('Angola explicada pela sua memoria economica.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: .82))),
              const Spacer(),
              EhButton(label: 'Entrar', onPressed: () => Navigator.pushNamed(context, AppRoutes.onboarding1), inverted: true),
              TextButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.register1), child: const Text('Criar conta', style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
      ),
    );
  }
}
