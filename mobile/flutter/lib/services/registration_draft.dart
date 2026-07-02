/// Rascunho de registo partilhado entre os 3 passos do cadastro.
///
/// O fluxo de registo navega por rotas separadas (`register1/2/3`), cada uma
/// com o seu próprio estado. Este singleton acumula os dados introduzidos em
/// cada passo para que o passo final possa enviá-los ao backend.
///
/// Separação de responsabilidades:
/// - os campos de identidade/segurança pertencem ao `User`;
/// - a candidatura a Escritor é opcional ([asWriter]) e, quando ativa, é
///   enviada à parte como `WriterApplication` (status PENDING).
class RegistrationDraft {
  RegistrationDraft._();

  static final RegistrationDraft instance = RegistrationDraft._();

  // --- Dados da conta (User) ---
  String name = '';
  String email = '';
  String password = '';

  // --- Personalização opcional ---
  final Set<String> interests = {};

  /// Texto livre de feedback: o que motivou o utilizador a aderir.
  /// É apenas personalização/feedback — não faz parte da candidatura.
  String motivation = '';

  /// Quando verdadeiro, o utilizador pediu para se candidatar a Escritor.
  /// A conta é criada na mesma como utilizador comum (USER); a candidatura é
  /// enviada à parte e fica pendente de aprovação administrativa.
  bool asWriter = false;

  bool get hasIdentity => name.trim().isNotEmpty && email.trim().isNotEmpty;

  void clear() {
    name = '';
    email = '';
    password = '';
    interests.clear();
    motivation = '';
    asWriter = false;
  }

  /// Constrói o payload da candidatura a partir dos dados recolhidos.
  /// Reaproveita os interesses já indicados no cadastro (não os pede de novo).
  Map<String, dynamic> toWriterApplication() => {
        'fullName': name.trim(),
        if (interests.isNotEmpty) 'topicsOfInterest': interests.toList(),
      };
}
