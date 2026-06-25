import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../models/comment.dart';
import '../models/community_category.dart';
import '../models/content_item.dart';
import '../models/content_report.dart';
import '../models/dashboard_data.dart';
import '../models/forum_topic.dart';
import '../models/notification_item.dart';
import '../models/quiz_question.dart';
import '../models/ranking_user.dart';

class MockDataService {
  const MockDataService();

  AppUser currentUser() => const AppUser(
        name: 'Manuel Kiala',
        initials: 'MK',
        role: UserRole.superAdmin,
        course: 'Economia',
        email: 'manuel.kiala@isptec.co.ao',
        points: 980,
        institution: 'ISPTEC',
        province: 'Luanda',
        superAdminGrade: 0,
      );

  /// Utilizadores fictícios para gestão e atribuição de perfis.
  /// Cada utilizador tem um único perfil coerente em toda a aplicação.
  List<AppUser> users() => const [
        AppUser(name: 'Manuel Kiala', initials: 'MK', role: UserRole.superAdmin, course: 'Economia', email: 'manuel.kiala@isptec.co.ao', points: 980, institution: 'ISPTEC', province: 'Luanda', superAdminGrade: 0),
        AppUser(name: 'Carlos Lopes', initials: 'CL', role: UserRole.superAdmin, course: 'História Económica', email: 'carlos.lopes@isptec.co.ao', points: 1120, institution: 'ISPTEC', province: 'Luanda', superAdminGrade: 1),
        AppUser(name: 'Ana Muachia', initials: 'AM', role: UserRole.admin, course: 'História', email: 'ana.muachia@isptec.co.ao', points: 910, institution: 'UAN', province: 'Benguela'),
        AppUser(name: 'Dr. Kambinda', initials: 'DK', role: UserRole.escritor, course: 'Economia Política', email: 'kambinda@isptec.co.ao', points: 860, institution: 'ISPTEC', province: 'Huíla'),
        AppUser(name: 'João Domingos', initials: 'JD', role: UserRole.utilizador, course: 'Gestão', email: 'joao.domingos@isptec.co.ao', points: 870, institution: 'UAN', province: 'Luanda'),
        AppUser(name: 'Beatriz Neto', initials: 'BN', role: UserRole.utilizador, course: 'Ciências Sociais', email: 'beatriz.neto@isptec.co.ao', points: 790, institution: 'UCAN', province: 'Benguela'),
        AppUser(name: 'Elisa Kiala', initials: 'EK', role: UserRole.utilizador, course: 'Direito', email: 'elisa.kiala@isptec.co.ao', points: 740, institution: 'ISPTEC', province: 'Huambo'),
      ];

