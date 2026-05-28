# Política de Segurança

Levamos a segurança e integridade da plataforma **Economia com História — Angola** muito a sério. Se encontrou uma vulnerabilidade, reporte-a o mais rápido possível para que possamos remediar o problema rapidamente.

## Reportar uma Vulnerabilidade

Para vulnerabilidades que impactem a confidencialidade, integridade e disponibilidade dos serviços da plataforma, por favor envie a sua divulgação através de um dos seguintes canais:

- **GitHub Security Advisories**: Utilize a [tab Security](../../security) deste repositório
- **Email**: [20230429@isptec.co.ao](mailto:20230429@isptec.co.ao)

Para bugs não relacionados com segurança, siga as [diretrizes de contribuição](./CONTRIBUTING.md).

### Informação a Incluir

Inclua o máximo de detalhes possível para garantir a reprodutibilidade. No mínimo, a divulgação de vulnerabilidades deve incluir:

- **Descrição da Vulnerabilidade**: Explique claramente o problema de segurança identificado
- **Prova de Conceito (PoC)**: Passos detalhados para reproduzir a vulnerabilidade
- **Impacto**: Descreva o impacto potencial no sistema e utilizadores
- **Screenshots ou Evidências**: Capturas de ecrã, logs ou qualquer evidência relevante
- **Versão Afectada**: Indique qual(is) versão(ões) ou componente(s) está(ão) vulnerável(eis)
- **Ambiente**: Sistema operativo, browser, versão da aplicação (web/mobile)

### Diretrizes de Submissão

Por favor, siga estas diretrizes ao testar e reportar vulnerabilidades:

✅ **Faça:**
- Use apenas contas de teste para validação de vulnerabilidades
- Documente claramente os passos de reprodução
- Aguarde a nossa resposta antes de divulgar publicamente
- Reporte de forma responsável e ética

❌ **Não faça:**
- Realizar actividades que causem negação de serviço (DoS/DDoS)
- Criar sobrecargas significativas em recursos críticos
- Impactar negativamente utilizadores reais da plataforma
- Acessar, modificar ou eliminar dados que não sejam seus
- Divulgar publicamente a vulnerabilidade antes da correção
- Executar testes em ambiente de produção sem autorização

### Processo de Resposta

1. **Confirmação (até 72h)**: Receberemos e confirmaremos o recebimento do seu reporte
2. **Análise (3-7 dias)**: Validaremos a vulnerabilidade e avaliaremos a severidade
3. **Resolução**: Trabalharemos numa correção e manteremos contacto sobre o progresso
4. **Divulgação**: Após a correção, publicaremos um advisory de segurança (se aplicável)
5. **Reconhecimento**: Creditaremos a sua contribuição (se desejar)

## Versões Suportadas

Estamos a fornecer actualizações de segurança para as seguintes versões e componentes:

| Componente | Versão/Branch      | Suportada          |
| ---------- | ------------------ | ------------------ |
| Web        | main (produção)    | :white_check_mark: |
| Mobile     | main (produção)    | :white_check_mark: |
| Backend    | main (produção)    | :white_check_mark: |
| -          | dev (desenvolvimento) | :white_check_mark: |
| -          | branches de feature | :x:                |

**Nota**: Este projecto está em desenvolvimento activo. Recomendamos sempre utilizar a versão mais recente.

## Âmbito de Segurança

São consideradas vulnerabilidades de segurança relevantes:

- **Autenticação e Autorização**: Bypass de autenticação, escalação de privilégios
- **Injecção**: SQL injection, XSS, command injection
- **Exposição de Dados**: Acesso não autorizado a dados de utilizadores ou conteúdos
- **API**: Endpoints sem autenticação, rate limiting inadequado
- **Upload de Ficheiros**: Upload de ficheiros maliciosos
- **Sessões**: Sequestro de sessão, fixação de sessão

**Fora de âmbito:**
- Vulnerabilidades em dependências de terceiros (reporte directamente ao fornecedor)
- Ataques de engenharia social
- Problemas de usabilidade ou bugs não relacionados com segurança

---

Agradecemos a sua contribuição para manter a plataforma segura para todos os utilizadores.
