import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';

class QuickStartScreen extends StatelessWidget {
  const QuickStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Contextual Map Visual
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Opacity(
              opacity: 0.05,
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDLqcD7ieZkv3BIP1VRMbKkE02Hv-QkK3EZ-dcUKJmEA51wv_BzmY1ZlAANRhoo2qz41GdhpvXu-5EeI7ws7Kps0TJcMvhdPNUKir_IFMdgKc6SUmzAzMkdYHZe2gIZgpDCuqdNefBsrm-cezk5Lk5AHe0RUY6DzSG8nnnFulRJQifVSoUhCkZwX6CNlxKyRuIK0bOdx2u2lKlPvF_7Q9G5PY0yrtRGJgaJ74f-T0wXeXiftYFASvanQwky37CRILnwDDjEJPWUhJA',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Economia com História', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.onSurfaceVariant),
                        onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.dashboard),
                        style: IconButton.styleFrom(backgroundColor: AppColors.surfaceContainerLowest, shape: const CircleBorder()),
                      ),
                    ],
                  ),
                ),
                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        // Title Section
                        Text('Guia de Início Rápido', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22, color: AppColors.primary)),
                        const SizedBox(height: 8),
                        Text('Aprenda a navegar pela jornada da economia angolana em 4 passos simples.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
                        const SizedBox(height: 32),
                        
                        // Vertical Steps
                        _buildStepCard(context, '1', Icons.map, 'Explorar o Mapa', 'Navegue geograficamente pela história econômica das províncias de Angola.', false),
                        const SizedBox(height: 16),
                        _buildStepCard(context, '2', Icons.book, 'Leituras Essenciais', 'Acesse artigos e teses fundamentais sobre o desenvolvimento nacional.', true),
                        const SizedBox(height: 16),
                        _buildStepCard(context, '3', Icons.quiz, 'Desafiar o Conhecimento', 'Teste seus conhecimentos através de quizzes interativos e dinâmicos.', false),
                        const SizedBox(height: 16),
                        _buildStepCard(context, '4', Icons.forum, 'Debater na Comunidade', 'Participe de discussões críticas com especialistas e outros estudantes.', false),
                        const SizedBox(height: 24),
                        
                        // Special Heritage Insight
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(20), backgroundBlendMode: BlendMode.srcOver),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                right: -20,
                                bottom: -20,
                                child: Opacity(
                                  opacity: 0.1,
                                  child: Icon(Icons.history_edu, size: 100, color: Colors.white),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.bolt, color: AppColors.surface, size: 18),
                                      const SizedBox(width: 8),
                                      Text('INSIGHT DE HERANÇA', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onPrimary, letterSpacing: 1.0, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '"A história econômica de Angola é o alicerce para o progresso futuro. Conhecer o passado é dominar o presente."',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onPrimary, fontStyle: FontStyle.italic, height: 1.5, fontSize: 15),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Footer Actions
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.dashboard),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B1A1A),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 4,
                            ),
                            child: const Text('Concluir Guia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.dashboard),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Pular Introdução', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(BuildContext context, String number, IconData icon, String title, String description, bool isHighlight) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0x0D000000), blurRadius: 12, offset: const Offset(0, 4))],
        border: isHighlight ? const Border(left: BorderSide(color: AppColors.primary, width: 4)) : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(color: Color(0xFF8B1A1A), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(number, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18, color: AppColors.onSurface))),
                  ],
                ),
                const SizedBox(height: 4),
                Text(description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
