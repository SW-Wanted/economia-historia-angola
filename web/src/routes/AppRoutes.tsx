import { Routes, Route, Navigate } from 'react-router-dom'
import ProtectedRoute from '../components/ProtectedRoute'
import PermissionRoute from '../components/PermissionRoute'
import { useAuth } from '../contexts/AuthContext'

// Auth / Public
import SplashScreen from '../pages/SplashScreen'
import Login from '../pages/Login'
import Cadastro1 from '../pages/Cadastro1'
import Cadastro2 from '../pages/Cadastro2'
import CadastroSucesso from '../pages/CadastroSucesso'
import RecuperarSenha from '../pages/RecuperarSenha'
import Onboarding1 from '../pages/Onboarding1'
import Onboarding2 from '../pages/Onboarding2'
import Onboarding3 from '../pages/Onboarding3'
import HomeLanding from '../pages/HomeLanding'

// App pages
import Dashboard from '../pages/Dashboard'
import Explorar from '../pages/Explorar'
import Forum from '../pages/Forum'
import ForumDetalhe from '../pages/ForumDetalhe'
import SubmeterTopico from '../pages/SubmeterTopico'
import Perfil from '../pages/Perfil'
import QuizHub from '../pages/QuizHub'
import QuizEmCurso from '../pages/QuizEmCurso'
import ResultadoQuiz from '../pages/ResultadoQuiz'
import CriarQuiz from '../pages/CriarQuiz'
import MapaInterativo from '../pages/MapaInterativo'
import MapaCaminhosHist from '../pages/MapaCaminhosHist'
import LeituraMicrotexto from '../pages/LeituraMicrotexto'
import LeituraJindungo from '../pages/LeituraJindungo'
import MinhasBiblioteca from '../pages/MinhasBiblioteca'
import MeusFavoritos from '../pages/MeusFavoritos'
import GuiaRapido from '../pages/GuiaRapido'
import GuiaInvestigacao from '../pages/GuiaInvestigacao'
import PainelEstatisticas from '../pages/PainelEstatisticas'
import PainelGestaoConteudos from '../pages/PainelGestaoConteudos'
import GestaoUtilizadores from '../pages/GestaoUtilizadores'
import SubmeterArtigo from '../pages/SubmeterArtigo'
import ConfirmacaoPublicacao from '../pages/ConfirmacaoPublicacao'
import ConfirmacaoSaida from '../pages/ConfirmacaoSaida'
import Notificacoes from '../pages/Notificacoes'
import ResultadosPesquisa from '../pages/ResultadosPesquisa'
import ConteudosProvincia from '../pages/ConteudosProvincia'
import AulaVideo from '../pages/AulaVideo'
import DetalheDocumento from '../pages/DetalheDocumento'
import CentroAjuda from '../pages/CentroAjuda'

function Protected({ children }: { children: React.ReactNode }) {
  return <ProtectedRoute>{children}</ProtectedRoute>
}

/** Route requiring at least one of the listed permissions (after auth check). */
function PermProtected({ children, permissions }: { children: React.ReactNode; permissions: string[] }) {
  return (
    <ProtectedRoute>
      <PermissionRoute permissions={permissions}>{children}</PermissionRoute>
    </ProtectedRoute>
  )
}

/**
 * Entrada da aplicação. Um utilizador autenticado vai directamente para o seu
 * painel; um Visitante começa na Landing Page pública (mesmo conceito da app
 * Mobile, onde o Visitante conhece a plataforma antes de criar conta).
 */
function RootEntry() {
  const { isAuthenticated, isLoading } = useAuth()
  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-[#F2F2F0]">
        <div className="w-8 h-8 border-2 border-[#8B1A1A] border-t-transparent rounded-full animate-spin" />
      </div>
    )
  }
  return <Navigate to={isAuthenticated ? '/dashboard' : '/home'} replace />
}

