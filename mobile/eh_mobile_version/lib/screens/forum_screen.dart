import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../services/mock_data_service.dart';
import '../widgets/bottom_nav_shell.dart';
import '../widgets/forum_topic_item.dart';
import '../widgets/screen_frame.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  String _selectedFilter = 'Todos';
  String _selectedTheme = 'Todos os Temas';
  bool _isThemeDropdownOpen = false;

  final List<String> _themes = ['Todos os Temas', 'Economia', 'História', 'Ancestralidade', 'Estudo Privado'];

  @override
  Widget build(BuildContext context) {
    final rawTopics = const MockDataService().topics();

    // Filter topics based on active tab and theme
    final topics = rawTopics.where((topic) {
      // Tab filter
      if (_selectedFilter == 'Públicos' && topic.private) return false;
      if (_selectedFilter == 'Privados' && !topic.private) return false;

      // Theme filter
      if (_selectedTheme != 'Todos os Temas' && topic.tag != _selectedTheme) return false;

      return true;
    }).toList();

    return BottomNavShell(
      index: 2,
      child: ScreenFrame(
        title: 'Fórum de Debate',
        paddingBottom: 96,
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.createTopic),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: const CircleBorder(),
          elevation: 4,
          child: const Icon(Icons.add, size: 28),
        ),
        children: [
          // Filter Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: ['Todos', 'Públicos', 'Privados'].map((tab) {
                final isSelected = _selectedFilter == tab;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(tab),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedFilter = tab;
                        });
                      }
                    },
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surfaceContainerHigh,
                    labelStyle: TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    showCheckmark: false,
                    side: const BorderSide(color: Colors.transparent),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Custom Filter by Theme Dropdown
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isThemeDropdownOpen = !_isThemeDropdownOpen;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.outlineVariant, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedTheme,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Icon(
                        _isThemeDropdownOpen ? Icons.expand_less : Icons.expand_more,
                        color: AppColors.outline,
                      ),
                    ],
                  ),
                ),
              ),
              if (_isThemeDropdownOpen) ...[
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.outlineVariant, width: 1),
                  ),
                  child: Column(
                    children: _themes.map((theme) {
                      final isSelected = _selectedTheme == theme;
                      return ListTile(
                        dense: true,
                        title: Text(
                          theme,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppColors.primary : AppColors.onSurface,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedTheme = theme;
                            _isThemeDropdownOpen = false;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),

          // Topic list with embedded Heritage Insight Card
          if (topics.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0),
              child: Center(
                child: Text(
                  'Nenhuma discussão encontrada.',
                  style: TextStyle(color: AppColors.secondary, fontSize: 14),
                ),
              ),
            )
          else ...[
            for (int i = 0; i < topics.length; i++) ...[
              ForumTopicItem(
                topic: topics[i],
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    topics[i].private ? AppRoutes.privateForumAccess : AppRoutes.forumTopic,
                    arguments: topics[i],
                  );
                },
              ),
              const SizedBox(height: 16),
              // Inject the Jindungo Insight Card after the second topic or if only 1 topic exists
              if (i == 0 || (topics.length == 1 && i == 0)) ...[
                Container(
                  padding: const EdgeInsets.all(16),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.bolt, color: Color(0xFFFFD700), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'INSIGHT DE PATRIMÓNIO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '"O Zimbo era mais do que moeda; era o pulso de uma rede económica que ligava Luanda ao interior muito antes das moedas metálicas."',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(height: 1, color: Colors.white.withValues(alpha: 0.2)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Fonte: Arquivos de História de Angola',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Action to discuss or read details
                              Navigator.pushNamed(context, AppRoutes.forumTopic);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Text(
                                'Discutir',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ],
        ],
      ),
    );
  }
}

