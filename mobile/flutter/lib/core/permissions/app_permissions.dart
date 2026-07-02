import '../../models/app_user.dart';

/// Permissões (claims) da plataforma — modelo RBAC.
///
/// A UI e os serviços devem verificar capacidades através destas permissões
/// (ex.: `user.can(Permission.createArticle)`) em vez de comparar papéis
/// diretamente (`role == escritor`). Assim, novos papéis podem ser adicionados
/// no futuro sem alterar a interface: basta mapeá-los aqui.
enum Permission {
  // ---- Criação de conteúdos ----
  createArticle,
  createVideo,
  createPodcast,
  createQuiz,
  createForum,
  createPrivateRoom,
  createPublicCommunity,
  createPrivateCommunity,
  createJindungo,
  createExclusiveContent,

  // ---- Gestão (globais) ----
  manageUsers,
  approveWriters,
  moderateAnyContent,
  manageTaxonomy, // categorias e etiquetas
  manageRankings,
  resolveReports,
  manageAdmins,
  managePlatformSettings,
}

/// Permissões de um Escritor (criação dos próprios conteúdos e espaços).
const Set<Permission> _writerPermissions = {
  Permission.createArticle,
  Permission.createVideo,
  Permission.createPodcast,
  Permission.createQuiz,
  Permission.createForum,
  Permission.createPrivateRoom,
  Permission.createPublicCommunity,
};

/// Permissões que o Administrador acrescenta às do Escritor.
const Set<Permission> _adminExtraPermissions = {
  Permission.createPrivateCommunity,
  Permission.createJindungo,
  Permission.createExclusiveContent,
  Permission.manageUsers,
  Permission.approveWriters,
  Permission.moderateAnyContent,
  Permission.manageTaxonomy,
  Permission.manageRankings,
  Permission.resolveReports,
};

/// Permissões que o Super Administrador acrescenta às do Administrador.
const Set<Permission> _superAdminExtraPermissions = {
  Permission.manageAdmins,
  Permission.managePlatformSettings,
};

/// Mapa papel → permissões. Cumulativo por hierarquia.
Set<Permission> permissionsForRole(UserRole role) => switch (role) {
      UserRole.utilizador => const <Permission>{},
      UserRole.escritor => _writerPermissions,
      UserRole.admin => {..._writerPermissions, ..._adminExtraPermissions},
      UserRole.superAdmin => {..._writerPermissions, ..._adminExtraPermissions, ..._superAdminExtraPermissions},
    };

/// Permissões de criação que alimentam dinamicamente o menu "Criar", por ordem
/// de apresentação. (A criação de quizzes acontece a partir de um conteúdo, por
/// isso não é uma entrada de topo aqui.)
const List<Permission> creationMenuPermissions = [
  Permission.createArticle,
  Permission.createVideo,
  Permission.createPodcast,
  Permission.createForum,
  Permission.createPrivateRoom,
  Permission.createPublicCommunity,
  Permission.createPrivateCommunity,
  Permission.createJindungo,
  Permission.createExclusiveContent,
];

extension AppUserPermissions on AppUser {
  /// Conjunto de permissões concedidas ao utilizador.
  Set<Permission> get grantedPermissions => permissionsForRole(role);

  /// Verifica uma permissão específica.
  bool can(Permission permission) => grantedPermissions.contains(permission);

  /// Tem pelo menos uma permissão de criação (controla a visibilidade do FAB).
  bool get canCreateContent => creationMenuPermissions.any(grantedPermissions.contains);
}
