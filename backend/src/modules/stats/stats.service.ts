import { Injectable } from '@nestjs/common';
import { ContentStatus, Visibility } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

/**
 * Contagens públicas usadas na landing da app (secção "A comunidade em números").
 * Só conta registos reais e visíveis publicamente, com o mesmo critério dos
 * respetivos endpoints públicos de listagem.
 */
@Injectable()
export class StatsService {
  constructor(private readonly prisma: PrismaService) {}

  async landing() {
    const [members, contents, quizzes] = await Promise.all([
      this.prisma.user.count({ where: { isActive: true, deletedAt: null } }),
      this.prisma.content.count({
        where: {
          status: ContentStatus.PUBLISHED,
          visibility: Visibility.PUBLIC,
          deletedAt: null,
        },
      }),
      this.prisma.quiz.count({
        where: { visibility: Visibility.PUBLIC, deletedAt: null },
      }),
    ]);
    return { members, contents, quizzes };
  }

  /**
   * Estatísticas reais de uma província para o mapa. Como o conteúdo não tem
   * província própria, associamo-lo ao autor: conteúdos publicados cujos autores
   * pertencem à província, e o número de autores distintos com conteúdo lá.
   * Devolve zeros quando não há dados — sem valores fictícios.
   */
  async province(name: string) {
    const contentsWhere = {
      status: ContentStatus.PUBLISHED,
      visibility: Visibility.PUBLIC,
      deletedAt: null,
      author: { is: { province: name } },
    };
    const [contents, authorGroups] = await Promise.all([
      this.prisma.content.count({ where: contentsWhere }),
      this.prisma.content.groupBy({ by: ['authorId'], where: contentsWhere }),
    ]);
    return { province: name, contents, authors: authorGroups.length };
  }
}
