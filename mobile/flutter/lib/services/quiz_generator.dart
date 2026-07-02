import '../models/quiz_question.dart';

/// Assistente de IA (simulado) que gera quizzes a partir de um conteúdo
/// (artigo, vídeo ou podcast).
///
/// Não faz uma chamada real a um modelo — aplica regras sobre o tema/categoria
/// do conteúdo para produzir perguntas plausíveis, com um pequeno atraso que
/// simula o processamento. Está isolado num serviço: quando existir um endpoint
/// de IA no backend, basta trocar a implementação de [generate] sem mexer na UI.
class QuizGenerator {
  QuizGenerator._();

  static final QuizGenerator instance = QuizGenerator._();

  /// Gera [count] perguntas a partir do [title]/[category] do conteúdo.
  Future<List<QuizQuestion>> generate({
    required String title,
    required String category,
    int count = 5,
    String difficulty = 'Médio',
  }) async {
    // Simula o tempo de "pensamento" do assistente.
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    final result = <QuizQuestion>[];

    // 1ª pergunta ancorada no próprio conteúdo (parece gerada a partir dele).
    result.add(QuizQuestion(
      question: 'Qual é o tema central de "$title"?',
      options: _themeOptions(category),
      correctIndex: 0,
      explanation: 'O conteúdo aborda sobretudo $category no contexto da economia angolana.',
    ));

    // Restantes: banco por categoria + banco genérico para completar.
    final pool = [...?_byCategory[category], ..._generic];
    for (final q in pool) {
      if (result.length >= count) break;
      result.add(q);
    }

    return result.take(count).toList();
  }

  List<String> _themeOptions(String category) {
    final others = _allCategories.where((c) => c != category).take(3).toList();
    return [category, ...others];
  }

  static const _allCategories = [
    'Moeda & Finanças', 'Agricultura', 'Infraestrutura', 'História de Angola',
    'Comércio', 'Economia Política', 'Petróleo', 'Economia Colonial',
  ];

  static const _generic = [
    QuizQuestion(
      question: 'Em que ano foi introduzido o Kwanza como moeda nacional?',
      options: ['1975', '1977', '1980', '1991'],
      correctIndex: 1,
      explanation: 'O Kwanza foi introduzido em 1977, substituindo o escudo angolano.',
    ),
    QuizQuestion(
      question: 'Qual porto era o destino principal do Caminho de Ferro de Benguela?',
      options: ['Luanda', 'Namibe', 'Lobito', 'Soyo'],
      correctIndex: 2,
      explanation: 'A ferrovia ligava o interior ao porto do Lobito, em Benguela.',
    ),
    QuizQuestion(
      question: 'O que descreve melhor uma economia dependente de um único recurso?',
      options: ['Diversificada', 'Monoexportadora', 'Autossuficiente', 'Fechada'],
      correctIndex: 1,
      explanation: 'Uma economia monoexportadora concentra as receitas num só produto.',
    ),
  ];

  static const _byCategory = <String, List<QuizQuestion>>{
    'Agricultura': [
      QuizQuestion(
        question: 'Qual produto colocou Angola entre os grandes produtores mundiais na década de 1970?',
        options: ['Café', 'Algodão', 'Cacau', 'Sal'],
        correctIndex: 0,
        explanation: 'O café foi uma das exportações históricas mais importantes, sobretudo no Uíge.',
      ),
    ],
    'Moeda & Finanças': [
      QuizQuestion(
        question: 'O que é a inflação estrutural?',
        options: [
          'Subida de preços por fatores persistentes da economia',
          'Uma queda pontual dos preços',
          'A valorização da moeda',
          'Um imposto sobre importações',
        ],
        correctIndex: 0,
        explanation: 'Resulta de fatores persistentes (custos, oferta rígida), não de choques pontuais.',
      ),
    ],
    'Infraestrutura': [
      QuizQuestion(
        question: 'Qual foi o principal objetivo económico do Caminho de Ferro de Benguela?',
        options: [
          'Criar um corredor de exportação para o litoral',
          'Ligar bairros de Luanda',
          'Transportar apenas passageiros',
          'Substituir os portos',
        ],
        correctIndex: 0,
        explanation: 'Foi concebido para escoar o interior mineiro até ao porto do Lobito.',
      ),
    ],
    'Petróleo': [
      QuizQuestion(
        question: 'O que é a "renda petrolífera"?',
        options: [
          'A receita extraordinária gerada pela exploração do petróleo',
          'Um empréstimo ao setor petrolífero',
          'O aluguer de plataformas',
          'Um imposto sobre combustíveis',
        ],
        correctIndex: 0,
        explanation: 'É a receita extraordinária associada à exploração do recurso.',
      ),
    ],
    'Economia Colonial': [
      QuizQuestion(
        question: 'As assimetrias regionais em Angola têm raízes sobretudo em quê?',
        options: [
          'Nas estruturas económicas do período colonial',
          'Em decisões recentes apenas',
          'No clima',
          'Na demografia atual',
        ],
        correctIndex: 0,
        explanation: 'Concessões e infraestruturas coloniais moldaram desigualdades duradouras.',
      ),
    ],
  };
}