export default function AppRoutes() {
  return (
    <Routes>
      {/* Entrada — decide entre painel (autenticado) e landing (visitante) */}
      <Route path="/" element={<RootEntry />} />
      <Route path="/splash" element={<SplashScreen />} />
      <Route path="/onboarding/1" element={<Onboarding1 />} />
      <Route path="/onboarding/2" element={<Onboarding2 />} />
      <Route path="/onboarding/3" element={<Onboarding3 />} />

      {/* Public — auth */}
      <Route path="/login" element={<Login />} />
      <Route path="/cadastro" element={<Cadastro1 />} />
      <Route path="/cadastro/2" element={<Cadastro2 />} />
      {/* Compat: a antiga etapa 3 (palavra-passe) foi fundida na etapa 1. */}
      <Route path="/cadastro/3" element={<Navigate to="/cadastro" replace />} />
      <Route path="/cadastro/sucesso" element={<CadastroSucesso />} />
      <Route path="/recuperar-senha" element={<RecuperarSenha />} />
      <Route path="/redefinir-senha" element={<RecuperarSenha />} />

      {/* ─────────────────────────────────────────────────────────────
          PÚBLICAS — acessíveis ao Visitante (Guest). Cada página aplica
          "bloqueios inteligentes" (diálogo de autenticação) nas acções
          reservadas a membros.
         ───────────────────────────────────────────────────────────── */}

      {/* Landing / Home pública */}
      <Route path="/home-publica" element={<HomeLanding />} />
      <Route path="/home-landing" element={<HomeLanding />} />
      <Route path="/home" element={<HomeLanding />} />

      {/* Conteúdos — lista, pesquisa e filtros (abrir exige conta) */}
      <Route path="/explorar" element={<Explorar />} />
      <Route path="/explorar-arquivo" element={<Explorar />} />
      <Route path="/pesquisa" element={<ResultadosPesquisa />} />
      <Route path="/conteudos/provincia" element={<ConteudosProvincia />} />

      {/* Fóruns — ver fóruns, tópicos e respostas (participar exige conta) */}
      <Route path="/forum" element={<Forum />} />
      <Route path="/forum/detalhe" element={<ForumDetalhe />} />

      {/* Quizzes — ver lista e detalhes (começar exige conta) */}
      <Route path="/quiz" element={<QuizHub />} />

      {/* Referência e apresentação */}
      <Route path="/guia-rapido" element={<GuiaRapido />} />
      <Route path="/guia-investigacao" element={<GuiaInvestigacao />} />
      <Route path="/mapa" element={<MapaInterativo />} />
      <Route path="/mapa/caminhos-ferro" element={<MapaCaminhosHist />} />
      <Route path="/ajuda" element={<CentroAjuda />} />

      {/* ─────────────────────────────────────────────────────────────
          PROTEGIDAS — exigem autenticação.
         ───────────────────────────────────────────────────────────── */}
      <Route path="/dashboard" element={<Protected><Dashboard /></Protected>} />

      {/* Fórum — acções */}
      <Route path="/forum/novo-topico" element={<Protected><SubmeterTopico /></Protected>} />

      {/* Perfil */}
      <Route path="/perfil" element={<Protected><Perfil /></Protected>} />

      {/* Quiz — realização */}
      <Route path="/quiz/em-curso" element={<Protected><QuizEmCurso /></Protected>} />
      <Route path="/quiz/resultado" element={<Protected><ResultadoQuiz /></Protected>} />

      {/* Leitura / media (conteúdo completo) */}
      <Route path="/leitura/microtexto" element={<Protected><LeituraMicrotexto /></Protected>} />
      <Route path="/leitura/jindungo" element={<Protected><LeituraJindungo /></Protected>} />
      <Route path="/aula-video" element={<Protected><AulaVideo /></Protected>} />
      <Route path="/documento/detalhe" element={<Protected><DetalheDocumento /></Protected>} />

      {/* Biblioteca pessoal */}
      <Route path="/biblioteca" element={<Protected><MinhasBiblioteca /></Protected>} />
      <Route path="/favoritos" element={<Protected><MeusFavoritos /></Protected>} />

      {/* Estatísticas pessoais */}
      <Route path="/estatisticas" element={<Protected><PainelEstatisticas /></Protected>} />

      {/* Management (permission-gated) */}
      <Route path="/gestao/conteudos" element={
        <PermProtected permissions={['CONTENT_CREATE', 'CONTENT_APPROVE', 'CONTENT_PUBLISH', 'CONTENT_DELETE']}>
          <PainelGestaoConteudos />
        </PermProtected>
      } />
      <Route path="/gestao/utilizadores" element={
        <PermProtected permissions={['USER_MANAGE']}>
          <GestaoUtilizadores />
        </PermProtected>
      } />
      <Route path="/gestao/submeter-artigo" element={
        <PermProtected permissions={['CONTENT_CREATE']}>
          <SubmeterArtigo />
        </PermProtected>
      } />
      <Route path="/gestao/quizzes/novo" element={
        <PermProtected permissions={['QUIZ_MANAGE']}>
          <CriarQuiz />
        </PermProtected>
      } />

      {/* Confirmações */}
      <Route path="/confirmacao/publicacao" element={<Protected><ConfirmacaoPublicacao /></Protected>} />
      <Route path="/confirmacao/saida" element={<Protected><ConfirmacaoSaida /></Protected>} />

      {/* Notificações */}
      <Route path="/notificacoes" element={<Protected><Notificacoes /></Protected>} />

      {/* Catch-all */}
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  )
}
