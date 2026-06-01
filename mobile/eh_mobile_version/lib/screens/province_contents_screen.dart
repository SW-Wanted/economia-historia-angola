import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';

class ProvinceContentsScreen extends StatefulWidget {
  const ProvinceContentsScreen({super.key});

  @override
  State<ProvinceContentsScreen> createState() => _ProvinceContentsScreenState();
}

class _ProvinceContentsScreenState extends State<ProvinceContentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeChip = 'Tudo';

  // Mock content items specific to provinces
  final Map<String, List<Map<String, dynamic>>> _provinceData = {
    'Luanda': [
      {
        'id': '1',
        'isSpecial': true,
        'category': 'História Económica',
        'title': 'O Porto de Luanda e as Rotas do Atlântico',
        'description': 'Uma análise profunda sobre o papel estratégico da Baía de Luanda no comércio transatlântico desde o século XVI.',
        'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBMkvEBOnSlJRbSL90XpGdw7mnxpG5dtCFOlTlGUynI-Kum87M6RGb4Qc7ziHiE_IVJikfv702Tx7tUC-yLA_ChWtPadz3DhH-Gx2nQYrN-08PXU35JznNPQeNgccFrAynQUvBMXqHeZMXPC3hayQVec92bO4lFjly3yNcoOFcjLAysPLIrUWesFYTBF1c9TdM49u0yI3hwhBgNilUFy7F4ZMiNc_pu4js9N-S948t_Z3aley_IyNyJiWSJ0xRYj_lVrBJs1tKlsVo',
        'tag': 'Porto',
      },
      {
        'id': '2',
        'isSpecial': false,
        'category': 'Património',
        'title': 'A Sede do BNA: Arquitetura e Poder',
        'description': 'Como a infraestrutura financeira moldou o centro histórico da capital angolana durante o século XX.',
        'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuA050c2y7YXAqaqf2ypVmn4LsFhy-RtgS_Eow_RyDv0PEoNLQv_jhwkA3WgTtaE8jVdOjlaNGBytx3gNteyXyEbUu_RwpbDNZBa9ViJS_w_0Xk6yAtel24yyEB-k-TUBTaFC2HIpU1oYOuTohZol5FOq3WySpu1FQcXjLnfYdktbrx2YCv89grHxkhuLgyGSIEoJwhgMeOsoo0CdVEdVZNcuYd1fY943crI7dCRpSlLmsnsULBjY9aQyMNY-z4P7AxkS05Q7lAygbg',
        'tag': 'Arquitectura',
      },
      {
        'id': '3',
        'isSpecial': true,
        'category': 'Mercados Históricos',
        'title': 'Quitanda: O Coração Pulsante da Capital',
        'description': 'A evolução dos mercados informais e sua contribuição para a microeconomia urbana de Luanda.',
        'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuD0dKPBTQrbxP3Bv52PNGhn03EC7Zqq9cyLZKopTXEsGIpegaK10DKjWfSPcR6vYQBEXRrzWYCS85FC5f-QuEdsmBhwHn33YTJCpSC0aQTWL9o13Vxuu5fveGGpecE89KArphFdk-MvjffOmYwwEQcO5gra-95ZKU_XcIlbv0_A0YvUbWkj5AAjTACV0qvNsZKDQcL5lFdJ1ioMPso-80xkGOggUdsNfQRZJH40AIQSpHFxzL-lcRpFvb5mr79YjOp6FSGhp6WVkAY',
        'tag': 'Comércio',
      }
    ],
    'Benguela': [
      {
        'id': '4',
        'isSpecial': true,
        'category': 'Caminho de Ferro',
        'title': 'Caminho de Ferro de Benguela (CFB)',
        'description': 'A história da linha férrea que ligou o porto do Lobito ao interior mineiro, revolucionando a economia do país no século XX.',
        'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBMkvEBOnSlJRbSL90XpGdw7mnxpG5dtCFOlTlGUynI-Kum87M6RGb4Qc7ziHiE_IVJikfv702Tx7tUC-yLA_ChWtPadz3DhH-Gx2nQYrN-08PXU35JznNPQeNgccFrAynQUvBMXqHeZMXPC3hayQVec92bO4lFjly3yNcoOFcjLAysPLIrUWesFYTBF1c9TdM49u0yI3hwhBgNilUFy7F4ZMiNc_pu4js9N-S948t_Z3aley_IyNyJiWSJ0xRYj_lVrBJs1tKlsVo', // fallback
        'tag': 'Porto',
      },
      {
        'id': '5',
        'isSpecial': false,
        'category': 'Comércio',
        'title': 'As Salinas de Benguela e o Comércio Regional',
        'description': 'A relevância económica da produção de sal na orla costeira e a sua distribuição para as províncias do planalto central.',
        'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuA050c2y7YXAqaqf2ypVmn4LsFhy-RtgS_Eow_RyDv0PEoNLQv_jhwkA3WgTtaE8jVdOjlaNGBytx3gNteyXyEbUu_RwpbDNZBa9ViJS_w_0Xk6yAtel24yyEB-k-TUBTaFC2HIpU1oYOuTohZol5FOq3WySpu1FQcXjLnfYdktbrx2YCv89grHxkhuLgyGSIEoJwhgMeOsoo0CdVEdVZNcuYd1fY943crI7dCRpSlLmsnsULBjY9aQyMNY-z4P7AxkS05Q7lAygbg',
        'tag': 'Comércio',
      }
    ]
  };

  // Default fallback data for other provinces
  List<Map<String, dynamic>> _getProvinceContents(String province) {
    return _provinceData[province] ?? _provinceData['Luanda']!;
  }

  String _getProvinceSubtitle(String province) {
    return switch (province) {
      'Luanda' => 'História e Economia na capital',
      'Benguela' => 'As ferrovias, o sal e o comércio costeiro',
      'Cabinda' => 'A riqueza transfronteiriça e o petróleo',
      'Huambo' => 'O celeiro agrícola e a história do planalto',
      _ => 'História e Economia desta província angolana',
    };
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve province name from route arguments
    final provinceName = ModalRoute.of(context)?.settings.arguments as String? ?? 'Luanda';
    final contents = _getProvinceContents(provinceName);
    final subtitle = _getProvinceSubtitle(provinceName);

    // Apply search and category filters
    final filteredContents = contents.where((item) {
      final matchesSearch = item['title']!.toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item['description']!.toString().toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesChip = _activeChip == 'Tudo' || item['tag'] == _activeChip;
      return matchesSearch && matchesChip;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '$provinceName: Conteúdos',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.primary),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Explorar Região',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBackground,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar
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
                  decoration: InputDecoration(
                    hintText: 'Pesquisar em $provinceName...',
                    hintStyle: const TextStyle(color: AppColors.secondary, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: AppColors.secondary),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Filter Chips
              Row(
                children: [
                  _buildFilterChip('Tudo'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Arquitectura'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Porto'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Comércio'),
                ],
              ),
              const SizedBox(height: 20),

              // Content Cards List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredContents.length + 1, // +1 for the Jindungo card
                itemBuilder: (context, index) {
                  // Put the Jindungo Insight Card at the end or intermediate
                  final targetJindungoIndex = filteredContents.length;

                  if (index == targetJindungoIndex) {
                    return _buildJindungoInsightCard(provinceName);
                  }

                  final item = filteredContents[index];
                  return _buildContentCard(item);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isActive = _activeChip == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeChip = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.tertiary : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: isActive
              ? null
              : Border.all(color: AppColors.outlineVariant, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.secondary,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildContentCard(Map<String, dynamic> item) {
    final isSpecial = item['isSpecial'] as bool? ?? false;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.reading, arguments: item);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: const Color(0x0D000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    item['imageUrl'].toString(),
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  if (isSpecial)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Especial',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['category'].toString().toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJindungoInsightCard(String province) {
    final text = switch (province) {
      'Luanda' => '"Luanda não é apenas o centro administrativo; é o laboratório onde o passado colonial e o futuro petrolífero de Angola se encontram diariamente."',
      'Benguela' => '"Benguela e Lobito formam uma porta histórica de ligação comercial com o centro da África Austral, através da rota dos carris."',
      _ => '"Cada província de Angola guarda um pedaço da nossa história económica que nos ajuda a compreender o presente e construir o futuro."',
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.bolt, color: Colors.white, size: 18),
              SizedBox(width: 6),
              Text(
                'INSIGHT JINDUNGO',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontStyle: FontStyle.italic,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
