/// Preferências e definições do utilizador, em memória (offline-first).
///
/// Fonte única para as Definições. Pode ser ligada a persistência/backend mais
/// tarde sem alterar a UI.
class AppSettings {
  AppSettings._();

  static final AppSettings instance = AppSettings._();

  // Preferências.
  bool notifications = true;
  bool newsletters = false;
  bool showReadingStats = true;

  // Aparência.
  bool darkMode = false;
  String language = 'Português';

  static const List<String> languages = ['Português', 'English', 'Français'];

  // Privacidade.
  /// Perfil visível apenas para administração (admin/super admin).
  bool profileLocked = false;
}
