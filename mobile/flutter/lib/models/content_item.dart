import 'package:flutter/material.dart';

class ContentItem {
  const ContentItem({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.minutes,
    required this.icon,
    this.locked = false,
    this.featured = false,
    this.body = const [],
    this.author = 'Prof. Carlos Lopes',
    this.province,
  });

  final String title;
  final String subtitle;
  final String category;
  final int minutes;
  final IconData icon;
  final bool locked;
  final bool featured;

  /// Parágrafos do corpo do texto (usado no ecrã de leitura).
  final List<String> body;
  final String author;
  final String? province;

  bool get isJindungo => category.toLowerCase().contains('jindungo');
}
