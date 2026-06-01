import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../widgets/bottom_nav_shell.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavShell(
      index: 0,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 1,
          shadowColor: const Color(0x0D000000),
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryFixed, width: 2),
                  image: const DecorationImage(
                    image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAkiDf5Ze7TkmE2P4dFS5KdNhIfTgNHD260tgLLUi9suvvXws9XJQv_F9TCaZ5KbIp0DqQa6fjfRfIHcLpVEO5jLBqnpqrHJS7OlHZ1TouAGMaZv7pITIRk5bpAfhRaLAJ6AM85kRGEUDmhTMFYv2yVqa7XhHCjzrOKhRARm9y4JR8BZiz4VyoK5VPxpeTs3eRnnUX5mSmzDExOC_J8eJFAFYvyasEeossyP8fXsyZAx1uGL6Ml6KxMBopaV40hgtv4rEM8pgU4hBs'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text('Olá, Manuel 👋', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: AppColors.primary),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Continuar onde parou
              Text('Continuar onde parou', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18, color: AppColors.onSurface)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: const Color(0x0D000000), blurRadius: 12, offset: const Offset(0, 4))]),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: const DecorationImage(
                          image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDBg-TtjGdWx5syG1hnE1pTOJ-aXqs05wKVZtg5IqvXCwvfOYctYghbH5GssVCJ7XJToMA_1CfuRI2DycNNaSJtuti9W7XUput1Lyx-vyCFztTZJze305GH-ousg28jgx_JP6sQ8MJCo1v59bG8WpCuZsmJgQ-sIfXIHTwTEyDJ65IKvviCqdIEwpmXaFVK81-hFjZ2o5sYbBvYR04DqzMcrF3Cd-rgUuylRKHr3LE5_HAkn8cebFXDqaGWhIv7lTx7I-c9-dMLB7A'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ciclos Económicos: 1975-1992', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 16, height: 1.2, color: AppColors.onSurface)),
                          const SizedBox(height: 4),
                          Text('Módulo 3 • Aula 4', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: 0.65,
                              minHeight: 8,
                              backgroundColor: AppColors.surfaceVariant,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryContainer),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Align(alignment: Alignment.centerRight, child: Text('65% concluído', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Quiz da Semana Banner
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF8B1A1A), Color(0xFF690008)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      right: -20,
                      top: -10,
                      child: Opacity(
                        opacity: 0.2,
                        child: Icon(Icons.quiz, size: 80, color: Colors.white),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quiz da Semana', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text('Teste seus conhecimentos sobre o Café em Angola.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.9))),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.quizHub),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.surfaceContainerLowest,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('COMEÇAR AGORA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Destaques
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Destaques', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18, color: AppColors.onSurface)),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: Text('Ver todos', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  children: [
                    _buildHighlightCard(context, 'ECONOMIA', 'Impacto do Setor Petrolífero', 'https://lh3.googleusercontent.com/aida-public/AB6AXuASpU4RfkM4_4Mo4qwypHOC7PoHPBTYRDqnkCWlUK-Chcx7nwcPrIv-uxpvoCte39LOMaxd0m9q4ReDobBuT8bWGw8dkxl7P5A8ks8uHAZMxlg-lST17UC29kRB8cvy6vB2Y3EWbkk8L87Mb6ieF59xvQXOw25sfDfk5OhS9-jWJ-m-sbKk0JYFdno5LBzel27iYaltF-rdWqSjEKo1YnerwtaTKZX_8zt1UMSgvCQIHCkS52NbeGCQdKNCofIpa5DiZFCD4AxWJ2k'),
                    const SizedBox(width: 16),
                    _buildHighlightCard(context, 'HISTÓRIA', 'Rotas de Comércio do Século XIX', 'https://lh3.googleusercontent.com/aida-public/AB6AXuBSemxzZQx0KdAyCleJSPp10eVGhx8h2gdDR082SDZRGaNriU0U51F3oQJK_DeImCV1YzWUEizLkdeUxl6bf7hw0Jq0fXKC2RhLbE0-XlW9ncxZ5yNuPXgOsuoKQxCYUcbrhOs_pcKSfUEqjzOsxb923Ji7OYmJsW1NKAB2PDCjMhC8xiHWZaJn44wLXtpvjzV_PSosxMCyeI5MoHRFtNljEhL9DjmbqKhr-hUe4oYZaXu07r8tMqgvKPm2elPT0bMddWGoL1bh57Y'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Textos com Jindungo
              Row(
                children: [
                  Text('Textos com Jindungo', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18, color: AppColors.onSurface)),
                  const SizedBox(width: 8),
                  const Text('⚡'),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('"A análise definitiva sobre a inflação estrutural e a herança colonial nos mercados do Lobito."', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onPrimary, fontStyle: FontStyle.italic)),
                              const SizedBox(height: 8),
                              Text('— Dr. Kambinda, 2023', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onPrimary.withValues(alpha: 0.7))),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.lock, color: AppColors.onPrimary.withValues(alpha: 0.6)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(color: AppColors.onPrimary.withValues(alpha: 0.1)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Exclusivo para membros Premium', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onPrimary.withValues(alpha: 0.8), fontStyle: FontStyle.italic)),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          child: Text('Assinar', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onPrimary, fontWeight: FontWeight.bold, decoration: TextDecoration.underline, decorationColor: AppColors.onPrimary)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Exploração Regional (Mapa)
              Text('Exploração Regional', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18, color: AppColors.onSurface)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.map),
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: const Color(0x0D000000), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ColorFiltered(
                        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDdjDGwMfl5eBeTtzY3iTxsBTBCyKh3_sNO96ccbytHEmwmoOgX_lUkg_JqxR33yz_YMMVLDkROiMtsT7WZJ8NnSNZ7t5IUhGk2OwC75icE0px7d2siVuVIwzIBhIAUs4yl7aTjhF77zL0SRNOimRPcfmPLmggkwBiUwBDQdfTZFUmjmVB5u-30qFGwTmiMh8jTtOFg6Bu-_GQI6jV33lBs_xMfvw9MPKoX36Lwtf5gUGILb-OtKlyVQtgHlLEXDMzm5ljaujSJmkE',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(color: Colors.black.withValues(alpha: 0.2)),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mapa Interativo', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22, color: Colors.white)),
                            Text('Descubra a história por província', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white.withValues(alpha: 0.8))),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2))]),
                          child: const Icon(Icons.map, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightCard(BuildContext context, String tag, String title, String imageUrl) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: const Color(0x0D000000), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 110,
            width: double.infinity,
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tag, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1.0)),
                const SizedBox(height: 4),
                Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 14, height: 1.2, color: AppColors.onSurface), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
