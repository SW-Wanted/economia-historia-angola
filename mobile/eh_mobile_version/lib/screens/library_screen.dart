import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _activeTab = 'Salvos';

  // List of stateful mock saved items matching Stitch design
  final List<Map<String, dynamic>> _savedItems = [
    {
      'id': 1,
      'title': 'O Caminho de Ferro de Benguela: Impactos',
      'subtitle': 'Uma análise profunda sobre a infraestrutura que moldou a economia do interior de Angola no século XX.',
      'type': 'Microtexto',
      'time': 'Há 2 dias',
      'duration': '5 min de leitura',
      'isSaved': true,
      'isHeritage': false,
      'imageColor': Colors.blueGrey,
    },
    {
      'id': 2,
      'title': 'Mercados Tradicionais e a Economia de Troca',
      'subtitle': 'A evolução dos mercados de rua de Luanda e o seu papel na resistência cultural e económica.',
      'type': 'Vídeo',
      'time': 'Há 4 dias',
      'duration': '12 min de vídeo',
      'isSaved': true,
      'isHeritage': true,
      'imageColor': AppColors.primaryContainer,
    },
    {
      'id': 3,
      'title': 'Moedas e Soberania: O Kwanza através dos tempos',
      'subtitle': 'Explorando as reformas monetárias que definiram as fases da reconstrução nacional.',
      'type': 'Microtexto',
      'time': 'Há 1 semana',
      'duration': '8 min de leitura',
      'isSaved': true,
      'isHeritage': false,
      'imageColor': Colors.amber,
    }
  ];

  void _toggleSave(int id) {
    setState(() {
      final index = _savedItems.indexWhere((item) => item['id'] == id);
      if (index != -1) {
        _savedItems[index]['isSaved'] = !_savedItems[index]['isSaved'];
      }
    });

    final item = _savedItems.firstWhere((element) => element['id'] == id);
    final statusText = item['isSaved'] as bool ? 'salvo na' : 'removido da';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"${item['title']}" foi $statusText biblioteca.')),
    );
  }

  void _clearAll() {
    setState(() {
      for (var item in _savedItems) {
        item['isSaved'] = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Biblioteca limpa com sucesso.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show only currently saved items for "Salvos" tab, otherwise full list for demo
    final activeItems = _savedItems.where((item) {
      if (_activeTab == 'Salvos') {
        return item['isSaved'] as bool;
      }
      return true; // For "Histórico" or "Downloads" tabs we show all as a fallback
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
        ),
        title: const Text(
          'Minha Biblioteca',
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
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
            icon: const Icon(Icons.notifications, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Tabs & Clear All Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: ['Salvos', 'Histórico', 'Downloads'].map((tab) {
                  final isSelected = _activeTab == tab;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(tab),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _activeTab = tab;
                          });
                        }
                      },
                      selectedColor: AppColors.tertiary,
                      backgroundColor: AppColors.secondaryFixed,
                      labelStyle: TextStyle(
                        fontFamily: 'Lexend',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.secondary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      showCheckmark: false,
                      side: const BorderSide(color: Colors.transparent),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                  );
                }).toList(),
              ),
              if (activeItems.isNotEmpty)
                TextButton(
                  onPressed: _clearAll,
                  child: const Text(
                    'Limpar tudo',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontFamily: 'Lexend',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Items List
          if (activeItems.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Icon(
                    Icons.bookmark_outline,
                    size: 64,
                    color: AppColors.secondary.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sua biblioteca está vazia',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Salve microtextos e vídeos para ver mais tarde.',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: activeItems.map((item) {
                final isHeritage = item['isHeritage'] as bool;
                final isSaved = item['isSaved'] as bool;

                if (isHeritage) {
                  // Premium Heritage Video Card Style
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x0D000000),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Video thumbnail
                        Stack(
                          children: [
                            Container(
                              height: 160,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: (item['imageColor'] as Color).withValues(alpha: 0.8),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.onTertiaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  (item['type'] as String).toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Card Body
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item['title'] as String,
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _toggleSave(item['id'] as int),
                                    icon: Icon(
                                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item['subtitle'] as String,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.bolt,
                                    color: Color(0xFFFFD700),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Insight de Património',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Standard Microtexto Horizontal Card Style
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x0D000000),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left Thumbnail
                        Container(
                          width: 100,
                          color: (item['imageColor'] as Color).withValues(alpha: 0.1),
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(
                                  Icons.menu_book,
                                  color: (item['imageColor'] as Color).withValues(alpha: 0.7),
                                  size: 32,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    (item['type'] as String).toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right Body
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item['title'] as String,
                                        style: const TextStyle(
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => _toggleSave(item['id'] as int),
                                      icon: Icon(
                                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                                        color: AppColors.primaryContainer,
                                      ),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item['subtitle'] as String,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.secondary,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item['time'] as String,
                                      style: const TextStyle(
                                        color: AppColors.outline,
                                        fontSize: 11,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.schedule,
                                          color: AppColors.outline,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          item['duration'] as String,
                                          style: const TextStyle(
                                            color: AppColors.outline,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

