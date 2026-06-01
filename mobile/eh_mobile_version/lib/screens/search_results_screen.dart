import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _searchController = TextEditingController(text: 'Moeda');
  String _searchQuery = 'Moeda';

  // Mocked list of database items to search in
  final List<Map<String, dynamic>> _database = [
    {
      'type': 'article',
      'category': 'HISTÓRIA ECONÓMICA',
      'title': 'A Evolução do Kwanza no Pós-Independência',
      'description': 'Uma análise profunda sobre a transição monetária e o impacto das reformas econômicas de 1975 até à atualidade.',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBSHmYbWXTDzeEKoIZYNuCu6TlmxrnNkThZEwH7TMIFaigrcgDWVSir43N9KYZ6g9w_AW68yYTwtulzyWNooVf6dCzb7YH7qVtUsIbv23H5ctW50i1lEoGvVpXHJyzcZDq0pW2oS9K3bb5RWF0AiJo3vuUtdgcxMY40B4aOkoMKzuSk5vv9usoh6znj55XiukwyoaXLfE8t2a-cKN0c6_9pa2jxklYKgRisR8jBqZW9CrGJFH_N53B0-Jphhmee6XuC0WGADchQ8SE',
      'readingTime': '8 min de leitura',
    },
    {
      'type': 'forum',
      'category': 'Discussão no Fórum',
      'title': 'Digitalização da Moeda: O futuro do Kwanza?',
      'description': 'Será que a moeda digital pode ajudar na estabilização cambial de Angola? Participe no debate.',
      'commentsCount': '24 comentários ativos',
    },
    {
      'type': 'technical',
      'category': 'Documento Técnico',
      'title': 'Política Monetária do BNA',
      'description': 'Directrizes e relatórios do Banco Nacional de Angola sobre a inflação e taxas de juro em 2024.',
      'year': '2024',
    },
    {
      'type': 'article',
      'category': 'CULTURA & COMÉRCIO',
      'title': 'O Zimbo e a Moeda Tradicional Angolana',
      'description': 'A história de como as conchas eram usadas como meio de pagamento nas regiões costeiras antes da colonização.',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuD0dKPBTQrbxP3Bv52PNGhn03EC7Zqq9cyLZKopTXEsGIpegaK10DKjWfSPcR6vYQBEXRrzWYCS85FC5f-QuEdsmBhwHn33YTJCpSC0aQTWL9o13Vxuu5fveGGpecE89KArphFdk-MvjffOmYwwEQcO5gra-95ZKU_XcIlbv0_A0YvUbWkj5AAjTACV0qvNsZKDQcL5lFdJ1ioMPso-80xkGOggUdsNfQRZJH40AIQSpHFxzL-lcRpFvb5mr79YjOp6FSGhp6WVkAY',
      'readingTime': '5 min de leitura',
    }
  ];

  final List<String> _suggestions = [
    'Inflação',
    'Banco Central',
    'Câmbios',
    'História de Angola',
    'Mercados'
  ];

  List<Map<String, dynamic>> _getFilteredResults() {
    if (_searchQuery.isEmpty) return [];
    return _database.where((item) {
      final title = item['title'].toString().toLowerCase();
      final desc = item['description'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return title.contains(query) || desc.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = _getFilteredResults();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: Container(
          color: AppColors.surfaceContainerLowest,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuCi8KsiVM6TTb05RTZAra_Iub-UALvQgh4epFyTrB0-2fp_q2NOskUh_A_VPBchlYC0Rl9ZpXPtQK4vk0PsFSCCvqYoC4IlBA7Bmv584Sqt6HZDCGOpK1ixTz7rRD8Bj5GO-Qc-ZriGsh-VvF0kjo4fM1yK3C16zc5U39H-CZYiA2PyoWN6GO8Gts1GUQ2i2awlJQ-J9LzHBvhcyuhpMeyH6szE5TCYPXdBhrDjPpNU9AF8bgWA81G0vqtrnsOUKOXHfp2OkYJBFGw',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Economia com História',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: AppColors.primary),
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
                    ),
                  ],
                ),
                // Search input row
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.outlineVariant),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val;
                            });
                          },
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                            hintText: 'Pesquisar...',
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                          child: const Icon(Icons.close, color: AppColors.secondary, size: 20),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Results description
              Text(
                'A mostrar ${results.length} resultados para \'$_searchQuery\'',
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),

              // Results layout (Bento / Asymmetric style)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: results.length + 1, // +1 for the Jindungo Quiz card
                itemBuilder: (context, index) {
                  // We place the Jindungo Card after the 2nd result or at the end if fewer
                  final targetJindungoIndex = results.length >= 2 ? 2 : results.length;

                  if (index == targetJindungoIndex) {
                    return _buildJindungoQuizCard();
                  }

                  final itemIndex = index > targetJindungoIndex ? index - 1 : index;
                  if (itemIndex >= results.length) return const SizedBox.shrink();

                  final item = results[itemIndex];
                  return _buildResultCard(item);
                },
              ),
              const SizedBox(height: 12),

              // Related Suggestions
              const Text(
                'Sugestões relacionadas',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _suggestions.map((suggestion) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _searchController.text = suggestion;
                        _searchQuery = suggestion;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.outlineVariant),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        suggestion,
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> item) {
    final type = item['type'].toString();

    if (type == 'forum') {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: const Border(
            left: BorderSide(color: AppColors.primary, width: 4),
          ),
          boxShadow: const [
            BoxShadow(
              color: const Color(0x0D000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.forum, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text(
                  'Discussão no Fórum',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              item['title'].toString(),
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Simulating participant avatars
                SizedBox(
                  width: 48,
                  height: 24,
                  child: Stack(
                    children: const [
                      Positioned(
                        left: 0,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCP258sHHWOOqa4R9IZSb_UfpXu8P1mBVdPeSLCOFMeQly5XkPI15NTMHjH4AhgqAU7PHOL22ijTsGhitEaPyg-W86MtitYmopgcAJQYZo8spGoWMs7gFG6tN3J1aS9ASRM7bKEEodJnuIfP5QH92nep4spo-O1-iqKvF4QM9QvB7a7fN4kzSluw-MpHjdJRaNv6ggjbSajIAlknLMueGJlCP0MTVxNjsMcUDQuJmIzSxbo1abWp1nZtMSIkcGxzdm03wgxChSPYns'),
                        ),
                      ),
                      Positioned(
                        left: 14,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAPTBCDug2vPqr3qNsV9dL7o3ozDpzTsfi7czLZHUkZG-qnqzqpfcEyOQBaN4vFrPTElOHyVirCbMRTRejFpAG_f5upJch-yB03JhpQ3Fh_bkNHSCw3Cc1cf-KJKEyU8FJD74NQELuYfaNC47v2xUjHUvE2UcQ2_G6MeVS9-h9_w3mrm9fSRgtFzlNTaTQci58VgQ3x7q4Y6vz6F2_yTeI_I7SK0JTL_C9jmmUWw17l8puSBY3grbw6HOLsgMRcVvZR01UtHzky138'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item['commentsCount'].toString(),
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (type == 'technical') {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: const Color(0x0D000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.account_balance, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'].toString(),
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item['category']} • ${item['year']}',
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.outline),
          ],
        ),
      );
    }

    // Default: Article Card with Image
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: const Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Artigo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.bookmark_border, color: AppColors.secondary, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'].toString(),
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['description'].toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (item['imageUrl'] != null) ...[
                const SizedBox(width: 12),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(item['imageUrl'].toString()),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                item['category'].toString(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '• ${item['readingTime']}',
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJindungoQuizCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.bolt, color: Colors.amber, size: 18),
              SizedBox(width: 6),
              Text(
                'DESAFIO RÁPIDO',
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Conheces a origem da palavra \'Kwanza\'?',
            style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Teste os seus conhecimentos sobre a herança linguística das nossas trocas comerciais.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.quizHub);
            },
            child: const Text(
              'Começar Quiz',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
