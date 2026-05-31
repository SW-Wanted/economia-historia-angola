import { Routes, Route, Navigate } from 'react-router-dom'

// Auth pages
import SplashScreen from '../pages/SplashScreen'
import Login from '../pages/Login'
import LoginMobile from '../pages/LoginMobile'
import Cadastro1 from '../pages/Cadastro1'
import Cadastro1Mobile from '../pages/Cadastro1Mobile'
import Cadastro2 from '../pages/Cadastro2'
import Cadastro3 from '../pages/Cadastro3'
import RecuperarSenha from '../pages/RecuperarSenha'
import Onboarding1 from '../pages/Onboarding1'
import Onboarding1Mobile from '../pages/Onboarding1Mobile'
import Onboarding2 from '../pages/Onboarding2'
import Onboarding3 from '../pages/Onboarding3'
import SplashScreenWeb from '../pages/SplashScreenWeb'

// App pages (with sidebar)
import Dashboard from '../pages/Dashboard'
import HomeLanding from '../pages/HomeLanding'
import HomeLandingAtualizada from '../pages/HomeLandingAtualizada'
import Explorar from '../pages/Explorar'
import ExplorarWeb from '../pages/ExplorarWeb'
import ExplorarArquivoDigital from '../pages/ExplorarArquivoDigital'
import Forum from '../pages/Forum'
import ForumDetalhe from '../pages/ForumDetalhe'
import SubmeterTopico from '../pages/SubmeterTopico'
import Perfil from '../pages/Perfil'
import PerfilWeb from '../pages/PerfilWeb'
import QuizHub from '../pages/QuizHub'
import QuizEmCurso from '../pages/QuizEmCurso'
import QuizEmCurso2 from '../pages/QuizEmCurso2'
import QuizEmCursoMobile from '../pages/QuizEmCursoMobile'
import ResultadoQuiz from '../pages/ResultadoQuiz'
import MapaInterativo from '../pages/MapaInterativo'
import MapaCaminhosHist from '../pages/MapaCaminhosHist'
import LeituraMicrotexto from '../pages/LeituraMicrotexto'
import LeituraMicrotextoWeb from '../pages/LeituraMicrotextoWeb'
import LeituraJindungo from '../pages/LeituraJindungo'
import LeituraJindungoWeb from '../pages/LeituraJindungoWeb'
import JindungoDesbloqueado from '../pages/JindungoDesbloqueado'
import JindungoCorrigida from '../pages/JindungoCorrigida'
import MinhasBiblioteca from '../pages/MinhasBiblioteca'
import MinhasBibliotecaCorrigida from '../pages/MinhasBibliotecaCorrigida'
import MeusFavoritos from '../pages/MeusFavoritos'
import Glossario from '../pages/Glossario'
import GlossarioCorrigida from '../pages/GlossarioCorrigida'
import GuiaRapido from '../pages/GuiaRapido'
import GuiaInvestigacao from '../pages/GuiaInvestigacao'
import PainelEstatisticas from '../pages/PainelEstatisticas'
import PainelEstatisticasMobile from '../pages/PainelEstatisticasMobile'
import PainelEstatisticasCorrigida from '../pages/PainelEstatisticasCorrigida'
import PainelGestaoConteudos from '../pages/PainelGestaoConteudos'
import GestaoUtilizadores from '../pages/GestaoUtilizadores'
import SubmeterArtigo from '../pages/SubmeterArtigo'
import ConfirmacaoPublicacao from '../pages/ConfirmacaoPublicacao'
import ConfirmacaoSaida from '../pages/ConfirmacaoSaida'
import Notificacoes from '../pages/Notificacoes'
import ResultadosPesquisa from '../pages/ResultadosPesquisa'
import ConteudosProvincia from '../pages/ConteudosProvincia'
import PaginaInicialPublica from '../pages/PaginaInicialPublica'
import AulaVideo from '../pages/AulaVideo'
import ComparadorPeriodos from '../pages/ComparadorPeriodos'
import ComparadorPeriodosCorrigida from '../pages/ComparadorPeriodosCorrigida'
import CentroAjuda from '../pages/CentroAjuda'
import DetalheDocumento from '../pages/DetalheDocumento'
import DashboardCorrigida from '../pages/DashboardCorrigida'

