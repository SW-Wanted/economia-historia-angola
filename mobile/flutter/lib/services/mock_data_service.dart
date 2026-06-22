import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../models/comment.dart';
import '../models/community_category.dart';
import '../models/content_item.dart';
import '../models/forum_topic.dart';
import '../models/notification_item.dart';
import '../models/quiz_question.dart';
import '../models/ranking_user.dart';

class MockDataService {
  const MockDataService();

  AppUser currentUser() => const AppUser(
        name: 'Manuel Kiala',
        initials: 'MK',
        role: UserRole.admin,
        course: 'Economia',
        points: 980,
      );

  List<ContentItem> contents() => const [
        ContentItem(
          title: 'Fundamentos: O que e o Kwanza?',
          subtitle: 'A moeda nacional como expressao de soberania economica.',
          category: 'Essencial',
          minutes: 5,
          icon: Icons.payments_outlined,
          body: [
            'O Kwanza nasce em 1977 como simbolo de soberania de um pais recem-independente. Mais do que um meio de troca, representa a vontade de organizar a economia segundo prioridades proprias.',
            'Ao longo das decadas, o Kwanza atravessou reformas e redenominacoes que refletem os ciclos de inflacao e estabilizacao da economia angolana.',
            'Compreender a moeda e compreender a historia das escolhas economicas do pais: como se financiou o Estado, como se protegeu o poder de compra e como se ligou Angola aos mercados internacionais.',
          ],
        ),
        ContentItem(
          title: 'Caminho de Ferro de Benguela',
          subtitle: 'Infraestrutura, comercio e ligacao regional no seculo XX.',
          category: 'Historia economica',
          minutes: 8,
          icon: Icons.train_outlined,
          featured: true,
          province: 'Benguela',
          body: [
            'O Caminho de Ferro de Benguela foi concebido para ligar o interior mineiro ao porto do Lobito, criando um corredor de exportacao com impacto regional.',
            'A ferrovia reorganizou mercados, rotas de trabalho e a propria geografia economica do centro de Angola.',
          ],
        ),
        ContentItem(
          title: 'O ciclo do cafe em Angola',
          subtitle: 'Produzir, exportar e transformar regioes inteiras.',
          category: 'Agricultura',
          minutes: 6,
          icon: Icons.coffee_outlined,
          province: 'Uige',
          body: [
            'Na decada de 1970, o cafe colocou Angola entre os maiores produtores mundiais, movimentando economias inteiras no norte do pais.',
            'O ciclo do cafe mostra como uma cultura de exportacao molda infraestrutura, emprego e dependencia externa.',
          ],
        ),
        ContentItem(
          title: 'Textos Jindungo: Petroleo e poder',
          subtitle: 'Analise profunda sobre dependencia, renda e futuro.',
          category: 'Jindungo',
          minutes: 12,
          icon: Icons.local_fire_department_outlined,
          locked: true,
          author: 'Dr. Kambinda',
          body: [
            '"A renda do petroleo e uma bencao que cobra juros. Financia o presente e hipoteca a imaginacao sobre o futuro."',
            'Este texto com jindungo aplica conceitos de economia de recursos a realidade concreta de Angola, com linguagem critica e direta.',
          ],
        ),
      ];

  ContentItem jindungo() => contents().firstWhere((c) => c.locked);

  List<ForumTopic> topics() => const [
        ForumTopic(
          title: 'Impacto da Inflacao na Historia de Angola',
          author: 'Carlos Lopes',
          role: 'Professor',
          comments: 48,
          tag: 'Economia',
          timeAgo: 'há 2 horas',
          excerpt: 'Uma analise profunda sobre os ciclos economicos pos-independencia e os seus efeitos sociais.',
          pinned: true,
        ),
        ForumTopic(
          title: 'Grupo de Estudo: Plano Real vs Kwanza',
          author: 'Nucleo de Pesquisa',
          role: 'Privado',
          comments: 12,
          tag: 'Estudo Privado',
          timeAgo: 'há 5 horas',
          excerpt: 'Topico reservado para os membros do grupo de pesquisa de politica cambial.',
          private: true,
        ),
        ForumTopic(
          title: 'O Comercio no Reino do Kongo',
          author: 'Beatriz Neto',
          role: 'Estudante',
          comments: 34,
          tag: 'Comercio',
          timeAgo: 'há 1 dia',
          excerpt: 'Como as rotas comerciais influenciaram as estruturas de poder ancestrais.',
        ),
      ];

