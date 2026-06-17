import { Routes, Route, Navigate } from 'react-router-dom'

// Auth / Public
import SplashScreen from '../pages/SplashScreen'
import Login from '../pages/Login'
import Cadastro1 from '../pages/Cadastro1'
import Cadastro2 from '../pages/Cadastro2'
import Cadastro3 from '../pages/Cadastro3'
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
import MapaInterativo from '../pages/MapaInterativo'
import MapaCaminhosHist from '../pages/MapaCaminhosHist'
import LeituraMicrotexto from '../pages/LeituraMicrotexto'
import LeituraJindungo from '../pages/LeituraJindungo'
import MinhasBiblioteca from '../pages/MinhasBiblioteca'
import MeusFavoritos from '../pages/MeusFavoritos'
import Glossario from '../pages/Glossario'
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
import ComparadorPeriodos from '../pages/ComparadorPeriodos'
import DetalheDocumento from '../pages/DetalheDocumento'
import CentroAjuda from '../pages/CentroAjuda'

export default function AppRoutes() {
  return (
    <Routes>
      {/* Splash → auto-redirects to /onboarding/1 */}
      <Route path="/" element={<SplashScreen />} />
      <Route path="/splash" element={<SplashScreen />} />

      {/* Onboarding */}
      <Route path="/onboarding/1" element={<Onboarding1 />} />
      <Route path="/onboarding/2" element={<Onboarding2 />} />
      <Route path="/onboarding/3" element={<Onboarding3 />} />

      {/* Auth */}
      <Route path="/login" element={<Login />} />
      <Route path="/cadastro" element={<Cadastro1 />} />
      <Route path="/cadastro/2" element={<Cadastro2 />} />
      <Route path="/cadastro/3" element={<Cadastro3 />} />
      <Route path="/recuperar-senha" element={<RecuperarSenha />} />

      {/* Public landing */}
      <Route path="/home-publica" element={<HomeLanding />} />
      <Route path="/home-landing" element={<HomeLanding />} />
      <Route path="/home" element={<HomeLanding />} />

      {/* Main app */}
      <Route path="/dashboard" element={<Dashboard />} />
      <Route path="/explorar" element={<Explorar />} />
      <Route path="/explorar-arquivo" element={<Explorar />} />

      {/* Forum */}
      <Route path="/forum" element={<Forum />} />
      <Route path="/forum/detalhe" element={<ForumDetalhe />} />
      <Route path="/forum/novo-topico" element={<SubmeterTopico />} />

      {/* Profile */}
      <Route path="/perfil" element={<Perfil />} />

      {/* Quiz */}
      <Route path="/quiz" element={<QuizHub />} />
      <Route path="/quiz/em-curso" element={<QuizEmCurso />} />
      <Route path="/quiz/resultado" element={<ResultadoQuiz />} />

      {/* Map */}
      <Route path="/mapa" element={<MapaInterativo />} />
      <Route path="/mapa/caminhos-ferro" element={<MapaCaminhosHist />} />

      {/* Reading */}
      <Route path="/leitura/microtexto" element={<LeituraMicrotexto />} />
      <Route path="/leitura/jindungo" element={<LeituraJindungo />} />

      {/* Library & Favorites */}
      <Route path="/biblioteca" element={<MinhasBiblioteca />} />
      <Route path="/favoritos" element={<MeusFavoritos />} />

      {/* Reference */}
      <Route path="/glossario" element={<Glossario />} />
      <Route path="/guia-rapido" element={<GuiaRapido />} />
      <Route path="/guia-investigacao" element={<GuiaInvestigacao />} />
      <Route path="/comparador" element={<ComparadorPeriodos />} />

      {/* Stats */}
      <Route path="/estatisticas" element={<PainelEstatisticas />} />

      {/* Management */}
      <Route path="/gestao/conteudos" element={<PainelGestaoConteudos />} />
      <Route path="/gestao/utilizadores" element={<GestaoUtilizadores />} />
      <Route path="/gestao/submeter-artigo" element={<SubmeterArtigo />} />

      {/* Confirmations */}
      <Route path="/confirmacao/publicacao" element={<ConfirmacaoPublicacao />} />
      <Route path="/confirmacao/saida" element={<ConfirmacaoSaida />} />

      {/* Utility */}
      <Route path="/notificacoes" element={<Notificacoes />} />
      <Route path="/pesquisa" element={<ResultadosPesquisa />} />
      <Route path="/conteudos/provincia" element={<ConteudosProvincia />} />
      <Route path="/aula-video" element={<AulaVideo />} />
      <Route path="/documento/detalhe" element={<DetalheDocumento />} />
      <Route path="/ajuda" element={<CentroAjuda />} />

      {/* Catch-all */}
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  )
}