export default function AppRoutes() {
  return (
    <Routes>
      {/* Public / Auth routes */}
      <Route path="/" element={<SplashScreen />} />
      <Route path="/splash" element={<SplashScreen />} />
      <Route path="/splash-web" element={<SplashScreenWeb />} />
      <Route path="/login" element={<Login />} />
      <Route path="/login-mobile" element={<LoginMobile />} />
      <Route path="/cadastro" element={<Cadastro1 />} />
      <Route path="/cadastro-mobile" element={<Cadastro1Mobile />} />
      <Route path="/cadastro/2" element={<Cadastro2 />} />
      <Route path="/cadastro/3" element={<Cadastro3 />} />
      <Route path="/recuperar-senha" element={<RecuperarSenha />} />
      <Route path="/onboarding/1" element={<Onboarding1 />} />
      <Route path="/onboarding/1-mobile" element={<Onboarding1Mobile />} />
      <Route path="/onboarding/2" element={<Onboarding2 />} />
      <Route path="/onboarding/3" element={<Onboarding3 />} />
      <Route path="/home-publica" element={<PaginaInicialPublica />} />
      <Route path="/home-landing" element={<HomeLanding />} />

      {/* App pages — no wrapper, each HTML has its own sidebar */}
      <Route path="/dashboard" element={<Dashboard />} />
      <Route path="/dashboard-v2" element={<DashboardCorrigida />} />
      <Route path="/home" element={<HomeLandingAtualizada />} />
      <Route path="/explorar" element={<Explorar />} />
      <Route path="/explorar-web" element={<ExplorarWeb />} />
      <Route path="/explorar-arquivo" element={<ExplorarArquivoDigital />} />
      <Route path="/forum" element={<Forum />} />
      <Route path="/forum/detalhe" element={<ForumDetalhe />} />
      <Route path="/forum/novo-topico" element={<SubmeterTopico />} />
      <Route path="/perfil" element={<Perfil />} />
      <Route path="/perfil-web" element={<PerfilWeb />} />
      <Route path="/quiz" element={<QuizHub />} />
      <Route path="/quiz/em-curso" element={<QuizEmCurso />} />
      <Route path="/quiz/em-curso-2" element={<QuizEmCurso2 />} />
      <Route path="/quiz/em-curso-mobile" element={<QuizEmCursoMobile />} />
      <Route path="/quiz/resultado" element={<ResultadoQuiz />} />
      <Route path="/mapa" element={<MapaInterativo />} />
      <Route path="/mapa/caminhos-ferro" element={<MapaCaminhosHist />} />
      <Route path="/leitura/microtexto" element={<LeituraMicrotexto />} />
      <Route path="/leitura/microtexto-web" element={<LeituraMicrotextoWeb />} />
      <Route path="/leitura/jindungo" element={<LeituraJindungo />} />
      <Route path="/leitura/jindungo-web" element={<LeituraJindungoWeb />} />
      <Route path="/leitura/jindungo-desbloqueado" element={<JindungoDesbloqueado />} />
      <Route path="/leitura/jindungo-corrigida" element={<JindungoCorrigida />} />
      <Route path="/biblioteca" element={<MinhasBiblioteca />} />
      <Route path="/biblioteca-v2" element={<MinhasBibliotecaCorrigida />} />
      <Route path="/favoritos" element={<MeusFavoritos />} />
      <Route path="/glossario" element={<Glossario />} />
      <Route path="/glossario-v2" element={<GlossarioCorrigida />} />
      <Route path="/guia-rapido" element={<GuiaRapido />} />
      <Route path="/guia-investigacao" element={<GuiaInvestigacao />} />
      <Route path="/estatisticas" element={<PainelEstatisticas />} />
      <Route path="/estatisticas-mobile" element={<PainelEstatisticasMobile />} />
      <Route path="/estatisticas-v2" element={<PainelEstatisticasCorrigida />} />
      <Route path="/gestao/conteudos" element={<PainelGestaoConteudos />} />
      <Route path="/gestao/utilizadores" element={<GestaoUtilizadores />} />
      <Route path="/gestao/submeter-artigo" element={<SubmeterArtigo />} />
      <Route path="/confirmacao/publicacao" element={<ConfirmacaoPublicacao />} />
      <Route path="/confirmacao/saida" element={<ConfirmacaoSaida />} />
      <Route path="/notificacoes" element={<Notificacoes />} />
      <Route path="/pesquisa" element={<ResultadosPesquisa />} />
      <Route path="/conteudos/provincia" element={<ConteudosProvincia />} />
      <Route path="/aula-video" element={<AulaVideo />} />
      <Route path="/comparador" element={<ComparadorPeriodos />} />
      <Route path="/comparador-v2" element={<ComparadorPeriodosCorrigida />} />
      <Route path="/ajuda" element={<CentroAjuda />} />
      <Route path="/documento/detalhe" element={<DetalheDocumento />} />

      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  )
}
