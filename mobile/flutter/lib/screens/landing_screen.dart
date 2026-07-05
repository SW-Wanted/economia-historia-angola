import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/content_item.dart';
import '../models/feed.dart';
import '../models/landing_stats.dart';
import '../services/backend_service.dart';
import '../services/feed_service.dart';
import '../services/mock_data_service.dart';
import '../widgets/angola_map.dart';
import '../widgets/eh_button.dart';
import '../widgets/eh_card.dart';
import '../widgets/eh_illustration.dart';
import '../widgets/highlight_card.dart';
import '../widgets/preview_sheet.dart';
import '../widgets/section_title.dart';
import '../widgets/screen_frame.dart';
import '../widgets/stat_tile.dart';

/// Itens de pré-visualização por tipo de conteúdo, a partir do catálogo.
List<PreviewItem> previewItemsFor(String feature) {
  final fs = FeedService.instance;
  final type = switch (feature) {
    'Artigos' => FeedContentType.article,
    'Vídeos' => FeedContentType.video,
    'Podcasts' => FeedContentType.podcast,
    'Quizzes' => FeedContentType.quiz,
    'Fórum' => FeedContentType.forum,
    _ => null,
  };
  final src = type == null ? fs.catalog : fs.catalog.where((c) => c.type == type).toList();
  return [for (final c in src.take(5)) PreviewItem(c.title, c.subtitle)];
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool _visible = true;

  /// Contagens reais (membros, conteúdos, quizzes). `null` enquanto carrega ou
  /// quando o backend está indisponível — nesse caso mantêm-se os valores
  /// estáticos de apresentação.
  final Future<LandingStats?> _statsF = BackendService.instance.landingStats();

  /// Mostra/esconde o rodapé fixo (botões) conforme a direção do scroll, com o
  /// mesmo comportamento do menu inferior.
  bool _onScroll(UserScrollNotification n) {
    if (n.metrics.axis != Axis.vertical) return false;
    if (n.direction == ScrollDirection.reverse && _visible) {
      setState(() => _visible = false);
    } else if (n.direction == ScrollDirection.forward && !_visible) {
      setState(() => _visible = true);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    const data = MockDataService();
    final jindungo = data.jindungo();

    return Stack(children: [
      Positioned.fill(
        child: NotificationListener<UserScrollNotification>(
          onNotification: _onScroll,
          child: ScreenFrame(title: 'Economia com História', showNotifications: false, showLogo: true, paddingBottom: 110, children: [
      // ---------- Hero ----------
      _hero(context),
      const SizedBox(height: 30),

      // ---------- O que pode explorar ----------
      const _ExploreSection(),
      const SizedBox(height: 30),

      // ---------- Destaques ----------
      const SectionTitle('Leia agora, sem conta'),
      const SizedBox(height: 6),
      Text('Conteúdos em destaque para começar a explorar.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
      const SizedBox(height: 14),
      SizedBox(
        height: 184,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: data.highlights().length,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder: (context, i) {
            final h = data.highlights()[i];
            final scene = i.isEven ? EhScene.market : EhScene.rubber;
            return HighlightCard(
              tag: h.tag,
              title: h.title,
              scene: scene,
              onTap: () => showContentPreview(
                context,
                title: 'Leia agora',
                icon: Icons.menu_book_outlined,
                items: [for (final x in data.highlights()) PreviewItem(x.title, x.tag)],
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 18),

      // ---------- Teaser Jindungo ----------
      const SectionTitle('Textos com Jindungo'),
      const SizedBox(height: 6),
      Text('Análises críticas e picantes sobre a economia angolana — exclusivo para membros.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
      const SizedBox(height: 14),
      _JindungoTeaser(item: jindungo, onTap: () => Navigator.pushNamed(context, AppRoutes.restrictedContent)),
      const SizedBox(height: 30),

      // ---------- Explorar sem conta ----------
      const SectionTitle('Explore a comunidade'),
      const SizedBox(height: 14),
      EhCard(
        // A comunidade é reservada a membros: sem prévia. Só quem tiver conta
        // (após entrar) pode aceder.
        onTap: () => Navigator.pushNamed(context, AppRoutes.login),
        child: Row(children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: AppColors.navy.withValues(alpha: .1), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.groups_outlined, color: AppColors.navy),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Junte-se à comunidade', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
              Text('Entre para participar — exclusivo para membros.',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
            ]),
          ),
          const Icon(Icons.lock_outline, color: AppColors.outline, size: 18),
        ]),
      ),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _MapCard(onTap: () => Navigator.pushNamed(context, AppRoutes.map, arguments: true))),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickCard(
            icon: Icons.help_outline,
            title: 'Perguntas frequentes',
            subtitle: 'Tire as suas dúvidas.',
            onTap: () => Navigator.pushNamed(context, AppRoutes.faq),
          ),
        ),
      ]),
      const SizedBox(height: 30),

      // ---------- Sabia que? ----------
      EhCard(
        color: AppColors.surfaceLow,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.lightbulb_outline, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('Sabia que?', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary)),
          ]),
          const SizedBox(height: 10),
          Text(data.didYouKnow()),
        ]),
      ),
      const SizedBox(height: 24),

      // ---------- Valores (abaixo de "Sabia que?") ----------
      Row(children: const [
        Expanded(child: _Stat(icon: Icons.menu_book_outlined, label: 'Leitura livre')),
        SizedBox(width: 10),
        Expanded(child: _Stat(icon: Icons.public, label: '18 províncias')),
        SizedBox(width: 10),
        Expanded(child: _Stat(icon: Icons.school_outlined, label: 'Rigor académico')),
      ]),
      const SizedBox(height: 24),

      // ---------- A comunidade em números ----------
      const SectionTitle('A comunidade em números'),
      const SizedBox(height: 12),
      FutureBuilder<LandingStats?>(
        future: _statsF,
        builder: (context, snapshot) {
          final stats = snapshot.data;
          return Row(children: [
            Expanded(
              child: StatTile(
                icon: Icons.groups_outlined,
                value: _statValue(stats?.members, fallback: '1.284'),
                label: 'Membros',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatTile(
                icon: Icons.quiz_outlined,
                value: _statValue(stats?.quizzes, fallback: '312'),
                label: 'Quizzes',
                color: AppColors.navy,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatTile(
                icon: Icons.menu_book_outlined,
                value: _statValue(stats?.contents, fallback: '46'),
                label: 'Conteúdos',
                color: AppColors.success,
              ),
            ),
          ]);
        },
      ),
          ]),
        ),
      ),
      Positioned(left: 0, right: 0, bottom: 0, child: _footer(context)),
    ]);
  }

  /// Rodapé fixo com os botões de conta. Não acompanha o scroll: desliza para
  /// fora ao descer e reaparece ao subir, tal como o menu inferior.
  Widget _footer(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return IgnorePointer(
      ignoring: !_visible,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOutCubic,
        offset: _visible ? Offset.zero : const Offset(0, 1.4),
        child: Material(
          color: AppColors.surface,
          elevation: 8,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, (bottomInset > 0 ? bottomInset : 12) + 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                EhButton(label: 'Criar conta', icon: Icons.arrow_forward, onPressed: () => Navigator.pushNamed(context, AppRoutes.register1)),
                const SizedBox(height: 6),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                  style: TextButton.styleFrom(foregroundColor: AppColors.secondary),
                  child: const Text('Já tenho conta — Entrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Formata uma contagem real com separador de milhar (1284 -> "1.284").
  /// Quando não há dados do backend (`null`), devolve o valor de apresentação.
  String _statValue(int? value, {required String fallback}) {
    if (value == null) return fallback;
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  Widget _hero(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
              ),
            ),
          ),
          Positioned(right: -24, bottom: -28, child: Icon(Icons.history_edu, size: 168, color: Colors.white.withValues(alpha: .10))),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: const Text('PLATAFORMA EDUCATIVA',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                ),
                const SizedBox(height: 16),
                Text('A economia de Angola contada pela sua história',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white, height: 1.15)),
                const SizedBox(height: 10),
                Text('Artigos, debates e quizzes sobre as raízes económicas do país — do Kwanza ao Caminho de Ferro de Benguela.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: .88), height: 1.5)),
                const SizedBox(height: 22),
                EhButton(label: 'Começar agora', inverted: true, fullWidth: false, onPressed: () => Navigator.pushNamed(context, AppRoutes.register1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
        ]),
      );
}

class _JindungoTeaser extends StatelessWidget {
  const _JindungoTeaser({required this.item, required this.onTap});
  final ContentItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const gold = AppColors.warning;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: .28), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
              ),
            ),
            Positioned(right: -18, top: -16, child: Icon(Icons.local_fire_department, size: 130, color: gold.withValues(alpha: .12))),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.local_fire_department, color: gold, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(item.title,
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 16)),
                        ),
                        const Icon(Icons.lock_outline, color: Colors.white70, size: 18),
                      ]),
                      const SizedBox(height: 10),
                      Text(item.subtitle,
                          style: TextStyle(color: Colors.white.withValues(alpha: .88), fontStyle: FontStyle.italic, height: 1.4)),
                      const SizedBox(height: 8),
                      if (item.author.isNotEmpty)
                        Text('— ${item.author}',
                            style: const TextStyle(color: AppColors.tertiaryFixed, fontWeight: FontWeight.w700, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dados de uma funcionalidade apresentada na grelha "O que pode explorar".
class _FeatureData {
  const _FeatureData(this.icon, this.title, this.description, this.route, this.color);
  final IconData icon;
  final String title;
  final String description;
  final String route;
  final Color color;
}

/// Secção "O que pode explorar": grelha responsiva de funcionalidades, com
/// entrada animada (fade-in + slide-up).
class _ExploreSection extends StatelessWidget {
  const _ExploreSection();

  // A `route` aponta para o ecrã aberto ao tocar num item desbloqueado da
  // prévia (em modo prévia — parcial/limitado).
  static const _features = [
    _FeatureData(Icons.menu_book_outlined, 'Artigos', 'Explore artigos sobre História da Economia.', AppRoutes.reading, AppColors.primary),
    _FeatureData(Icons.play_circle_outline, 'Vídeos', 'Aprenda vendo especialistas.', AppRoutes.videoPlayer, AppColors.navy),
    _FeatureData(Icons.headphones_outlined, 'Podcasts', 'Aprenda ouvindo especialistas.', AppRoutes.podcastPlayer, AppColors.navy),
    _FeatureData(Icons.forum_outlined, 'Fórum', 'Participe em debates com a comunidade.', AppRoutes.forumTopic, AppColors.success),
  ];

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t.clamp(0, 1),
        child: Transform.translate(offset: Offset(0, (1 - t) * 18), child: child),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('O que pode explorar'),
          const SizedBox(height: 6),
          Text(
            'Descubra conteúdos educativos, participe na comunidade e explore diferentes formas de aprender História da Economia.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary, height: 1.45),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, box) {
              final columns = box.maxWidth >= 640 ? 4 : (box.maxWidth >= 340 ? 2 : 1);
              return GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 120,
                ),
                children: [for (final f in _features) _FeatureCard(data: f)],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Card de funcionalidade com hover (Web), ripple e escala ao clicar.
class _FeatureCard extends StatefulWidget {
  const _FeatureCard({required this.data});
  final _FeatureData data;

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hover ? -6 : 0, 0),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _hover ? d.color.withValues(alpha: .4) : AppColors.outlineVariant.withValues(alpha: .4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _hover ? .12 : .04),
                blurRadius: _hover ? 18 : 10,
                offset: Offset(0, _hover ? 10 : 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => showContentPreview(context, title: d.title, icon: d.icon, items: previewItemsFor(d.title), previewRoute: d.route),
              onHighlightChanged: (v) => setState(() => _pressed = v),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(color: d.color.withValues(alpha: .12), borderRadius: BorderRadius.circular(12)),
                          child: Icon(d.icon, color: d.color, size: 22),
                        ),
                        const Spacer(),
                        AnimatedSlide(
                          offset: _hover ? const Offset(.25, 0) : Offset.zero,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          child: Icon(Icons.arrow_forward, size: 18, color: _hover ? d.color : AppColors.outline),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
                        Text(d.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  const _QuickCard({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => EhCard(
        onTap: onTap,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 10),
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
          Text(subtitle, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
        ]),
      );
}

/// Cartão do mapa interativo, com o símbolo do mapa de Angola.
class _MapCard extends StatelessWidget {
  const _MapCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => EhCard(
        onTap: onTap,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(width: 26, height: 26, child: AngolaMap(fill: AppColors.primary)),
          const SizedBox(height: 10),
          Text('Mapa interativo', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
          Text('Explore as 18 províncias.', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
        ]),
      );
}
