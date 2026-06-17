import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/constants/app_colors.dart';

class VideoPlayerScreen extends StatelessWidget {
  const VideoPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Force dark status bar for this screen
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: AppColors.onSurface, // #251817 - dark background
      body: Column(
        children: [
          // Video Player Section
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * (9 / 16) + MediaQuery.of(context).padding.top,
                color: Colors.black,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuByMv20H6ZeJZlWNMoTPzKkYMr_mexBkaqAN-XNBIbL_fZjfPnv5E4udaoOVAMBf3g3mvdn87LO4JszNdLCbm5cAIHuTkZfLRDH2yICMAp5SzWu7uiIBImZNlhLc9eSBTi_X-IHqtIa-K06uRIeN8Cua2aFcQd6c1v3ITOpcTqu1DlOX43Dth3KcQH9dBc0cGzz-nku2_AZMiYi9ZhA2wCpRj6CmyJL6CEgfmxYvNQhWMwIluUKKPdFlxxEnASFaKkYF8zfpe5jGb0',
                      fit: BoxFit.cover,
                      color: Colors.black.withValues(alpha: 0.4),
                      colorBlendMode: BlendMode.darken,
                    ),
                    SafeArea(
                      bottom: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Top App Bar over video
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                const Expanded(
                                  child: Text(
                                    'A Economia de Luanda Colonial',
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.share, color: Colors.white),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          // Play Button
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(color: AppColors.primaryContainer.withValues(alpha: 0.9), shape: BoxShape.circle),
                            child: const Icon(Icons.play_arrow, color: Colors.white, size: 40),
                          ),
                          // Controls overlay
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('12:45', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                    const Text('45:20', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 4,
                                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2)),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.28,
                                      height: 4,
                                      decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(2)),
                                    ),
                                    Positioned(
                                      left: MediaQuery.of(context).size.width * 0.28 - 6,
                                      top: -4,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Icon(Icons.subtitles, color: Colors.white, size: 20),
                                    const SizedBox(width: 16),
                                    const Icon(Icons.settings, color: Colors.white, size: 20),
                                    const SizedBox(width: 16),
                                    const Icon(Icons.fullscreen, color: Colors.white, size: 20),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Information Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Metadata
                  const Text(
                    'Ciclos do Café e a Estrutura Ferroviária: O Impacto em Angola (1850-1920)',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, height: 1.3),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('1.2k visualizações', style: TextStyle(color: AppColors.secondaryFixedDim, fontSize: 12)),
                      const SizedBox(width: 8),
                      const Text('•', style: TextStyle(color: AppColors.secondaryFixedDim, fontSize: 12)),
                      const SizedBox(width: 8),
                      const Text('Há 2 dias', style: TextStyle(color: AppColors.secondaryFixedDim, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Description
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nesta aula, exploramos como o boom do café no século XIX redefiniu as rotas comerciais angolanas e motivou a construção das primeiras grandes linhas de comboio. Uma análise profunda sobre herança colonial e desenvolvimento.',
                          style: TextStyle(color: AppColors.secondaryFixed.withValues(alpha: 0.9), height: 1.5),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('Ler mais', style: TextStyle(color: AppColors.primaryFixedDim, fontWeight: FontWeight.bold)),
                            const Icon(Icons.expand_more, color: AppColors.primaryFixedDim, size: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Transcription CTA
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.article),
                    label: const Text('Ver Transcrição Completa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Related Content
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Conteúdos relacionados', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Ver todos', style: TextStyle(color: AppColors.secondaryFixedDim)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Horizontal Scroll Cards
                  SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildRelatedCard(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDYO51r7j6d0KqkVfgqH-d15ml93jYUd3aT6CRs7Z_Hm74z72xsf9oH-K1pmFYmnW1l8dI1oc9PeQIGfdOd848ujwP_hTuMK3peFdRvASRSNSXg-iLQlQ2q6j974-QlPPp3hOLPssBz8dXJCxd1NjsQXzmT8zjD3qNlgz-VCVp31yv0PEEIQMevLEd7ncYNO3M4gOtv2s1DHeJU2WmZIOoGb44w9Ahr2pIWxYvNKcU2C_kfE_ObESHr85MltdtIFH7frUsaoq-MAyc',
                          '12:15',
                          'O Caminho de Ferro de Benguela',
                        ),
                        const SizedBox(width: 16),
                        _buildRelatedCard(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBSPtyAyC2-nVRsCJkOyy9MMQ0IEEcIoml3r8SAC_d6P__VN5QWDlDsRHNvJp6LtwrrhBbmwieE-8_v40OZ9fSLhrxgKbAzG860QBS3x4TEh-Z4dBG5qA58tz41Nje-sJqLfFn_f7N5VJzJCO2eFYr3ndZDunqE5q4yNIhTWPHqVNmvfU2mTfQMqWcwLTMmfFohdsyzztExuRk-eaGHOvJMgQUN6M9R_wm-Ay6LDr2ZPTxLLvXVpd5QePuzVhlpkbsr1qJlV81zSLk',
                          '08:40',
                          'Urbanismo e Comércio em 1900',
                        ),
                        const SizedBox(width: 16),
                        _buildRelatedCard(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuC1sOFm9cmVFGVMVsmhGPJt9y_IVTGksNTJrjOdjdzUqMkaLDzFm_cRm4IGTkeYTkbMWTefgw0uYRdJR_InzDF_GKfi4V0eQoAsI8NNv4nGV0t0kd5UJq74val0FN62n3t5-T9gqhwzISw3x_GAW2efu8W48-uT4wy0UIa_hGYcm_mpEHKUEqv9ctI8b7eHWJFtFKSX_IEmSMLEBKLZ4uYugokzz7E6MhWQ3EdLGKFV9KQUoDoJhdwIvVIKf4NMtj2LkOhfhxj8voo',
                          '15:22',
                          'Indústria e Porto: Luanda Antiga',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedCard(String imageUrl, String duration, String title) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
            ),
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(4)),
              child: Text(duration, style: const TextStyle(color: Colors.white, fontSize: 10)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
