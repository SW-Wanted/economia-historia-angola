import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../widgets/app_logo_mark.dart';
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
              const AppLogoMark(size: 112, elevation: 12),
              const SizedBox(height: 28),
              Text('Economia com História', textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white)),
              const SizedBox(height: 10),
              Text('Angola explicada pela sua memória económica.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: .82))),
              const Spacer(),
              EhButton(label: 'Explorar app', onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.landing), inverted: true),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.onboarding1),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70, width: 1.4),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('VER INTRODUCAO'),
              ),
              const SizedBox(height: 4),
              TextButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.register1), child: const Text('Criar conta', style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
      ),
    );
  }
}
