/// Perfis da aplicação, por ordem crescente de poder.
///
/// Hierarquia: utilizador < escritor < admin < superAdmin.
/// Cada nível pode fazer tudo o que os níveis inferiores fazem.
enum UserRole { utilizador, escritor, admin, superAdmin }

extension UserRoleX on UserRole {
  String get label => switch (this) {
        UserRole.utilizador => 'Utilizador',
        UserRole.escritor => 'Escritor',
        UserRole.admin => 'Admin',
        UserRole.superAdmin => 'Super Admin',
      };

  /// Posição na hierarquia (maior = mais poder).
  int get rank => switch (this) {
        UserRole.utilizador => 1,
        UserRole.escritor => 2,
        UserRole.admin => 3,
        UserRole.superAdmin => 4,
      };

  String get description => switch (this) {
        UserRole.utilizador => 'Lê conteúdos, participa em quizzes e no fórum.',
        UserRole.escritor => 'Tudo o que o utilizador faz e ainda publica conteúdos.',
        UserRole.admin => 'Tudo o que o escritor faz e ainda gere utilizadores e modera.',
        UserRole.superAdmin => 'Controlo total da plataforma, incluindo outros Super Admins.',
      };

  /// O que cada perfil PODE fazer (cumulativo) — mostrado no perfil.
  List<String> get permissions => switch (this) {
        UserRole.utilizador => const [
            'Explorar textos, vídeos e podcasts',
            'Participar em quizzes e ver a sua pontuação',
            'Comentar e debater no fórum',
            'Guardar conteúdos para ler offline',
          ],
        UserRole.escritor => const [
            'Tudo o que o Utilizador faz',
            'Publicar textos, vídeos e podcasts',
            'Criar tópicos públicos e privados',
            'Gerir os próprios conteúdos',
          ],
        UserRole.admin => const [
            'Tudo o que o Escritor faz',
            'Gerir utilizadores de nível inferior',
            'Promover Utilizador → Escritor e Escritor → Admin',
            'Moderar o fórum e resolver denúncias',
            'Aprovar pedidos de acesso a espaços privados',
          ],
        UserRole.superAdmin => const [
            'Tudo o que o Admin faz',
            'Promover Admin → Super Admin',
            'Editar, bloquear ou despromover perfis de grau inferior',
            'Gerir permissões de toda a plataforma',
          ],
      };

  String get code => switch (this) {
        UserRole.utilizador => 'utilizador',
        UserRole.escritor => 'escritor',
        UserRole.admin => 'admin',
        UserRole.superAdmin => 'super_admin',
      };
}

UserRole userRoleFromCode(String? code) => switch (code) {
      'escritor' => UserRole.escritor,
      'admin' => UserRole.admin,
      'super_admin' || 'superAdmin' => UserRole.superAdmin,
      _ => UserRole.utilizador,
    };

class AppUser {
  const AppUser({
    this.id,
    required this.name,
    required this.initials,
    required this.role,
    required this.course,
    this.email = '',
    this.points = 0,
    this.institution = 'ISPTEC',
    this.province = 'Luanda',
    this.superAdminGrade,
    this.bio,
    this.memberSince,
    this.avatarUrl,
    this.coverUrl,
  });

  /// Identificador no backend. `null` para utilizadores mock/anónimos. Necessário
  /// para as ações de gestão (mudar papel, bloquear, remover) que endereçam o
  /// utilizador por id.
  final String? id;

  final String name;
  final String initials;
  final UserRole role;
  final String course;
  final String email;
  final int points;
  final String institution;
  final String province;

  /// Biografia real do utilizador (de `/users/me`). `null`/vazia quando não
  /// preenchida — nesse caso a UI não mostra nada em vez de um texto fictício.
  final String? bio;

  /// Data de criação da conta (de `/users/me`). `null` quando desconhecida.
  final DateTime? memberSince;

  /// URLs das imagens de perfil e capa. `null`/vazio quando não definidas.
  final String? avatarUrl;
  final String? coverUrl;

  /// Grau de Super Admin: 0 é o fundador (o mais alto, imutável).
  /// Quanto MAIOR o número, MENOR a prioridade. `null` se não for Super Admin.
  final int? superAdminGrade;

  bool get isAdmin => role == UserRole.admin || role == UserRole.superAdmin;
  bool get isSuperAdmin => role == UserRole.superAdmin;
  bool get canPublish => role.rank >= UserRole.escritor.rank;
  bool get canModerate => role.rank >= UserRole.admin.rank;

  /// O Super Admin fundador (grau 0) não pode ser removido nem despromovido.
  bool get isFounder => isSuperAdmin && superAdminGrade == 0;

  /// Regras de gestão entre perfis (refletidas na UI).
  bool canManage(AppUser other) {
    if (other.isFounder) return false;
    if (role == UserRole.admin) {
      return other.role.rank < UserRole.admin.rank;
    }
    if (isSuperAdmin) {
      if (other.isSuperAdmin) {
        final mine = superAdminGrade ?? 999;
        final theirs = other.superAdminGrade ?? 999;
        return mine < theirs; // grau menor manda no grau maior
      }
      return true;
    }
    return false;
  }

  bool canPromote(AppUser other) => canManage(other);

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String?,
        name: json['name'] as String? ?? '',
        initials: json['initials'] as String? ?? _initialsOf(json['name'] as String? ?? ''),
        role: userRoleFromCode(json['role'] as String?),
        course: json['course'] as String? ?? '',
        email: json['email'] as String? ?? '',
        points: (json['points'] as num?)?.toInt() ?? 0,
        institution: json['institution'] as String? ?? 'ISPTEC',
        province: json['province'] as String? ?? 'Luanda',
        superAdminGrade: (json['superAdminGrade'] as num?)?.toInt(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'initials': initials,
        'role': role.code,
        'course': course,
        'email': email,
        'points': points,
        'institution': institution,
        'province': province,
        'superAdminGrade': superAdminGrade,
      };

  AppUser copyWith({UserRole? role, int? superAdminGrade}) => AppUser(
        id: id,
        name: name,
        initials: initials,
        role: role ?? this.role,
        course: course,
        email: email,
        points: points,
        institution: institution,
        province: province,
        superAdminGrade: superAdminGrade ?? this.superAdminGrade,
      );

  static String _initialsOf(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
