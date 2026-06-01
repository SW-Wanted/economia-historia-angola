import 'package:flutter/material.dart';
import 'dart:ui';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';

class RestrictedContentScreen extends StatelessWidget {
  const RestrictedContentScreen({super.key});

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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text('Jindungo', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text('A Moeda na Época Colonial: O Impacto do Kwanza nas Trocas Tradicionais', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.onSurface, fontSize: 28, height: 1.2)),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: AppColors.secondary),
                  const SizedBox(width: 6),
                  Text('24 de Outubro, 2023', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                  const SizedBox(width: 8),
                  const Text('•', style: TextStyle(color: AppColors.secondary)),
                  const SizedBox(width: 8),
                  Text('6 min de leitura', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                ],
              ),
              const SizedBox(height: 24),
              // Accessible Introductory Text
              Text(
                'O percurso histórico da economia angolana é marcado por transformações profundas na forma como o valor era percebido e trocado. Antes da formalização das moedas europeias, o território utilizava sistemas complexos de zimbo e sal. Com a introdução sistemática do sistema colonial, assistiu-se a uma transição forçada que não apenas alterou o comércio, mas desestruturou hierarquias sociais seculares, gerando resistências que moldaram a identidade económica das províncias interiores do país.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.onSurface, height: 1.6),
              ),
              const SizedBox(height: 24),
              // Restricted Content Section with Blur/Fade Effect
              SizedBox(
                height: 400,
                child: Stack(
                  children: [
                    // Blurred Mock Content
                    Opacity(
                      opacity: 0.3,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Text(
                          'A introdução do papel-moeda em 1926 trouxe consigo uma nova dinâmica de controle estatal. Os governadores locais utilizavam a emissão de notas para financiar infraestruturas que serviam quase exclusivamente ao escoamento de matérias-primas para o litoral. Este fenómeno criou uma clivagem económica entre as zonas rurais e os centros urbanos em ascensão, como Luanda e Nova Lisboa.\n\nOs arquivos históricos revelam que a transição não foi pacífica. Muitos chefes tradicionais recusavam o valor facial das novas moedas, exigindo pagamentos em bens tangíveis ou mantendo o uso paralelo de moedas de troca ancestrais. Este sistema de economia dual persistiu por décadas, criando um mercado informal robusto que ainda hoje influencia a forma como os negócios são conduzidos em muitas feiras e mercados de Angola.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.onSurface, height: 1.6),
                        ),
                      ),
                    ),
                    // Fade Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [AppColors.background, AppColors.background.withValues(alpha: 0.6), AppColors.background.withValues(alpha: 0.0)],
                        ),
                      ),
                    ),
                    // Unlock Card
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primaryFixedDim.withValues(alpha: 0.2)),
                          boxShadow: [BoxShadow(color: AppColors.primaryContainer.withValues(alpha: 0.1), blurRadius: 24, offset: const Offset(0, 4))],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(color: AppColors.surfaceContainerHigh, shape: BoxShape.circle),
                              child: const Icon(Icons.lock, color: AppColors.primary, size: 28),
                            ),
                            const SizedBox(height: 16),
                            Text('Conteúdo para subscritores', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18, color: AppColors.onSurface, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text('Desbloqueie o acesso total aos nossos ensaios históricos e análises económicas premium.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () => Navigator.pushNamed(context, AppRoutes.subscription),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 56),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              child: const Text('Subscrever agora', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, AppRoutes.unlockedText),
                              child: const Text('Ver demonstracao (Desbloqueado)', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, decoration: TextDecoration.underline, decorationColor: AppColors.primary)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
