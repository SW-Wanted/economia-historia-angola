import 'package:flutter/material.dart';

/// Cartao "Continuar onde parou" do dashboard.
class ContinueReading {
  const ContinueReading({
    required this.title,
    required this.subtitle,
    required this.progress,
  });

  final String title;
  final String subtitle;

  /// Progresso de leitura entre 0 e 1.
  final double progress;

  int get percent => (progress * 100).round();
}

/// Quiz em destaque da semana.
class WeeklyQuiz {
  const WeeklyQuiz({required this.title, required this.description});

  final String title;
  final String description;
}

/// Conteudo em destaque na lista horizontal do dashboard.
class DashboardHighlight {
  const DashboardHighlight({required this.tag, required this.title, required this.icon});

  final String tag;
  final String title;
  final IconData icon;
}

/// Texto Jindungo em destaque no dashboard.
class FeaturedJindungo {
  const FeaturedJindungo({required this.quote, required this.source});

  final String quote;
  final String source;
}
