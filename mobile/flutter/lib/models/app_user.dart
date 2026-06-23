enum UserRole { normal, escritor, professor, admin, superAdmin }

extension UserRoleX on UserRole {
  String get label => switch (this) {
        UserRole.normal => 'Utilizador',
        UserRole.escritor => 'Escritor',
        UserRole.professor => 'Professor',
        UserRole.admin => 'Admin',
        UserRole.superAdmin => 'Super Admin',
      };
}

class AppUser {
  const AppUser({
    required this.name,
    required this.initials,
    required this.role,
    required this.course,
    this.email = '',
    this.points = 0,
  });

  final String name;
  final String initials;
  final UserRole role;
  final String course;
  final String email;
  final int points;

  bool get isAdmin => role == UserRole.admin || role == UserRole.superAdmin;
  bool get canPublish => role != UserRole.normal;
}
