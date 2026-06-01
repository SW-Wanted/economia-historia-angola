import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class ManageForumsScreen extends StatefulWidget {
  const ManageForumsScreen({super.key});

  @override
  State<ManageForumsScreen> createState() => _ManageForumsScreenState();
}

class _ManageForumsScreenState extends State<ManageForumsScreen> {
  int _activeTab = 0; // 0: Denunciados, 1: Pendentes, 2: Ativos
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock list of reported topics for administration
  final List<Map<String, dynamic>> _reportedTopics = [
    {
      'id': '1',
      'title': 'Crise cambial e o impacto no comércio local',
      'author': '@antonio_silva',
      'timeAgo': 'há 2 horas',
      'tag': 'Urgente',
      'reason': 'Conteúdo Inadequado: O utilizador está a promover links externos suspeitos e a usar linguagem agressiva.',
      'type': 'reported',
    },
    {
      'id': '2',
      'title': 'O Comércio no tempo do Reino do Ndongo',
      'author': '@ndongo_historico',
      'timeAgo': 'há 3 horas',
      'tag': 'Alerta de Património Histórico',
      'reason': 'Spam repetitivo nos comentários de propaganda política.',
      'type': 'heritage_alert',
    },
    {
      'id': '3',
      'title': 'História da Moeda em Angola',
      'author': '@historiador_ang',
      'timeAgo': 'há 5 horas',
      'tag': 'Aguardando Revisão',
      'reason': 'Possível desinformação sobre datas históricas do início da circulação do Kwanza.',
      'type': 'reported',
    }
  ];

  // Mock list of pending topics
  final List<Map<String, dynamic>> _pendingTopics = [
    {
      'id': '4',
      'title': 'Evolução da Economia de Subsistência na Lunda Sul',
      'author': '@lunda_eco',
      'timeAgo': 'há 1 dia',
      'tag': 'Pendente',
      'reason': 'Aguardando aprovação de administrador por conter imagens de arquivo.',
      'type': 'reported',
    }
  ];

  // Mock list of active topics
  final List<Map<String, dynamic>> _activeTopics = [
    {
      'id': '5',
      'title': 'Impacto do Café na Economia Colonial de Angola',
      'author': '@cafe_angola',
      'timeAgo': 'há 4 horas',
      'tag': 'Ativo',
      'reason': 'Nenhuma denúncia. Tópico saudável.',
      'type': 'reported',
    }
  ];

  List<Map<String, dynamic>> _getFilteredList() {
    List<Map<String, dynamic>> currentList = switch (_activeTab) {
      0 => _reportedTopics,
      1 => _pendingTopics,
      2 => _activeTopics,
      _ => _reportedTopics,
    };

    if (_searchQuery.isEmpty) return currentList;

    return currentList
        .where((topic) =>
            topic['title']!.toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
            topic['author']!.toString().toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _removeTopic(String id) {
    setState(() {
      _reportedTopics.removeWhere((t) => t['id'] == id);
      _pendingTopics.removeWhere((t) => t['id'] == id);
      _activeTopics.removeWhere((t) => t['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tópico removido com sucesso.'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _keepTopic(String id) {
    setState(() {
      // Find the topic
      var topicList = [..._reportedTopics, ..._pendingTopics];
      var topicIndex = topicList.indexWhere((t) => t['id'] == id);
      if (topicIndex != -1) {
        var topic = topicList[topicIndex];
        // Remove from reported/pending
        _reportedTopics.removeWhere((t) => t['id'] == id);
        _pendingTopics.removeWhere((t) => t['id'] == id);
        // Add to active
        topic['tag'] = 'Ativo';
        _activeTopics.add(topic);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tópico mantido e marcado como ativo.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _warnAuthor(String author) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Aviso formal enviado para o utilizador $author.'),
        backgroundColor: AppColors.tertiary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTopics = _getFilteredList();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F0),
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        elevation: 1,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Gerir Fóruns',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.outlineVariant, width: 1.5),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDUDUN_8-VWJvnR6na0YKou6L2EcsrFhZwGXo9q6bPqhUYxjk1UNNjQXcS2lKSpfA-IDGomKOzUM4iRP67WU_-pC4CzEJhXWwD9maVWrpVo-sik9FOve9pgq7yBegfnlVbA2MEhaL-FdRBN53vXXEnR30bvojI7EEJaWy41_-DGxx8KqlcOtn5LpKdTJqY0y0zW-C5M5q9kO-WAfZyYYBpLSjmPrO_DoQ6EJa0LmJC_vZfbudZ-cgS5LfKMBcgSrQgiwFXsbhVieDU',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Statistics Container
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Input
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: const Color(0x0D000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Pesquisar tópicos...',
                      hintStyle: TextStyle(color: AppColors.secondary, fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: AppColors.secondary),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Statistics Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard('Tópicos totais', '1.284'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard('Comentários hoje', '42'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard('Denúncias resolvidas', '98%'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tabs Navigation
          Container(
            color: AppColors.surfaceContainerLowest,
            child: Row(
              children: [
                _buildTabButton(0, 'Denunciados (${_reportedTopics.length})'),
                _buildTabButton(1, 'Pendentes (${_pendingTopics.length})'),
                _buildTabButton(2, 'Ativos (${_activeTopics.length})'),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // List of Topics
          Expanded(
            child: filteredTopics.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 48, color: AppColors.secondary.withOpacity(0.5)),
                        const SizedBox(height: 12),
                        const Text(
                          'Nenhum tópico encontrado.',
                          style: TextStyle(color: AppColors.secondary, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredTopics.length,
                    itemBuilder: (context, index) {
                      final topic = filteredTopics[index];
                      return _buildTopicCard(topic);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceContainer, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: const Color(0x05000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String title) {
    final isActive = _activeTab == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _activeTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.primary : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? AppColors.primary : AppColors.secondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopicCard(Map<String, dynamic> topic) {
    final isHeritage = topic['type'] == 'heritage_alert';

    if (isHeritage) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(16),
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
              children: [
                const Icon(Icons.bolt, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  topic['tag'].toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              topic['title'].toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Denúncia: ${topic['reason']}',
                style: const TextStyle(
                  color: const Color(0xE6FFFFFF),
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Visualizando comentários...')),
                      );
                    },
                    child: const Text('Ver Comentários', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cache do tópico limpo.')),
                      );
                    },
                    child: const Text('Limpar Cache', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: _activeTab == 0 ? AppColors.primary : AppColors.secondary,
            width: 4,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: const Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    topic['title'].toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (_activeTab == 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      topic['tag'].toString().toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Text(
                    topic['tag'].toString(),
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppColors.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, size: 14, color: AppColors.secondary),
                ),
                const SizedBox(width: 8),
                Text(
                  'Autor: ${topic['author']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 6),
                const Text('•', style: TextStyle(color: AppColors.outlineVariant, fontSize: 10)),
                const SizedBox(width: 6),
                Text(
                  topic['timeAgo'].toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MOTIVO DA DENÚNCIA',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '"${topic['reason']}"',
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () => _removeTopic(topic['id'].toString()),
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('Remover', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () => _keepTopic(topic['id'].toString()),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Manter', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.outline),
                      foregroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () => _warnAuthor(topic['author'].toString()),
                    icon: const Icon(Icons.warning, size: 16),
                    label: const Text('Avisar', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
