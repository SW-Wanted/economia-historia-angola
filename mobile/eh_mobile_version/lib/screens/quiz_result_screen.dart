import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: const Color(0x0D000000),
        automaticallyImplyLeading: false, // No back button on result screen
        title: Text('Economia com História', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.secondary),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: const NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDu9GZ6WaTHv5BXX53u3BUunjr4oC2EvfSVLgaCgtFrjFdJvTcIqYPYQY6SppUZC3heWk1aaVkNsNsW1L7GZD9JzvPKHxEpTcJO5yQWgRAS0mTrIyLHQThXzsh9Mo1fCv1Oq4VC7t8yOpUOp4ynd9z_ipmXR1Hy9vP1r8CbBdhthgz5oDgEAIWrXKNNg6ny3xz4phB5hG_8K6igKQjz1OaNT4SFVoba5ZO1KBEMWiurf1kcsxjALduM8nZQRa9KK0UMUBXFdIqAeJg'),
              backgroundColor: AppColors.surfaceContainer,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Column(
          children: [
            // Success Header
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.emoji_events, color: AppColors.primary, size: 48), // Trophy
            ),
            const SizedBox(height: 16),
            Text('Parabéns!', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Você completou o desafio sobre a História Económica de Angola.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.secondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Score Section - Circular Progress
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: const Color(0x0D000000), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 140,
                          height: 140,
                          child: CircularProgressIndicator(
                            value: 0.7,
                            strokeWidth: 12,
                            backgroundColor: AppColors.surfaceContainerHighest,
                            color: AppColors.primaryContainer,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('7/10', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 28)),
                            Text('Pontuação', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.secondary, letterSpacing: 1.0, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
                      children: [
                        const TextSpan(text: 'Você acertou '),
                        TextSpan(text: '7 de 10 perguntas certas', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        const TextSpan(text: '. Seu conhecimento sobre o período colonial está acima da média!'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Heritage Insight - Jindungo Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF8B1A1A), // Bordeaux
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Icon(Icons.history, size: 100, color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.bolt, color: Colors.yellow, size: 20),
                          const SizedBox(width: 8),
                          Text('Insight de Património', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '"A economia de Angola no século XIX foi marcada pela transição do comércio de escravos para o chamado \'comércio lícito\'. Compreender este ponto é vital para entender nossa infraestrutura atual."',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontStyle: FontStyle.italic, height: 1.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Action Buttons
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.ranking),
              icon: const Icon(Icons.leaderboard),
              label: const Text('Ver ranking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.quizHub),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Refazer quiz'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.dashboard, (route) => false),
                    icon: const Icon(Icons.explore, size: 18),
                    label: const Text('Explorar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
