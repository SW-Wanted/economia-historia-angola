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
  });

  final String title;
  final String subtitle;
  final String category;
  final int minutes;
  final IconData icon;
  final bool locked;
  final bool featured;
}