  List<ContentItem> contents() => const [
        ContentItem(
          title: 'Fundamentos: O que e o Kwanza?',
          subtitle: 'A moeda nacional como expressao de soberania económica.',
          category: 'Essencial',
          minutes: 5,
          icon: Icons.payments_outlined,
          body: [
            'O Kwanza nasce em 1977 como simbolo de soberania de um pais recem-independente. Mais do que um meio de troca, representa a vontade de organizar a economia segundo prioridades proprias.',
            'Ao longo das decadas, o Kwanza atravessou reformas e redenominacoes que refletem os ciclos de inflacao e estabilizacao da economia angolana.',
            'Compreender a moeda e compreender a história das escolhas económicas do pais: como se financiou o Estado, como se protegeu o poder de compra e como se ligou Angola aos mercados internacionais.',
          ],
        ),
        ContentItem(
          title: 'Caminho de Ferro de Benguela',
          subtitle: 'Infraestrutura, comercio e ligacao regional no seculo XX.',
          category: 'História económica',
          minutes: 8,
          icon: Icons.train_outlined,
          featured: true,
          province: 'Benguela',
          body: [
            'O Caminho de Ferro de Benguela foi concebido para ligar o interior mineiro ao porto do Lobito, criando um corredor de exportação com impacto regional.',
            'A ferrovia reorganizou mercados, rotas de trabalho e a propria geografia económica do centro de Angola.',
          ],
        ),
        ContentItem(
          title: 'O ciclo do café em Angola',
          subtitle: 'Produzir, exportar e transformar regioes inteiras.',
          category: 'Agricultura',
          minutes: 6,
          icon: Icons.coffee_outlined,
          province: 'Uige',
          body: [
            'Na decada de 1970, o café colocou Angola entre os maiores produtores mundiais, movimentando economias inteiras no norte do pais.',
            'O ciclo do café mostra como uma cultura de exportação molda infraestrutura, emprego e dependencia externa.',
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

  // ----- Dashboard -----

  ContinueReading continueReading() => const ContinueReading(
        title: 'Ciclos Economicos: 1975–1992',
        subtitle: 'Modulo 3 • Aula 4',
        progress: .65,
      );

  WeeklyQuiz weeklyQuiz() => const WeeklyQuiz(
        title: 'Quiz da Semana',
        description: 'Teste os seus conhecimentos sobre o Café em Angola.',
      );

  List<DashboardHighlight> highlights() => const [
        DashboardHighlight(tag: 'ECONOMIA', title: 'Impacto do Setor Petrolifero', icon: Icons.oil_barrel_outlined),
        DashboardHighlight(tag: 'HISTÓRIA', title: 'Rotas de Comercio no Seculo XIX', icon: Icons.route_outlined),
      ];

  FeaturedJindungo featuredJindungo() => const FeaturedJindungo(
        quote: '"A análise definitiva sobre a inflacao estrutural e a herança colonial nos mercados do Lobito."',
        source: 'Dr. Kambinda, 2023',
      );

  String didYouKnow() => 'Na decada de 1970, Angola chegou a ser o quarto maior produtor mundial de café.';

  List<ForumTopic> topics() => const [
        ForumTopic(
          title: 'Impacto da Inflacao na História de Angola',
          author: 'Carlos Lopes',
          role: 'Admin',
          comments: 48,
          tag: 'Economia',
          timeAgo: 'há 2 horas',
          excerpt: 'Uma análise profunda sobre os ciclos económicos pos-independencia e os seus efeitos sociais.',
          pinned: true,
        ),
        ForumTopic(
          title: 'Exportação de petroleo: bencao ou dependencia?',
          author: 'João Domingos',
          role: 'Estudante',
          comments: 27,
          tag: 'Petróleo',
          timeAgo: 'há 3 horas',
          excerpt: 'Debate sobre a renda petrolifera e os desafios da diversificação económica em Angola.',
        ),
        ForumTopic(
          title: 'Reformas monetárias do Kwanza: 1990 a 1999',
          author: 'Dr. Kambinda',
          role: 'Escritor',
          comments: 19,
          tag: 'Reformas monetárias',
          timeAgo: 'há 4 horas',
          excerpt: 'Como as redenominacoes do Kwanza refletiram os ciclos de inflacao e estabilizacao.',
        ),
        ForumTopic(
          title: 'Agricultura e desenvolvimento regional no interior',
          author: 'Beatriz Neto',
          role: 'Estudante',
          comments: 22,
          tag: 'Agricultura',
          timeAgo: 'há 6 horas',
          excerpt: 'O papel do café, da mandioca e da pecuária no desenvolvimento das províncias do interior.',
        ),
        ForumTopic(
          title: 'Grupo de Estudo: Plano Real vs Kwanza',
          author: 'Nucleo de Pesquisa',
          role: 'Privado',
          comments: 12,
          tag: 'Estudo Privado',
          timeAgo: 'há 5 horas',
          excerpt: 'Tópico reservado para os membros do grupo de pesquisa de politica cambial.',
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
        CommunityCategory(name: 'História Economica', description: 'Ciclos, moeda e mercados ao longo do tempo.', topics: 24, members: 312),
        CommunityCategory(name: 'Economia Aplicada', description: 'Conceitos económicos na realidade angolana.', topics: 18, members: 268),
        CommunityCategory(name: 'Nucleo Jindungo', description: 'Debates criticos reservados a membros aprovados.', topics: 9, members: 41, private: true),
      ];

  List<Comment> comments() => const [
        Comment(author: 'Ana Muachia', initials: 'AM', role: 'Historiadora', text: 'Vale olhar para o Caminho de Ferro de Benguela como corredor regional, não apenas como obra isolada.', timeAgo: 'há 1 hora', likes: 12),
        Comment(author: 'Joao Domingos', initials: 'JD', role: 'Analista', text: 'Concordo. A infraestrutura define quem participa do mercado e quem fica de fora.', timeAgo: 'há 40 min', likes: 5),
        Comment(author: 'Manuel Kiala', initials: 'MK', text: 'Alguem tem fontes sobre o impacto no emprego rural?', timeAgo: 'há 10 min', isAuthor: true),
      ];

  List<QuizQuestion> questions() => const [
        QuizQuestion(
          question: 'Qual produto chegou a colocar Angola entre os grandes produtores mundiais na decada de 1970?',
          options: ['Café', 'Algodao', 'Cacau', 'Sal'],
          correctIndex: 0,
          explanation: 'O café foi uma das exportações históricas mais importantes, especialmente no Uige.',
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
        RankingUser(name: 'Manuel Kiala', points: 980, level: 'Mestre Jindungo', initials: 'MK', province: 'Luanda', institution: 'ISPTEC', isCurrentUser: true, trend: 2, badges: ['Maratona', 'Top Fórum']),
        RankingUser(name: 'Ana Muachia', points: 910, level: 'Historiadora', initials: 'AM', province: 'Benguela', institution: 'UAN', trend: -1, badges: ['Leitora Ávida']),
        RankingUser(name: 'João Domingos', points: 870, level: 'Analista', initials: 'JD', province: 'Luanda', institution: 'UAN', trend: 1, badges: ['Quiz Perfeito']),
        RankingUser(name: 'Beatriz Neto', points: 790, level: 'Exploradora', initials: 'BN', province: 'Benguela', institution: 'UCAN', trend: 0, badges: ['Curiosa']),
        RankingUser(name: 'Elisa Kiala', points: 740, level: 'Estudante', initials: 'EK', province: 'Huambo', institution: 'ISPTEC', trend: 3),
        RankingUser(name: 'Paulo Capi', points: 680, level: 'Estudante', initials: 'PC', province: 'Luanda', institution: 'ISPTEC', trend: -2),
        RankingUser(name: 'Teresa Sambo', points: 640, level: 'Estudante', initials: 'TS', province: 'Huíla', institution: 'UMN', trend: 1),
        RankingUser(name: 'Edson Bunga', points: 600, level: 'Estudante', initials: 'EB', province: 'Benguela', institution: 'UAN', trend: 0),
      ];

  List<NotificationItem> notifications() => const [
        NotificationItem(title: 'Novo quiz semanal', body: 'O quiz sobre o Café em Angola ja esta disponivel.', timeAgo: 'há 30 min', kind: NotificationKind.quiz, unread: true),
        NotificationItem(title: 'Ana respondeu ao seu tópico', body: '"O impacto das ferrovias no sec. XX?"', timeAgo: 'há 2 horas', kind: NotificationKind.forum, unread: true),
        NotificationItem(title: 'Texto Jindungo publicado', body: 'Petroleo e poder ja esta disponivel para membros.', timeAgo: 'há 1 dia', kind: NotificationKind.content),
        NotificationItem(title: 'Pedido de acesso aprovado', body: 'O seu acesso ao Nucleo Jindungo foi aprovado.', timeAgo: 'há 2 dias', kind: NotificationKind.access),
      ];

  /// Denuncias pendentes de revisao pela moderacao.
  List<ContentReport> reports() => const [
        ContentReport(
          title: 'Comentario em "Impacto da Inflacao na História de Angola"',
          target: ReportTarget.comment,
          reason: ReportReason.offensive,
          excerpt: 'Linguagem ofensiva dirigida a outro participante do debate.',
          timeAgo: 'há 1 hora',
          count: 3,
        ),
        ContentReport(
          title: 'Tópico "Grupo de Estudo: Plano Real vs Kwanza"',
          target: ReportTarget.topic,
          reason: ReportReason.misinformation,
          excerpt: 'Dados sobre cambio apresentados sem fontes e considerados enganosos.',
          timeAgo: 'há 4 horas',
          count: 2,
        ),
        ContentReport(
          title: 'Comentario em "O Comercio no Reino do Kongo"',
          target: ReportTarget.comment,
          reason: ReportReason.spam,
          excerpt: 'Publicação repetida com ligacoes externas de publicidade.',
          timeAgo: 'há 1 dia',
          count: 1,
        ),
      ];

  List<String> provinces() => const [
        'Luanda', 'Benguela', 'Huambo', 'Uige', 'Huila', 'Namibe', 'Cabinda', 'Malanje',
      ];

  Map<String, String> faq() => const {
        'O conteúdo e gratuito?': 'Sim. O projeto e sem fins lucrativos; o registo serve para controlo de acesso e metricas. Microtextos estao disponiveis livremente, incluindo em modo offline.',
        'Quem escreve os textos?': 'Inicialmente a gestão de conteúdos e feita pelo Prof. Carlos Lopes. Escritores, professores e estudantes autorizados tambem podem publicar artigos.',
        'O que sao textos com Jindungo?': 'Sao textos curtos de opinião e visão critica sobre a economia angolana. Exigem login e, por vezes, permissão do autor para serem lidos.',
        'Como participo nos quizzes e rankings?': 'Basta ter conta registada. Os quizzes sao renovados periodicamente para se manterem interessantes.',
        'Como funciona o modo offline?': 'Os microtextos ficam acessiveis mesmo sem ligacao a internet, com prioridade de leitura.',
      };
}
