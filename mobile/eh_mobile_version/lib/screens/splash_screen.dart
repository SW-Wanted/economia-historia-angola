import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryContainer,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Stylized Map Placeholder
                    Opacity(
                      opacity: 0.4,
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAarv8zVtFWcdG3xCx3aJffWO_YB88VU46DqO4tYarRPVnLtq1oulUSWvnfsyiMf6_lf_rKZyMC-Ei53N5ZYwtBfTJs6u1ZWH2m839WAmSOXhj9AFU-MsMoPW8x9ICAFDcjZUJZfhOmOfYAOV32vVkpAJuv3j-26vPalneDbJaBsn6V-gjDGyBpAXQCFaBJ7cLe2F7FRBHaAolcpZtyXLrWsxnQFpyMhnJOHb6RUQmQ-0gcYycp85mGWeO9zYFyfMdSQ0vcaA3-GJw',
                        height: MediaQuery.of(context).size.height * 0.4,
                        color: Colors.white,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.map, size: 120, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Economia com História',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.onPrimary,
                            letterSpacing: -0.5,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Angola',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.onPrimary.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w300,
                          ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.onboarding1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.onPrimary,
                        foregroundColor: AppColors.primaryContainer,
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Entrar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Plus Jakarta Sans')),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.register1),
                    child: Text(
                      'Criar conta',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onPrimary.withValues(alpha: 0.9),
                          ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
