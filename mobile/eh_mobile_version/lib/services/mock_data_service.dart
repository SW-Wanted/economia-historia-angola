import 'package:flutter/material.dart';

import '../models/content_item.dart';
import '../models/forum_topic.dart';
import '../models/quiz_question.dart';
import '../models/ranking_user.dart';

class MockDataService {
  const MockDataService();

  List<ContentItem> contents() => const [
        ContentItem(title: 'Fundamentos: O que e o Kwanza?', subtitle: 'A moeda nacional como expressao de soberania economica.', category: 'Essencial', minutes: 5, icon: Icons.payments_outlined),
        ContentItem(title: 'Caminho de Ferro de Benguela', subtitle: 'Infraestrutura, comercio e ligacao regional no seculo XX.', category: 'Historia economica', minutes: 8, icon: Icons.train_outlined, featured: true),
        ContentItem(title: 'O ciclo do cafe em Angola', subtitle: 'Produzir, exportar e transformar regioes inteiras.', category: 'Agricultura', minutes: 6, icon: Icons.coffee_outlined),
        ContentItem(title: 'Textos Jindungo: Petroleo e poder', subtitle: 'Analise profunda sobre dependencia, renda e futuro.', category: 'Jindungo', minutes: 12, icon: Icons.local_fire_department_outlined, locked: true),
      ];

  List<ForumTopic> topics() => const [
        ForumTopic(
          title: 'Impacto da Inflação na História de Angola',
          author: 'Prof. Dr. Silva',
          authorRole: 'Professor',
          timeAgo: 'há 2 horas',
          tag: 'Economia',
          comments: 48,
          isPinned: true,
          description: 'Uma análise profunda sobre os ciclos económicos pós-independência e as lições para o futuro...',
        ),
        ForumTopic(
          title: 'Grupo de Estudo: Plano Real vs Kwanza',
          author: 'Elisa Kiala',
          authorRole: 'Estudante',
          timeAgo: 'há 5 horas',
          tag: 'Estudo Privado',
          comments: 12,
          private: true,
          description: 'Tópico reservado para os membros do grupo de pesquisa de macroeconomia comparada.',
        ),
        ForumTopic(
          title: 'O Comércio no Reino do Kongo',
          author: 'Joao Domingos',
          authorRole: 'Estudante',
          timeAgo: 'há 1 dia',
          tag: 'Ancestralidade',
          comments: 34,
          description: 'Como as rotas comerciais influenciaram as estruturas de poder na região no século XVI?',
        ),
      ];

  List<QuizQuestion> questions() => const [
        QuizQuestion(
          question: 'Qual produto chegou a colocar Angola entre os grandes produtores mundiais na decada de 1970?',
          options: ['Cafe', 'Algodao', 'Cacau', 'Sal'],
          correctIndex: 0,
          explanation: 'O cafe foi uma das exportacoes historicas mais importantes, especialmente no Uige.',
        ),
      ];

  List<RankingUser> ranking() => const [
        RankingUser(name: 'Manuel Kiala', points: 980, level: 'Mestre Jindungo', initials: 'MK'),
        RankingUser(name: 'Ana Muachia', points: 910, level: 'Historiadora', initials: 'AM'),
        RankingUser(name: 'Joao Domingos', points: 870, level: 'Analista', initials: 'JD'),
        RankingUser(name: 'Beatriz Neto', points: 790, level: 'Exploradora', initials: 'BN'),
      ];
}
