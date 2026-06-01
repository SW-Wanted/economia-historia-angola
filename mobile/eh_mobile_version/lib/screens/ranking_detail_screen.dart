import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class RankingDetailScreen extends StatefulWidget {
  const RankingDetailScreen({super.key});

  @override
  State<RankingDetailScreen> createState() => _RankingDetailScreenState();
}

class _RankingDetailScreenState extends State<RankingDetailScreen> {
  bool _isFollowing = false;

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFollowing
              ? 'Agora está a seguir este investigador.'
              : 'Deixou de seguir este investigador.',
        ),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Perfil do Investigador',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header Section
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 128,
                          height: 128,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.surfaceContainerHighest, width: 4),
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuC8yDVz4Um2jFwIMvHZq4NFl-fpEYck8WVG3n1DwWOExjF0tIF8AzDQFwZey6d0f0iFio_GkRzMoO_q9HQqzdq5qv47_peA2L_sq4j2coqc-hxlXfYjvEAkWO7tUM84ShwF38Cbbk-iSndHXwiFVRS0JQ6FMZmiKva6jveNgY2-Q9yPzyosATz1AtMwTjF1n7XVdlcSwd5eHV-MTCnfuqSVe-8bp9rxSIhbgygiPVwMF5X_R1mAO6d_43X8D05PfuhS6s5E0AxIJdc',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Dr. Manuel Silva',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'INVESTIGADOR SÉNIOR',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _toggleFollow,
                        child: Text(
                          _isFollowing ? 'A seguir' : 'Enviar mensagem',
                          style: const TextStyle(
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Stats Bento Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildStatCell(Icons.stars, '1.850', 'Total de Pontos'),
                  _buildStatCell(Icons.quiz, '12', 'Quizzes Vencidos'),
                  _buildStatCell(Icons.forum, '8', 'Tópicos Criados'),
                  _buildStatCell(Icons.military_tech, '3', 'Medalhas'),
                ],
              ),
              const SizedBox(height: 24),

              // Medals Section
              const Text(
                'Conquistas de Prestígio',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 96,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildMedalCell(
                      Icons.rocket_launch,
                      'Pioneiro',
                      AppColors.primaryContainer,
                      AppColors.primaryFixed,
                    ),
                    const SizedBox(width: 16),
                    _buildMedalCell(
                      Icons.payments,
                      'Mestre da Moeda',
                      AppColors.tertiary,
                      AppColors.tertiaryFixed,
                    ),
                    const SizedBox(width: 16),
                    _buildMedalCell(
                      Icons.history_edu,
                      'Historiador Ativo',
                      AppColors.primaryContainer,
                      AppColors.primaryFixed,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Jindungo Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text('⚡', style: TextStyle(color: Colors.white, fontSize: 16)),
                        SizedBox(width: 6),
                        Text(
                          'INSIGHT ACADÉMICO',
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
                    const Text(
                      '"A economia angolana de 1970 não pode ser compreendida sem olharmos para os ciclos de exportação do café no Uíge."',
                      style: TextStyle(
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Contributions List
              const Text(
                'Últimas contribuições',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildContributionRow('Análise da inflação pós-Independência', 'Há 2 horas'),
                  const SizedBox(height: 12),
                  _buildContributionRow('O papel da agricultura no PIB histórico', 'Ontem'),
                  const SizedBox(height: 12),
                  _buildContributionRow('Evolução do Kwanza vs Moedas Regionais', '3 dias atrás'),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCell(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: AppColors.tertiary, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedalCell(IconData icon, String title, Color bg, Color border) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bg,
            border: Border.all(color: border, width: 2),
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildContributionRow(String title, String timeAgo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(color: AppColors.primary, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.schedule, color: AppColors.secondary, size: 14),
              const SizedBox(width: 4),
              Text(
                timeAgo,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
