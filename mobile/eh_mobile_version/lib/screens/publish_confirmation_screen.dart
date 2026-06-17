import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';

class PublishConfirmationScreen extends StatelessWidget {
  const PublishConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dynamic article title passed as route argument (defaulting to A Evolução do Kwanza)
    final articleTitle = ModalRoute.of(context)?.settings.arguments as String? ?? 'A Evolução do Kwanza';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black12,
        automaticallyImplyLeading: false, // Suppress back button for transactional flow completeness
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuC7uZy08XPLbm4kZRK6ES1yN_XQU0XlVH85pUdlH2hI4SmHc7z4WF_oYthwx_b0MkpyPvLkS_1kq1q7oaB3BzEQOazyhV0-hJ6sxtZIoSYveTnmSq_0PHLsTTH0X2TIzd-0c73oCgJgJ2YPe0MzwkuM-UGDRKTU__9nXF0OeYA8m4X4AgtiXyLYcXb59PTqWUMl33xCAsh0nc3xTTBlrofXuXiWRk9mMOiQJExfmgjhP26ZuQtn8bOm8HUv9AcU-4IrpePqKug3y-8',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          'Economia com História',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.primary),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Custom visual centering
                    children: [
                      const SizedBox(height: 40),
                      // Wax Seal / Illustrative Graphic with Glow
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 192,
                            height: 192,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withOpacity(0.05),
                            ),
                          ),
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.surfaceContainerLowest,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.1),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.network(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuD-2kV8xdAHY3A_vmhy9BqEgHpGFqpXhTcqk5Gmg27M8qjp0v2UGtwe1HLRqxamEDuffQLawE-dvrMhc21BbCC_6FVRzZBwOv2ZuOamUuVKyTgsvQVht9TNBCRdI_h8yggehcvFHIltBnvtaHiihLCo6dbTYFHqv9sS4WCPADt8ElmWCo5vs_IRqa6TN39k-yxU26nRY5SZZ-DkzXIlneYViMNyX4H7d1AIAoCPxSOYW4bUvQqCGOrVcHIY-Fm48WYxvlEFlpNGhYY',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.tertiary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.history_edu,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Success Messages
                      const Text(
                        'Artigo Publicado com Sucesso!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.secondary,
                            fontFamily: 'Lexend',
                          ),
                          children: [
                            const TextSpan(text: 'O seu artigo '),
                            TextSpan(
                              text: '\'$articleTitle\'',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const TextSpan(text: ' já está disponível para todos os utilizadores.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Action Stack
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryContainer,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                // Navigate to read the article (or simulated reading view)
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.reading,
                                  arguments: {
                                    'title': articleTitle,
                                    'category': 'HISTÓRIA ECONÓMICA',
                                    'description': 'Análise recém-publicada por si.',
                                    'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBSHmYbWXTDzeEKoIZYNuCu6TlmxrnNkThZEwH7TMIFaigrcgDWVSir43N9KYZ6g9w_AW68yYTwtulzyWNooVf6dCzb7YH7qVtUsIbv23H5ctW50i1lEoGvVpXHJyzcZDq0pW2oS9K3bb5RWF0AiJo3vuUtdgcxMY40B4aOkoMKzuSk5vv9usoh6znj55XiukwyoaXLfE8t2a-cKN0c6_9pa2jxklYKgRisR8jBqZW9CrGJFH_N53B0-Jphhmee6XuC0WGADchQ8SE',
                                  },
                                );
                              },
                              child: const Text(
                                'Ver artigo agora',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.primaryContainer, width: 2),
                                foregroundColor: AppColors.primaryContainer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                // Back to dashboard or admin panel
                                Navigator.popUntil(
                                  context,
                                  ModalRoute.withName(AppRoutes.dashboard),
                                );
                              },
                              child: const Text(
                                'Voltar ao painel',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // Heritage Insight Card at Bottom
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.bolt, color: Colors.amber, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '"O registo histórico é a base para o planeamento do futuro económico. A sua contribuição fortalece a nossa identidade nacional."',
                                style: TextStyle(
                                  fontFamily: 'Lexend',
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                  height: 1.4,
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
            ),
          ],
        ),
      ),
    );
  }
}
