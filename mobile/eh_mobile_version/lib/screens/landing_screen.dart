import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
              child: const Icon(Icons.account_circle, color: AppColors.onPrimary, size: 20),
            ),
            const SizedBox(width: 12),
            Text('Economia com História', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.secondary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              color: AppColors.primaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    right: -60,
                    bottom: -80,
                    child: Icon(Icons.history_edu, size: 200, color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aprenda a economia de Angola pela sua história',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 30, color: AppColors.onPrimary, height: 1.2),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.register1),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.onPrimary,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 4,
                        ),
                        child: const Text('COMEÇAR AGORA', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // "O que é?" Section
            Container(
              width: double.infinity,
              color: AppColors.surfaceContainerLowest,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 4, height: 24, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 8),
                      Text('O que é?', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Uma plataforma dedicada a desvendar os fios que tecem a realidade económica angolana, desde as suas raízes históricas até aos desafios contemporâneos. Aqui, o rigor académico encontra a acessibilidade cultural.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.onSurface, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.school, color: AppColors.primary),
                              const SizedBox(height: 8),
                              Text('Rigor Académico', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.auto_stories, color: AppColors.primary),
                              const SizedBox(height: 8),
                              Text('Herança Cultural', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // "O que vai encontrar?" Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 4, height: 24, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 8),
                      Text('O que vai encontrar?', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildFeatureCard(context, Icons.article, 'Microtextos', 'Pílulas de conhecimento rápido sobre eventos económicos cruciais.', () {}),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.restrictedContent),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 4))]),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            right: -20,
                            bottom: -20,
                            child: Transform.rotate(angle: 0.2, child: Icon(Icons.people, size: 80, color: Colors.white.withValues(alpha: 0.2))),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text('⚡'),
                                      const SizedBox(width: 8),
                                      Text('Textos Jindungo', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: 18)),
                                    ],
                                  ),
                                  const Icon(Icons.lock, color: Colors.white),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text('Análises profundas e picantes sobre a nossa herança económica. Conteúdo exclusivo para membros.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.9), fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(context, Icons.quiz, 'Quiz', 'Teste os seus conhecimentos e aprenda de forma interativa.', () {}),
                ],
              ),
            ),
            
            // Preview Mapa Angola
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Container(
                decoration: BoxDecoration(color: AppColors.surfaceContainerHighest, borderRadius: BorderRadius.circular(24)),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mapa Económico', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 18)),
                          const SizedBox(height: 8),
                          Text('Explore a história por província.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(color: AppColors.surfaceDim),
                          Opacity(
                            opacity: 0.6,
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuB-_hVkE_o0rlYqTlmzmjUSa7fevzBm0BXsMwt01UMVGs6KdPJ576R8mD77WpyAQRDQuO_qFo2Sph-mdB5BEynRn3c-x2Ln-UY-TBpGk3CxBW-sKr8ebbUwVylIUr9iHQOlbcJH1JJXCU2qVrzRM91lk2jseflouV_FFc0KsfdOEsZB9ecE94NupJEwp3qmhLN_ZpbngL1gzP-eOlQg1xlgOZW64KtAy97vL-d2HbjF2SdqhYe8cT5JOzN39DectDmcsJ43tos95OU',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(color: AppColors.surfaceVariant),
                            ),
                          ),
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.pushNamed(context, AppRoutes.map),
                              icon: const Icon(Icons.map, size: 18),
                              label: const Text('Abrir Mapa', style: TextStyle(fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withValues(alpha: 0.9),
                                foregroundColor: AppColors.primary,
                                elevation: 4,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // FAQ Accordion (Static)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Perguntas Frequentes', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 18)),
                  const SizedBox(height: 16),
                  _buildFaqItem(context, 'O conteúdo é gratuito?'),
                  _buildFaqItem(context, 'Quem escreve os textos?'),
                  _buildFaqItem(context, 'Como posso contribuir?'),
                ],
              ),
            ),
            
            // CTA Final
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 8))]),
                child: Column(
                  children: [
                    Text('Pronto para a jornada?', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontSize: 18)),
                    const SizedBox(height: 8),
                    Text('Junte-se a milhares de angolanos que estão a redescobrir a nossa história.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.8))),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 4,
                        ),
                        child: const Text('INSCREVER-SE AGORA', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              color: AppColors.surfaceDim,
              child: Text(
                '© 2024 Economia com História. Luanda, Angola.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, IconData icon, String title, String desc, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)), boxShadow: [BoxShadow(color: const Color(0x0D000000), blurRadius: 12, offset: const Offset(0, 4))]),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(color: AppColors.surfaceContainer, shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 16, color: AppColors.onSurface)),
                  const SizedBox(height: 4),
                  Text(desc, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, String question) {
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.outlineVariant))),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(question, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.onSurface)),
          const Icon(Icons.expand_more, color: AppColors.secondary),
        ],
      ),
    );
  }
}
