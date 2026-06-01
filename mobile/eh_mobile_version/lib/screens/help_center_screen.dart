import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  // Local state to track which FAQ is expanded (null if none, 1 by default matching Stitch)
  int? _expandedIndex = 1;

  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'Como posso contribuir para o fórum?',
      'answer': 'Para contribuir para o fórum, basta aceder à secção "Fórum de Debate", clicar no botão flutuante "+" no canto inferior direito e preencher os detalhes como Título, Tema e Mensagem. Pode também marcar o seu tópico como privado se desejar limitar o acesso via código.',
    },
    {
      'question': 'O que é a curadoria "Jindungo"?',
      'answer': 'A curadoria Jindungo representa os nossos conteúdos de maior impacto e profundidade histórica. São análises "picantes" que desafiam o status quo económico e trazem à luz factos históricos angolanos frequentemente esquecidos.',
      'tip': 'Dica: Procure pelo ícone de relâmpago para encontrar estas análises exclusivas.',
    },
    {
      'question': 'Os dados económicos são oficiais?',
      'answer': 'Sim, todos os dados económicos e estatísticos apresentados baseiam-se em arquivos históricos oficiais do Banco Nacional de Angola (BNA), do Instituto Nacional de Estatística (INE) e de publicações académicas validadas por historiadores.',
    },
    {
      'question': 'Posso usar os gráficos em trabalhos académicos?',
      'answer': 'Com certeza! Incentivamos a utilização do nosso conteúdo em pesquisas, monografias ou trabalhos académicos. Solicitamos apenas que cite a plataforma "Economia com História" e a respetiva fonte original indicada em cada artigo.',
    },
  ];

  void _toggleFaq(int index) {
    setState(() {
      if (_expandedIndex == index) {
        _expandedIndex = null;
      } else {
        _expandedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
        ),
        title: const Text(
          'Ajuda',
          style: TextStyle(
            color: AppColors.primary,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pesquisa em desenvolvimento...')),
              );
            },
            icon: const Icon(Icons.search, color: AppColors.secondary),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Text(
                'AS',
                style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // FAQ Intro
          const Text(
            'Perguntas Frequentes',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tudo o que precisa de saber sobre a Economia com História.',
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),

          // Accordion List
          Column(
            children: List.generate(_faqs.length, (index) {
              final faq = _faqs[index];
              final isExpanded = _expandedIndex == index;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isExpanded ? AppColors.primaryContainer : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => _toggleFaq(index),
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                faq['question'] as String,
                                style: TextStyle(
                                  fontFamily: 'Lexend',
                                  fontSize: 15,
                                  fontWeight: isExpanded ? FontWeight.bold : FontWeight.w500,
                                  color: isExpanded ? AppColors.primary : AppColors.onSurface,
                                ),
                              ),
                            ),
                            Icon(
                              isExpanded ? Icons.remove : Icons.add,
                              color: isExpanded ? AppColors.primary : AppColors.secondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isExpanded) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 1,
                              color: AppColors.outlineVariant.withValues(alpha: 0.4),
                              margin: const EdgeInsets.only(bottom: 12),
                            ),
                            Text(
                              faq['answer'] as String,
                              style: const TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                            if (faq.containsKey('tip')) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryFixed,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.bolt,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        faq['tip'] as String,
                                        style: const TextStyle(
                                          color: AppColors.onPrimaryFixed,
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 16),

          // Contact CTA box
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.support_agent,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ainda com dúvidas?',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'A nossa equipa e a comunidade estão prontas para o ajudar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Canal de suporte direto aberto!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.forum, size: 18),
                    label: const Text(
                      'Fale connosco',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

