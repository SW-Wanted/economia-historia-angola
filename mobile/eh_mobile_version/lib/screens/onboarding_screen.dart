import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key, required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    switch (step) {
      case 1:
        return const _OnboardingStep1();
      case 2:
        return const _OnboardingStep2();
      case 3:
        return const _OnboardingStep3();
      default:
        return const _OnboardingStep1();
    }
  }
}

class _OnboardingStep1 extends StatelessWidget {
  const _OnboardingStep1();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              const Text(
                'ECONOMIA COM HISTÓRIA',
                style: TextStyle(
                  color: AppColors.primaryContainer,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 2.0,
                ),
              ),
              Expanded(
                child: Center(
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBh-y9BYMzTvo8bebH51duo70TFkNa-gxDAaSecEz6IcbjuZzAQZpeRfwnxrcagNR3oxe197Eze7jFkjgyLlEkDFsyVY5i0j0JoRT1QNG_E-6eRYV-KZDuIdoEdQYl7eMF82J9S-EF5bhNuxo7m0h909fU0PMKvV4TBLTcVoB__xTcnu8GXYT_vc6PubaqUiu0AusmmmR2clZG3UgQ3qi9RTbWaBCaxHMeUIcAlXRNjHAmlIMXID3WFwObeAUPELXi1QpmSZVXxlXQ',
                    height: 280,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.public, size: 120, color: AppColors.primaryContainer),
                  ),
                ),
              ),
              Text(
                'A economia angolana no seu bolso',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 16),
              Text(
                'Explore a trajetória econômica de Angola através de uma lente histórica, educacional e rigorosa.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 32, height: 8, decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(width: 8),
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(width: 8),
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(4))),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.landing),
                    child: Text('Pular', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.onboarding2),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Próximo', style: TextStyle(fontWeight: FontWeight.w600)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingStep2 extends StatelessWidget {
  const _OnboardingStep2();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBCO9f0QX3Unr1Xce6hshiZDkPJaREgIC9nKd9Do4S87xXQkmSEzWoDpBnnu27enw3sEVIurVGVRtSUCjWpm-rPqbKLYaPQAjg5p2GM-TPp01ojIQaw6jtZbSUyKIJh7_E-IfRACUw88Xo4iEJZMcRpU1GOdNmqKutuklbbYAQR58wknrcDt3aH7OPinOh9Ix071kERQqxlXFUKegPmWMnXvEDto2r3RiRW4hVmQyFGqNOLdVHFArKRi7ZGD9lyyARt-lOjS4DHlOU',
                            height: 320,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(height: 320, color: AppColors.surfaceVariant),
                          ),
                        ),
                        Positioned(
                          bottom: -16,
                          left: -16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.bolt, color: AppColors.onPrimary, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'Conhecimento Profundo',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onPrimary, fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    Text(
                      'Textos com Jindungo',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Explore análises críticas e profundas que temperam o rigor econômico com a riqueza da nossa história angolana.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(width: 8),
                  Container(width: 32, height: 8, decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(width: 8),
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(4))),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.onboarding3),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('PRÓXIMO', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.landing),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('PULAR', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingStep3 extends StatelessWidget {
  const _OnboardingStep3();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.landing),
                  child: Text('Pular', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 280,
                      width: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.surface, width: 4),
                        boxShadow: [
                          BoxShadow(color: const Color(0x0D000000), blurRadius: 12, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAHikcBitiNpWZNh6b-eLBv5YG2a23ITOq1iJIhbQzcKaKKfyuMC7-306MThKk7vq7wOVYSu9W93iNhfX0HQqFPbr7y1AsXvzZpnvMqjkzfydcaq8dK-Q-5ikY-bfldwl86Jlgij2ZOMgoBnXoR1K2pKdtBRnX1ikGNEWqNnf4hm_E-GWKEXrHqk2fkyROQvIFMqO1Xm6eRfpxiEKL0Bu84Q1zLGGHIfgccZFXpSigfe6AbIH-4ku15ePH8k2E3bZWHOlPP9oyFfQ8',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(color: AppColors.surfaceVariant),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      'Debate Qualificado',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Acesse um espaço de troca mútua entre estudantes e profissionais para moldar o futuro econômico.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(width: 8),
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(width: 8),
                  Container(width: 32, height: 8, decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(4))),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.landing),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Começar Agora', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, fontFamily: 'Plus Jakarta Sans')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
