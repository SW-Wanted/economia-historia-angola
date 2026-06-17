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
        ForumTopic(title: 'O impacto das ferrovias no sec. XX?', author: 'Joao Domingos', comments: 12, tag: 'Infraestrutura'),
        ForumTopic(title: 'Como explicar inflacao aos alunos do ensino medio?', author: 'Elisa Kiala', comments: 8, tag: 'Educacao'),
        ForumTopic(title: 'Debate privado: fontes sobre politica cambial', author: 'Nucleo Jindungo', comments: 21, tag: 'Premium', private: true),
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
