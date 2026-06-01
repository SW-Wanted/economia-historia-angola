import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/forum_topic.dart';

class ForumTopicScreen extends StatefulWidget {
  const ForumTopicScreen({super.key});

  @override
  State<ForumTopicScreen> createState() => _ForumTopicScreenState();
}

class _ForumTopicScreenState extends State<ForumTopicScreen> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Mock list of comments matching Stitch T-19 design
  final List<Map<String, dynamic>> _comments = [
    {
      'author': 'Ana Paula Costa',
      'role': 'Mestrado em História Económica',
      'timeAgo': '15m',
      'content': 'Excelente ponto, Dr. Manuel. Na minha pesquisa sobre o Planalto Central, notei que a agricultura de subsistência transicionou para comercial quase instantaneamente após 1928 em Caála.',
      'isInsight': false,
      'avatarColor': Colors.teal,
    },
    {
      'author': 'João Domingos',
      'role': 'Doutorado em Economia Aplicada',
      'timeAgo': '42m',
      'content': 'É importante não esquecer o papel das companhias concessionárias. Elas controlavam o acesso ferroviário para pequenos produtores, o que muitas vezes criava gargalos artificiais no mercado.',
      'isInsight': false,
      'avatarColor': Colors.indigo,
    },
    {
      'author': 'Sara Ventura',
      'role': 'História de Angola',
      'timeAgo': '1h',
      'content': '"A linha férrea não apenas transportava minério; ela redesenhava o mapa das identidades culturais e económicas de Angola." Que insight fascinante para explorarmos no próximo seminário.',
      'isInsight': true, // Jindungo Style
      'avatarColor': AppColors.primaryContainer,
    }
  ];

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _comments.add({
        'author': 'Manuel Kiala (Você)',
        'role': 'Mestre Jindungo',
        'timeAgo': 'Agora',
        'content': text,
        'isInsight': text.startsWith('"') || text.length > 100, // Make it insight if quoted or long
        'avatarColor': AppColors.primary,
      });
      _commentController.clear();
    });

    // Scroll to bottom after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Attempt to extract the topic passed as argument
    final passedTopic = ModalRoute.of(context)?.settings.arguments as ForumTopic?;

    final topicTitle = passedTopic?.title ??
        'Impacto das infraestruturas ferroviárias no comércio de Benguela (1920-1950)';
    final topicCategory = passedTopic?.tag ?? 'ECONOMIA COLONIAL';
    final topicAuthor = passedTopic?.author ?? 'Dr. Manuel Silva';
    final topicTime = passedTopic?.timeAgo ?? '2h atrás';
    final topicDesc = passedTopic?.description ??
        'Gostaria de iniciar um debate sobre como a expansão do Caminho de Ferro de Benguela influenciou não apenas o escoamento de minérios, mas a própria estrutura agrária da região central de Angola. Existem dados que correlacionam o crescimento das feiras locais com os pontos de paragem secundários?';
    final topicReplies = passedTopic?.comments ?? 12;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
        ),
        title: const Text(
          'Fórum',
          style: TextStyle(
            color: AppColors.primary,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Link do tópico copiado!')),
              );
            },
            icon: const Icon(Icons.share, color: AppColors.secondary),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              children: [
                // Main Topic Header Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              topicCategory.toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.primaryContainer,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• $topicTime',
                            style: const TextStyle(
                              color: AppColors.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        topicTitle,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withValues(alpha: 0.1),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              topicAuthor.isNotEmpty ? topicAuthor[0].toUpperCase() : 'U',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            topicAuthor,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        topicDesc,
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(height: 1, color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.forum, color: AppColors.primary, size: 20),
                              const SizedBox(width: 6),
                              Text(
                                '$topicReplies Comentários',
                                style: const TextStyle(
                                  color: AppColors.onSurface,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 24),
                          Row(
                            children: [
                              const Icon(Icons.thumb_up_outlined, color: AppColors.secondary, size: 20),
                              const SizedBox(width: 6),
                              const Text(
                                '45',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Discussion Divider
                Row(
                  children: [
                    Expanded(child: Container(height: 1, color: AppColors.outlineVariant)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'DISCUSSÃO',
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    Expanded(child: Container(height: 1, color: AppColors.outlineVariant)),
                  ],
                ),
                const SizedBox(height: 20),

                // Comments List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    final comment = _comments[index];
                    final isInsight = comment['isInsight'] as bool;

                    if (isInsight) {
                      // Jindungo / Heritage Insight Card style
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.15),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                comment['author'][0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  comment['author'],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                const Icon(
                                                  Icons.bolt,
                                                  color: Color(0xFFFFD700),
                                                  size: 16,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              comment['role'],
                                              style: TextStyle(
                                                color: Colors.white.withValues(alpha: 0.7),
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        comment['timeAgo'],
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.7),
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    comment['content'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      height: 1.4,
                                      fontFamily: 'Lexend',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap: () {
                                      _commentController.text = '@${comment['author']} ';
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.reply, color: Colors.white.withValues(alpha: 0.9), size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Responder',
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.9),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
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
                      );
                    }

                    // Standard comment card
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (comment['avatarColor'] as Color).withValues(alpha: 0.1),
                              border: Border.all(color: AppColors.outlineVariant, width: 1),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              comment['author'][0].toUpperCase(),
                              style: TextStyle(
                                color: comment['avatarColor'] as Color,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            comment['author'],
                                            style: const TextStyle(
                                              color: AppColors.onSurface,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            comment['role'],
                                            style: const TextStyle(
                                              color: AppColors.secondary,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      comment['timeAgo'],
                                      style: const TextStyle(
                                        color: AppColors.secondary,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  comment['content'],
                                  style: const TextStyle(
                                    color: AppColors.onSurfaceVariant,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () {
                                    _commentController.text = '@${comment['author']} ';
                                  },
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.reply, color: AppColors.primaryContainer, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        'Responder',
                                        style: TextStyle(
                                          color: AppColors.primaryContainer,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
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
                    );
                  },
                ),
              ],
            ),
          ),

          // Fixed bottom interaction bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(
                  top: BorderSide(color: AppColors.outlineVariant, width: 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x0D000000),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: const Text(
                        'MK',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: _commentController,
                                decoration: const InputDecoration(
                                  hintText: 'Escreva sua contribuição...',
                                  hintStyle: TextStyle(color: AppColors.secondary, fontSize: 14),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  filled: false,
                                ),
                                style: const TextStyle(fontSize: 14),
                                textInputAction: TextInputAction.send,
                                onSubmitted: (_) => _addComment(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: _addComment,
                              icon: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryContainer,
                                ),
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
