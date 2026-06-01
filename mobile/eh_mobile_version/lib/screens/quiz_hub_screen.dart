import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';

class QuizHubScreen extends StatelessWidget {
  const QuizHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: const Color(0x0D000000),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Economia com História', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.secondary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner Bordeaux: Quiz da Semana
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.bolt, color: AppColors.surface, size: 24),
                            const SizedBox(width: 8),
                            Text('Quiz da Semana', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.surface, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('A Economia de Angola no Século XIX', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.surface.withValues(alpha: 0.9))),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.schedule, color: AppColors.surfaceContainerHigh, size: 16),
                            const SizedBox(width: 8),
                            Text('3 DIAS RESTANTES', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.surfaceContainerHigh, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.quizQuestion),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primaryContainer,
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('Participar', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Positioned(
                      right: -40,
                      bottom: -40,
                      child: Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Card Meu Desempenho
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: const Color(0x0D000000), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Meu desempenho', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pontuação Atual', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                            Text('1,240 pts', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Posição', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                            Text('#14', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 12,
                      width: double.infinity,
                      decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(6)),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.72,
                        child: Container(decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(6), boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8)])),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('Faltam 260 pts para o próximo nível', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Grid 2x2 of Quizzes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Quizzes Disponíveis', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.onSurface, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  _buildQuizCard(context, 'history_edu', 'Ciclo do Café', '12 perguntas', 2.5, true),
                  _buildQuizCard(context, 'payments', 'Moedas de Angola', '10 perguntas', 3.0, false),
                  _buildQuizCard(context, 'foundation', 'Companhia de Diamantes', '15 perguntas', 2.5, false),
                  _buildQuizCard(context, 'agriculture', 'Reforma Agrária', '8 perguntas', 1.0, true),
                ],
              ),
              const SizedBox(height: 24),
              
              // Botão Ver Ranking Completo
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.leaderboard),
                label: const Text('Ver ranking completo', style: TextStyle(fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryContainer,
                  side: const BorderSide(color: AppColors.primaryContainer, width: 2),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, String iconName, String title, String subtitle, double stars, bool isFinished) {
    IconData icon;
    switch (iconName) {
      case 'history_edu':
        icon = Icons.history_edu;
        break;
      case 'payments':
        icon = Icons.payments;
        break;
      case 'foundation':
        icon = Icons.foundation;
        break;
      case 'agriculture':
        icon = Icons.agriculture;
        break;
      default:
        icon = Icons.quiz;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0x0D000000), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: AppColors.primary, size: 16),
              ),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, height: 1.1)),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(3, (index) {
                  return Icon(
                    index < stars ? Icons.star : Icons.star_border,
                    color: index < stars ? AppColors.primary : AppColors.secondaryContainer,
                    size: 16,
                  );
                }),
              ),
              const SizedBox(height: 8),
              if (isFinished)
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.error, size: 14),
                    const SizedBox(width: 4),
                    Text('Finalizado', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                  ],
                )
              else
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.quizQuestion),
                  child: Row(
                    children: [
                      const Icon(Icons.play_circle, color: AppColors.primary, size: 14),
                      const SizedBox(width: 4),
                      Text('Jogar agora', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