  List<CommunityCategory> categories() => const [
        CommunityCategory(name: 'Historia Economica', description: 'Ciclos, moeda e mercados ao longo do tempo.', topics: 24, members: 312),
        CommunityCategory(name: 'Economia Aplicada', description: 'Conceitos economicos na realidade angolana.', topics: 18, members: 268),
        CommunityCategory(name: 'Nucleo Jindungo', description: 'Debates criticos reservados a membros aprovados.', topics: 9, members: 41, private: true),
      ];

  List<Comment> comments() => const [
        Comment(author: 'Ana Muachia', initials: 'AM', role: 'Historiadora', text: 'Vale olhar para o Caminho de Ferro de Benguela como corredor regional, nao apenas como obra isolada.', timeAgo: 'há 1 hora', likes: 12),
        Comment(author: 'Joao Domingos', initials: 'JD', role: 'Analista', text: 'Concordo. A infraestrutura define quem participa do mercado e quem fica de fora.', timeAgo: 'há 40 min', likes: 5),
        Comment(author: 'Manuel Kiala', initials: 'MK', text: 'Alguem tem fontes sobre o impacto no emprego rural?', timeAgo: 'há 10 min', isAuthor: true),
      ];

  List<QuizQuestion> questions() => const [
        QuizQuestion(
          question: 'Qual produto chegou a colocar Angola entre os grandes produtores mundiais na decada de 1970?',
          options: ['Cafe', 'Algodao', 'Cacau', 'Sal'],
          correctIndex: 0,
          explanation: 'O cafe foi uma das exportacoes historicas mais importantes, especialmente no Uige.',
        ),
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
          explanation: 'A ferrovia ligava o interior ao porto do Lobito, no litoral de Benguela.',
        ),
      ];

  List<RankingUser> ranking() => const [
        RankingUser(name: 'Manuel Kiala', points: 980, level: 'Mestre Jindungo', initials: 'MK'),
        RankingUser(name: 'Ana Muachia', points: 910, level: 'Historiadora', initials: 'AM'),
        RankingUser(name: 'Joao Domingos', points: 870, level: 'Analista', initials: 'JD'),
        RankingUser(name: 'Beatriz Neto', points: 790, level: 'Exploradora', initials: 'BN'),
        RankingUser(name: 'Elisa Kiala', points: 740, level: 'Estudante', initials: 'EK'),
      ];

  List<NotificationItem> notifications() => const [
        NotificationItem(title: 'Novo quiz semanal', body: 'O quiz sobre o Cafe em Angola ja esta disponivel.', timeAgo: 'há 30 min', kind: NotificationKind.quiz, unread: true),
        NotificationItem(title: 'Ana respondeu ao seu topico', body: '"O impacto das ferrovias no sec. XX?"', timeAgo: 'há 2 horas', kind: NotificationKind.forum, unread: true),
        NotificationItem(title: 'Texto Jindungo publicado', body: 'Petroleo e poder ja esta disponivel para membros.', timeAgo: 'há 1 dia', kind: NotificationKind.content),
        NotificationItem(title: 'Pedido de acesso aprovado', body: 'O seu acesso ao Nucleo Jindungo foi aprovado.', timeAgo: 'há 2 dias', kind: NotificationKind.access),
      ];

  List<String> provinces() => const [
        'Luanda', 'Benguela', 'Huambo', 'Uige', 'Huila', 'Namibe', 'Cabinda', 'Malanje',
      ];

  Map<String, String> faq() => const {
        'O conteudo e gratuito?': 'Sim. O projeto e sem fins lucrativos; o registo serve para controlo de acesso e metricas. Microtextos estao disponiveis livremente, incluindo em modo offline.',
        'Quem escreve os textos?': 'Inicialmente a gestao de conteudos e feita pelo Prof. Carlos Lopes. Escritores, professores e estudantes autorizados tambem podem publicar artigos.',
        'O que sao textos com Jindungo?': 'Sao textos curtos de opiniao e visao critica sobre a economia angolana. Exigem login e, por vezes, permissao do autor para serem lidos.',
        'Como participo nos quizzes e rankings?': 'Basta ter conta registada. Os quizzes sao renovados periodicamente para se manterem interessantes.',
        'Como funciona o modo offline?': 'Os microtextos ficam acessiveis mesmo sem ligacao a internet, com prioridade de leitura.',
      };
}
