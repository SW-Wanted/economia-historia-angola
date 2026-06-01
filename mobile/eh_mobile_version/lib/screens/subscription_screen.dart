import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isSubscribed = false;

  void _toggleSubscription() {
    setState(() {
      _isSubscribed = !_isSubscribed;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isSubscribed
              ? 'Parabéns! Agora é um Subscritor Jindungo Premium.'
              : 'Subscrição cancelada com sucesso.',
        ),
        backgroundColor: _isSubscribed ? Colors.green : AppColors.primary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F0),
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Minha Subscrição',
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
                border: Border.all(color: AppColors.outlineVariant),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBYv3RR0cNT3LFRgLTHUb3K9K4bCD-enCpnoU3Sg8hUii0hsl7-tW_yb7IJY_U2OC1YHS1xjBiAWWG0sBhJUSMPzF2JRE_UZpF2Dp3US0UCnFF7LaDjVaHtHEdJRoiN6BRd9CVGDjak4cwveRxdLwmfy8RrIQ1Se2n8PSk3XNT6QSMZ1UNLpMTwf0n9X6_XQPNN4S_cny1vao_8ApiDt_tnJlVsa_X-ZjMwqHcJMVFgDtJaOB-sDvxmnS1CqvkDmwbo-AQvWygdTk8',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
                  boxShadow: const [
                    BoxShadow(
                      color: const Color(0x0D000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'ESTADO ACTUAL',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isSubscribed ? 'Subscritor Jindungo' : 'Utilizador Livre',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _isSubscribed
                          ? 'Acesso total e prioritário a todas as funcionalidades.'
                          : 'O seu acesso é limitado aos conteúdos públicos.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Active Benefits
              const Text(
                'Vantagens Actuais',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              _buildBenefitRow('Acesso a notícias de economia geral'),
              const SizedBox(height: 8),
              _buildBenefitRow('Participação no fórum público'),
              if (_isSubscribed) ...[
                const SizedBox(height: 8),
                _buildBenefitRow('Acesso a insights e documentos históricos exclusivos'),
                const SizedBox(height: 8),
                _buildBenefitRow('Destaque do perfil no fórum e ranking global'),
              ],
              const SizedBox(height: 24),

              // Subscription Bento Section
              if (!_isSubscribed) ...[
                const Text(
                  'Porquê ser Subscritor?',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Jindungo Card (Special Heritage Style)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
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
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.bolt, color: Colors.amber, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'Insights Jindungo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Análises picantes e profundas sobre a história económica de Angola que você não encontra em nenhum outro lugar.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: -10,
                        bottom: -10,
                        child: Opacity(
                          opacity: 0.1,
                          child: Transform.scale(
                            scale: 1.3,
                            child: const Icon(
                              Icons.history_edu,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Bento Row
                Row(
                  children: [
                    Expanded(
                      child: _buildBentoCard(
                        Icons.all_inclusive,
                        'Acesso Total',
                        'Documentos históricos e relatórios exclusivos.',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildBentoCard(
                        Icons.leaderboard,
                        'Ranking',
                        'Destaque o seu perfil no fórum e ranking global.',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              // CTA Action
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isSubscribed ? Colors.transparent : AppColors.primaryContainer,
                        foregroundColor: _isSubscribed ? AppColors.primary : Colors.white,
                        shadowColor: _isSubscribed ? Colors.transparent : Colors.black26,
                        elevation: _isSubscribed ? 0 : 4,
                        side: _isSubscribed ? const BorderSide(color: AppColors.primary, width: 2) : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _toggleSubscription,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isSubscribed ? 'Cancelar Subscrição' : 'Tornar-me Subscritor',
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (!_isSubscribed) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ao subscrever, concorda com os nossos Termos de Serviço e Política de Privacidade. Cancele a qualquer momento.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitRow(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoCard(IconData icon, String title, String subtitle) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.tertiary, size: 30),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.tertiary,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
