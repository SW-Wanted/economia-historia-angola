import 'package:flutter/material.dart';
import 'dart:ui';

import '../core/constants/app_colors.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key, this.unlocked = false});

  final bool unlocked;

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
        title: Text(unlocked ? 'Economia com História' : 'O Café de Angola', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          if (!unlocked)
            IconButton(
              icon: const Icon(Icons.bookmark_outline, color: AppColors.secondary),
              onPressed: () {},
            ),
          if (unlocked)
            IconButton(
              icon: const Icon(Icons.notifications, color: AppColors.primary),
              onPressed: () {},
            ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: unlocked ? 100 : 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!unlocked) ...[
                  // Hero Image (T-09)
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network('https://lh3.googleusercontent.com/aida-public/AB6AXuAyiimGqeXe6GMoij9oC_-ZqL2anStFcK37vUah7wRN3mQA31hpd40wXYXh8hATUN_w_CtIum8j0ERRCQa2Eoz0hroPPe86nLhvj2UExodI7fOQKZp86LFGwc7zAKZRETYG-3fWEooLf2dDgMjP-68tkJWYBfiMoiyZpcmoqnEMVrPJMVxYeaRZe24eZGBn1ygOvtSXA2ewyBYztRgpKOxferHDe4tUAlKgq3ur4kLovmDqpPgw5uU8CY0Xjr9TpUNxC4Re_ZiEdog', fit: BoxFit.cover),
                        Positioned(
                          bottom: 16,
                          left: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
                            child: const Text('Microtexto', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (unlocked) ...[
                        // Metadata (T-11)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(16)),
                              child: Row(
                                children: [
                                  const Text('🌶️', style: TextStyle(fontSize: 12)),
                                  const SizedBox(width: 4),
                                  Text('JINDUNGO', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                                ],
                              ),
                            ),
                            Text('Leitura de 8 min', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text('A Ilusão do Petróleo: Por que a Riqueza Não Chega ao Musseque?', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.onSurface, fontSize: 28, height: 1.2)),
                        const SizedBox(height: 24),
                        // Featured Image (T-11)
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 4))],
                            image: const DecorationImage(
                              image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBP8zrYhN5dMLv1y4KJIy5Uo2IcFzFUEj9bOwTMwxf1Z4EyH76cg-nkbDDCoyuGiVxLa6bvIw60SE2sCwgay5yYpXfJOzq1z9RKozBtuHUhWM17eNgktO9QGLuzfauJedBg-JRzobPyw5FcFs9KkTzQy-sRjq1HeGPhDfIj7eyDHjceCRmBCSfDeAht3StYVaLUmDjEVTAAvRxD1iVmxj3v9zIAPD9o2kFwCsr3s92hT_V1rNcCXUc9BYFXkEdUFqlKZgI_1j5ezAs'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Jindungo Content (Critical)
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                            border: const Border(left: BorderSide(color: AppColors.surfaceTint, width: 4)),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4))],
                          ),
                          child: Text(
                            '"O problema não é a falta de dinheiro, é a abundância de intermediários. Enquanto celebramos barris por dia, o preço do pão no Zango ignora as cotações de Brent. A economia angolana é um teatro de sombras onde o palco é de ouro e a plateia está às escuras."',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, fontStyle: FontStyle.italic, height: 1.5),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Historicamente, a dependência do extrativismo moldou uma estrutura estatal que prioriza o fluxo de saída em detrimento da circulação interna. O que vemos hoje é a herança de uma economia de enclave, onde o petróleo é extraído sem nunca tocar a realidade produtiva local.\n\nA diversificação económica tornou-se um mantra vazio, repetido em fóruns internacionais enquanto as barreiras alfandegárias e a burocracia sufocam o pequeno produtor do Huambo. Sem infraestrutura básica, o custo de escoamento de uma saca de batata é superior ao lucro da venda, tornando a importação a única via — e o maior erro estratégico da nossa história recente.\n\nPrecisamos encarar a realidade: a "ajuda" externa e os empréstimos colateralizados em crude são apenas remendos num tecido social que clama por transparência e educação financeira real.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.onSurfaceVariant, height: 1.6),
                        ),
                        const SizedBox(height: 32),
                        const Divider(color: AppColors.outlineVariant),
                        const SizedBox(height: 32),
                        // Comments Section
                        Row(
                          children: [
                            const Icon(Icons.forum, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text('Comentários (2)', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18, color: AppColors.onSurface)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildComment(context, 'AM', 'António Manuel', 'Há 2 horas', 'Análise cirúrgica. O custo da logística interna é realmente o maior vilão da nossa produção nacional.'),
                        const SizedBox(height: 12),
                        _buildComment(context, 'SD', 'Sara Domingos', 'Há 5 horas', 'Finalmente alguém falou sobre a burocracia sufocante. Como jovem empreendedora, sinto isso todos os dias.'),
                      ] else ...[
                        // Metadata (T-09)
                        Text('A Evolução da Produção Cafeeira no Planalto Central (1960-1974)', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuC67-O5KkjcztAKB7YmR0bb9eUVJzTDpHtweAlk7VU2VTPXsMq4RnLOEwrgQN1VWXtrU7cpQM163SOFduzM_N5OxcVjIo5AegIhC-63uAf4rRMgnQ--vZ3w0eYCKJIB1En9floAk3nIYLU10YFBVDjdUaBSOzpubElEDTTyqWBo9mXGt1rvblTL71dE4X8FehFsq-wfIGZJTO65PnLXQE0-oL9L8oVRTWEX2H6ygacfLQvq9EJmJbRLImCxUdx582GTxOhnbO2vCdo'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Dr. Artur Mendes', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                                Text('12 de Outubro, 2023 • 5 min leitura', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Text Content
                        Text(
                          'A década de 1960 marcou um ponto de viragem sem precedentes na economia angolana. O café não era apenas um produto de exportação; era a espinha dorsal de uma infraestrutura em rápida expansão. O Planalto Central, com as suas características geoclimáticas únicas, tornou-se o epicentro de uma revolução agrícola que posicionou Angola como um dos maiores produtores mundiais da variante Robusta.\n\nEste fenómeno não se limitou apenas aos números de exportação. Houve uma profunda transformação social nas comunidades rurais, onde a introdução de novas técnicas de cultivo coexistiu com tensões latentes no sistema de trabalho. A análise histórica revela que o crescimento económico deste período foi acompanhado por um florescimento cultural nas cidades adjacentes às zonas de produção, criando uma elite intelectual que debatia o futuro da nação à volta das chávenas do próprio café que produziam.\n\nContudo, a dependência excessiva deste monocultivo também revelou as fragilidades estruturais que a economia enfrentaria em períodos de volatilidade de preços nos mercados internacionais, um tema que continua relevante para a diversificação económica da Angola contemporânea.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.onSurface, height: 1.6),
                        ),
                        const SizedBox(height: 32),
                        // Collapsible References
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                          ),
                          child: const ExpansionTile(
                            title: Text('Referências bibliográficas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            iconColor: AppColors.onSurface,
                            collapsedIconColor: AppColors.onSurface,
                            shape: Border(),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  '• CARVALHO, R. (1972). A Economia do Café em Angola. Luanda: Edições Ultramar.\n• SILVA, M. J. (2015). História Agrária do Planalto Central. Lisboa: Imprensa Académica.\n• Arquivo Nacional de Angola: Relatórios de Exportação (1965-1970).',
                                  style: TextStyle(height: 1.5, color: AppColors.secondary),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Discussion Questions
                        Text('Perguntas para debate', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18, color: AppColors.onSurface)),
                        const SizedBox(height: 16),
                        _buildQuestionCard(context, 'Como é que a infraestrutura ferroviária criada para o escoamento do café moldou a distribuição demográfica atual de Angola?'),
                        const SizedBox(height: 12),
                        _buildQuestionCard(context, 'Quais lições da "Época de Ouro" do café podem ser aplicadas à atual estratégia de diversificação agrícola no Huambo?'),
                        const SizedBox(height: 12),
                        _buildQuestionCard(context, 'Houve uma verdadeira transferência de tecnologia agrícola para as comunidades locais ou o sistema era puramente extrativo?'),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Fixed Bottom Actions
          Align(
            alignment: Alignment.bottomCenter,
            child: unlocked
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      boxShadow: [BoxShadow(color: const Color(0x0D000000), blurRadius: 12, offset: const Offset(0, -4))],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Adicionar um comentário crítico...',
                              hintStyle: const TextStyle(color: AppColors.secondary),
                              filled: true,
                              fillColor: AppColors.surfaceContainer,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          child: const Icon(Icons.send, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: 120,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [AppColors.surface, AppColors.surface.withValues(alpha: 0.0)],
                      ),
                    ),
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                      ),
                      child: const Text('Comentar este texto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildComment(BuildContext context, String initials, String name, String time, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(color: AppColors.secondaryFixed, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(initials, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.secondary)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(time, style: const TextStyle(fontSize: 10, color: AppColors.secondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: AppColors.primary, width: 4)),
        boxShadow: [BoxShadow(color: const Color(0x0D000000), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: AppColors.onSurface)),
    );
  }
}
