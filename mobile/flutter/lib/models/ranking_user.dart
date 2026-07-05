class RankingUser {
  const RankingUser({
    required this.name,
    required this.points,
    required this.level,
    required this.initials,
    this.province = '',
    this.institution = '',
    this.isCurrentUser = false,
    this.trend = 0,
    this.badges = const [],
  });

  final String name;
  final int points;
  final String level;
  final String initials;
  final String province;
  final String institution;
  final bool isCurrentUser;

  /// Evolução de posição face à semana anterior (+ sobe, - desce, 0 mantém).
  final int trend;

  /// Distintivos conquistados.
  final List<String> badges;

  factory RankingUser.fromJson(Map<String, dynamic> json) => RankingUser(
        name: json['name'] as String? ?? '',
        points: (json['points'] as num?)?.toInt() ?? 0,
        level: json['level'] as String? ?? '',
        initials: json['initials'] as String? ?? '',
        province: json['province'] as String? ?? '',
        institution: json['institution'] as String? ?? '',
        isCurrentUser: json['isCurrentUser'] as bool? ?? false,
        trend: (json['trend'] as num?)?.toInt() ?? 0,
        badges: (json['badges'] as List?)?.map((e) => '$e').toList() ?? const [],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'points': points,
        'level': level,
        'initials': initials,
        'province': province,
        'institution': institution,
        'isCurrentUser': isCurrentUser,
        'trend': trend,
        'badges': badges,
      };
}
