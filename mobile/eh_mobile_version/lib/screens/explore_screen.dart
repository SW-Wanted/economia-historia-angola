import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../widgets/bottom_nav_shell.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavShell(
      index: 1,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 1,
          shadowColor: const Color(0x0D000000),
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.outlineVariant,
                  image: DecorationImage(
                    image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCwHaX-C-MVLVqR110SIW5xv5NhK2e0lXKK418JGYVvOEPRvAR2iNJ_xdqaQr8XZVZIFDAjcNF0xSnOTpEaIA9430eLI4NT08pTMDYgIPDPN8YMBP_RMn5Md2MHDswokFE2CISy1ZE3R6qWXMTsCS1pisWzgQNc3uepUuTMpsOEY74gtjLjUTeChJHGvQJahzo5c-3wITSFJE8bzscOAVrYUAWBiVSXHZlAFZChFcsgO5bV0aO7o98r_pUpDsyED13T5aV1WRXOhGo'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text('Explorar', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.primary),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.searchResults),
            ),
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
              // Search Bar
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.searchResults),
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Pesquisar história e economia...',
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary),
                      prefixIcon: const Icon(Icons.search, color: AppColors.secondary),
                      filled: true,
                      fillColor: AppColors.surfaceContainerLowest,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                child: Row(
                  children: [
                    _buildFilterChip(context, 'Todos', true),
                    const SizedBox(width: 8),
                    _buildFilterChip(context, 'Microtextos', false),
                    const SizedBox(width: 8),
                    _buildFilterChip(context, 'Jindungo 🌶️', false),
                    const SizedBox(width: 8),
                    _buildFilterChip(context, 'Vídeos', false),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Jindungo Card (Asymmetric Layout Highlighting Heritage)
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.restrictedContent),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: const Color(0x0D000000), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        right: -16,
                        bottom: -16,
                        child: Opacity(
                          opacity: 0.1,
                          child: Icon(Icons.history, size: 120, color: Colors.white),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.bolt, color: AppColors.surfaceContainer, size: 18),
                              const SizedBox(width: 8),
                              Text('HERITAGE INSIGHT', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.surfaceContainerLowest.withValues(alpha: 0.9), letterSpacing: 1.0)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text('O Ciclo da Borracha no Planalto Central: Uma análise da resistência comercial.', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.onPrimary, fontStyle: FontStyle.italic, fontSize: 18)),
                          const SizedBox(height: 8),
                          Text('Explora as dinâmicas de poder entre os reinos locais e a administração colonial no século XIX.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onPrimary.withValues(alpha: 0.9)), maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Standard Content Card (Microtexto)
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.reading),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: const Color(0x0D000000), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 192,
                        width: double.infinity,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network('https://lh3.googleusercontent.com/aida-public/AB6AXuCjeQRwBF6cFqBb5mECTf9jgP8FgwuVFtORunPwqB0kPLOR5Qnf7LdmAOVHDAw5P4S_8KTuIjDrqCQORsk8o9RqfDhpWItobbDgXzYO2gosyXyziNvl_dI_N23NVf732tqfgfzmTF2mPoWWnnH6hM63xeNxE-qizdoMPhVSGtnbDehQFRYNwL8thTynLFqPZrEYHP_mciX1kzutkB2QMHKINOKtwGkMPUuRi0qF0BMzW2C_VUmvkCVjiMuSsml13Ce1bPO_r55W4r0', fit: BoxFit.cover),
                            Positioned(
                              top: 16,
                              left: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
                                child: const Text('MICROTEXTO', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                              ),
                            ),
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), shape: BoxShape.circle),
                                child: const Icon(Icons.lock, color: AppColors.primary, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('As Reformas Monetárias do Kwanza (1990-1999)', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18, color: AppColors.onSurface)),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(Icons.schedule, size: 18, color: AppColors.secondary),
                                const SizedBox(width: 4),
                                Text('6 min leitura', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                                const SizedBox(width: 16),
                                const Icon(Icons.visibility, size: 18, color: AppColors.secondary),
                                const SizedBox(width: 4),
                                Text('1.2k', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Video Content Card
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.videoPlayer),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: const Color(0x0D000000), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 192,
                        width: double.infinity,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network('https://lh3.googleusercontent.com/aida-public/AB6AXuB1NvritzeTzM-knI0X1Sg0rG06kgU6DcjKc5kavBT0CxkW33er_pWnmVe_6NCnn76hyDmBls1ttnXhqZZ_R3YwdkriRgU5H6ow8dLXGjYZ7t5BrSYpdLliTxxZzETuH-HT8c5Ibm4tuGdReEhCT4odM2V5jD5FRhIjLvTXcRgXZU1pV0NiQ-MiiAx0tIiC-wMthivlpzwz-87MjwmoqEktb_tjqJntkmEWykDUoCheObjzVSycq2rxavYSBz4ecuOFVqRu0uurtSw', fit: BoxFit.cover),
                            Container(color: Colors.black.withValues(alpha: 0.2)),
                            Center(
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.3), shape: BoxShape.circle, border: Border.all(color: Colors.white.withValues(alpha: 0.4))),
                                child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
                              ),
                            ),
                            Positioned(
                              top: 16,
                              left: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(color: AppColors.tertiary, borderRadius: BorderRadius.circular(16)),
                                child: const Text('VÍDEO', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('A Rota do Sal: Comércio Pré-Colonial na Costa Sul', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18, color: AppColors.onSurface)),
                            const SizedBox(height: 8),
                            Text('Uma jornada visual pelas antigas rotas comerciais que moldaram o intercâmbio regional.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary), maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Secondary Text Content

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.tertiary : AppColors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: isSelected ? null : Border.all(color: AppColors.outlineVariant),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: isSelected ? AppColors.onTertiary : AppColors.secondary, fontWeight: FontWeight.bold),
      ),
    );
  }
}
