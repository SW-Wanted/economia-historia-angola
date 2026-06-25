/// Rascunho de registo partilhado entre os 3 passos do cadastro.
///
/// O fluxo de registo navega por rotas separadas (`register1/2/3`), cada uma
/// com o seu próprio estado. Este singleton acumula os dados introduzidos em
/// cada passo para que o passo final possa enviá-los ao backend de uma só vez.
class RegistrationDraft {
  RegistrationDraft._();

  static final RegistrationDraft instance = RegistrationDraft._();

  String name = '';
  String email = '';
  String course = '';
  String institution = '';
  String province = '';
  final Set<String> interests = {};
  String motivation = '';
  String password = '';

  bool get hasIdentity => name.trim().isNotEmpty && email.trim().isNotEmpty;

  void clear() {
    name = '';
    email = '';
    course = '';
    institution = '';
    province = '';
    interests.clear();
    motivation = '';
    password = '';
  }
}
