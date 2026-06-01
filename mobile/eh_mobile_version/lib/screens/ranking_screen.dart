import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: const Color(0x0D000000),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Economia com História', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.secondary),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: const NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuC0Fu5x4b5ADQTGnjo9b44F6nlfB0dIExSz0_8RqNhm3ibD12NjlhkO9vzMINFuqAd3C6Gyk88BOYbFqgoHDROgUyysate9PlYIzsB5s6vL6TGgsJb4qWe4axlqFyUOqruKV31PaCIOVMy0ebAwsaI_1qURrGi58nULr908rvxbpFsvxV0OU6a_tPW2iz9GkeZkJGgpvjcA_vzvVd0xVkwrMi7ijxaxUDELLumj6JhvhL8HMmjxaifqAOcLEPZFv6T99ODMN0E8WZk'),
              backgroundColor: AppColors.surfaceContainerHighest,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // Ranking Header Section
            Text('Ranking de Pesquisadores', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Os maiores contribuidores da história económica angolana.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
            const SizedBox(height: 32),

            // Visual Podium
            Container(
              height: 220,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primary.withValues(alpha: 0.05), AppColors.primary.withValues(alpha: 0.0)],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 2nd Place
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildPodiumAvatar(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuASxg8W2olOkPIgjT8EEMeAN0tWKDCWhSo200hvuxxG356roxQlIEYdzigXz3F87sZlB9n9sluNHh3CpBqafW1yfbapw6zd9yOoAtL4IS9hJB4ECYP8JFpc92uWj_LV7oz92sdYKRLv9gtVvVxUa9zDujQmpwa4QoWpEPeG-Ok0lB4NTHbS1kGBL5WKSwfZog4bGVijclbTDpPuVFuLxOI1xxJg3RRqEuQc7T9SWVyRxuoX65wBJuBjBMmYHbt14Ww-D83dduS45SY',
                          '2º',
                          AppColors.secondaryFixed,
                          AppColors.onSecondaryFixed,
                          28,
                        ),
                        const SizedBox(height: 4),
                        Text('Ana Paula', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('1,240 pts', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(height: 64, decoration: BoxDecoration(color: AppColors.secondaryFixed.withValues(alpha: 0.3), borderRadius: const BorderRadius.vertical(top: Radius.circular(8)))),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 1st Place
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildPodiumAvatar(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAC_f403yAZzwo0wPbwVa5mhc-kOA0oK1r8f82qDmew37X2Tp6MG4Rs07jVoRoNPDX3vEIflDdma1b6XxMrK0IOAm56bXaMQXQWO7SAQBfIlldrLpUi3c7Pc_Hg3z1Fz8Fbmbw8zV6fN2PoxrZfJSuMz22KRKPmI8gdLl1nRaFRqiQLwHbqdc_WQrjCI2OiEc5tZiqOzF15GC7hyb1-qJrCRx-tT1v719KbvJzrkVMCCVkO9SZxGwE8-w5W7sDwLDtOhCwcChM3Ql8',
                          '1º',
                          AppColors.primary,
                          AppColors.onPrimary,
                          40,
                          icon: Icons.workspace_premium,
                        ),
                        const SizedBox(height: 4),
                        Text('Dr. Manuel', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('1,850 pts', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(
                          height: 96,
                          width: double.infinity,
                          decoration: const BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
                          child: const Icon(Icons.star, color: Colors.white54, size: 24),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 3rd Place
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildPodiumAvatar(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBXRlFHL2GXh7Ft5JpdvfDOXQNHSy1Dkp7F18aK8sDIBTve8ZDYJXCPNPdEDZDOvvXuy87qATzkJ0ckT1DNVdsll_ffgSGknp6Y4KZw5UkjoLyKuXFY-nmE4J7phQCnuBpL_r0nGb-G9EGMKukSxeP_M5U8dw-9K-qhrU0rouudjSrQJ_6fiBFEEzqWgLeshXXpTRbhQcXR1pFfbbKH3Y56pn1kmt8ufVGFyYaoZTm7tD9OyT93cqxCEnvYjdSOPqq3IUvuo019nOs',
                          '3º',
                          AppColors.tertiary,
                          AppColors.onTertiary,
                          28,
                        ),
                        const SizedBox(height: 4),
                        Text('Isabel C.', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('980 pts', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(height: 48, decoration: BoxDecoration(color: AppColors.tertiaryFixedDim.withValues(alpha: 0.3), borderRadius: const BorderRadius.vertical(top: Radius.circular(8)))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // User Rank (Highlighted)
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.rankingDetail),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary, width: 2),
                  boxShadow: [BoxShadow(color: const Color(0x0D000000), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    SizedBox(width: 32, child: Text('12', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                    const SizedBox(width: 16),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: const NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBiGVV91AMs9JVQatwfRuCipHPsuc-8VzZaxeYNgkkDEFjaq9BqlvYLirpAIYky_i9OXgO7sKJJoR8yK7sbrJTdxRP12-radv3ZL9DwH2aZI8mYpWQXfnzJs7iI6Rijate3hvEr2EZC7BaDqzpgJRu_TYcfTQ7h5xJdWwvX78Qv-L_IF-1mxVD-gmiu0lVsDP7XCI9MgVECtN8hvSDshzoVf1R-AvpRWJQL05G5Fnl8K45q5R5UEwjKN8kpBORaYLc-ZWp2ijwbx7Q'),
                      backgroundColor: AppColors.surfaceContainerHighest,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tu (João Silva)', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold)),
                          Text('HISTORIADOR NÍVEL 3', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.secondary, fontSize: 10, letterSpacing: 1.0)),
                        ],
                      ),
                    ),
                    Text('450 pts', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // List Divider
            Row(
              children: [
                Expanded(child: Container(height: 1, color: AppColors.outlineVariant)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text('GERAL', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.secondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                ),
                Expanded(child: Container(height: 1, color: AppColors.outlineVariant)),
              ],
            ),
            const SizedBox(height: 16),

            // Other Rank Items
            _buildRankItem(context, '4', 'Ricardo Gomes', 'CONSULTOR', '820 pts', 'https://lh3.googleusercontent.com/aida-public/AB6AXuB10A0nAUYWOWoS_78mXf2OsGfTwMMj5qQuk8ub2Et2MjOm86F_nWFWHKWgKPakRIp5vIfR3BTr2091wRLsCBnauG9r4KFutBXk2rhzZ7eCkHFfwzwlwlznRzyYPL5hiSWV1sLhJx-VhmJb4BzQRDGHkhuN-BcIatibsKkCibKQzkDFfhLqwKb2PFqnCvFYhTkbTqa39XFgL9xojal6ynC2J8szAT4Z8LaMvmP28tc5lNhkJj5PoHES9mOarWzdImrMjS-gIK4oKN0'),
            const SizedBox(height: 12),
            _buildRankItem(context, '5', 'Maria Antónia', 'INVESTIGADORA', '715 pts', 'https://lh3.googleusercontent.com/aida-public/AB6AXuAdl6j5pEBiZeoJdt04VsXHNtDQnoXb3m2Tuvk_5wFl6MXI5Q3HqPFxOPkI1xMr3mOxHs-nym2CEIKL4G7dCj11KEC0mnUUpvSA3W66LwMxIr28N9-X3FwmejEcpDMXjNuosTJPelUeI5D4irHdZWuo42xjq5po5LhUYaDGJsSAhxs3s2C7Le2fhX0kFiezd6A_RBSGS69mExzMdWWGL_HeC8ATVgUmiGwGb-eKH0x0SHlou_EqEALiVxLTLjYSOyGpEqM7joUVEQU'),
            const SizedBox(height: 12),
            _buildRankItem(context, '6', 'Elena Costa', 'ESTUDANTE', '690 pts', 'https://lh3.googleusercontent.com/aida-public/AB6AXuBDCYeHfm6s1m7shvSiRIEcQm0oOO9DCJazTMg6kDiOffnv68ObYCEceKv_sf5nSD8lY62OeA2KiV4AInFXbB3Jg4yAkUdVH4LbFwP4Gq3YLlUwDTHAdSWrJZtRfW9efWlxjwnYm3766J18Z0-svfEF_IVGnxKNKRJNMfsahCmVujAviN_bimTZpwjnjjfMxTTzj8fjSmDhVthNWMtfSa18QR7mtPNUwqM_GysoGCBh6IeWnH1w6zc9i-LqsG8-4FRAGfdGk2kpRQ4'),
            const SizedBox(height: 32),

            // Jindungo Insight Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Icon(Icons.history_edu, size: 100, color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.electric_bolt, color: AppColors.surfaceContainerHighest, size: 20),
                          const SizedBox(width: 8),
                          Text('Herança Angolana', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Os rankings refletem não apenas o conhecimento, mas a dedicação em preservar a memória económica do nosso povo.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, height: 1.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPodiumAvatar(String imageUrl, String rankText, Color color, Color onColor, double radius, {IconData? icon}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: color, width: 2)),
          child: CircleAvatar(radius: radius, backgroundImage: NetworkImage(imageUrl), backgroundColor: AppColors.surfaceContainerHighest),
        ),
        Positioned(
          top: -8,
          right: -4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white, width: 1)),
            child: icon != null
                ? Icon(icon, color: onColor, size: 12)
                : Text(rankText, style: TextStyle(color: onColor, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildRankItem(BuildContext context, String rank, String name, String role, String score, String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          SizedBox(width: 32, child: Text(rank, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: AppColors.surfaceContainerHighest,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold)),
                Text(role, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.secondary, fontSize: 10, letterSpacing: 1.0)),
              ],
            ),
          ),
          Text(score, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
