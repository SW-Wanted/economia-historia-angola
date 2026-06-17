import { Routes, Route, Navigate } from 'react-router-dom'
import ProtectedRoute from '../components/ProtectedRoute'

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

function Protected({ children }: { children: React.ReactNode }) {
  return <ProtectedRoute>{children}</ProtectedRoute>
}

export default function AppRoutes() {
  return (
    <Routes>
      {/* Public — splash & onboarding */}
      <Route path="/" element={<SplashScreen />} />
      <Route path="/splash" element={<SplashScreen />} />
      <Route path="/onboarding/1" element={<Onboarding1 />} />
      <Route path="/onboarding/2" element={<Onboarding2 />} />
      <Route path="/onboarding/3" element={<Onboarding3 />} />

      {/* Public — auth */}
      <Route path="/login" element={<Login />} />
      <Route path="/cadastro" element={<Cadastro1 />} />
      <Route path="/cadastro/2" element={<Cadastro2 />} />
      <Route path="/cadastro/3" element={<Cadastro3 />} />
      <Route path="/recuperar-senha" element={<RecuperarSenha />} />

      {/* Public — landing */}
      <Route path="/home-publica" element={<HomeLanding />} />
      <Route path="/home-landing" element={<HomeLanding />} />
      <Route path="/home" element={<HomeLanding />} />

      {/* Protected — main app */}
      <Route path="/dashboard" element={<Protected><Dashboard /></Protected>} />
      <Route path="/explorar" element={<Protected><Explorar /></Protected>} />
      <Route path="/explorar-arquivo" element={<Protected><Explorar /></Protected>} />

      {/* Protected — forum */}
      <Route path="/forum" element={<Protected><Forum /></Protected>} />
      <Route path="/forum/detalhe" element={<Protected><ForumDetalhe /></Protected>} />
      <Route path="/forum/novo-topico" element={<Protected><SubmeterTopico /></Protected>} />

      {/* Protected — profile */}
      <Route path="/perfil" element={<Protected><Perfil /></Protected>} />

      {/* Protected — quiz */}
      <Route path="/quiz" element={<Protected><QuizHub /></Protected>} />
      <Route path="/quiz/em-curso" element={<Protected><QuizEmCurso /></Protected>} />
      <Route path="/quiz/resultado" element={<Protected><ResultadoQuiz /></Protected>} />

      {/* Protected — map */}
      <Route path="/mapa" element={<Protected><MapaInterativo /></Protected>} />
      <Route path="/mapa/caminhos-ferro" element={<Protected><MapaCaminhosHist /></Protected>} />

      {/* Protected — reading */}
      <Route path="/leitura/microtexto" element={<Protected><LeituraMicrotexto /></Protected>} />
      <Route path="/leitura/jindungo" element={<Protected><LeituraJindungo /></Protected>} />

      {/* Protected — library */}
      <Route path="/biblioteca" element={<Protected><MinhasBiblioteca /></Protected>} />
      <Route path="/favoritos" element={<Protected><MeusFavoritos /></Protected>} />

      {/* Protected — reference */}
      <Route path="/glossario" element={<Protected><Glossario /></Protected>} />
      <Route path="/guia-rapido" element={<Protected><GuiaRapido /></Protected>} />
      <Route path="/guia-investigacao" element={<Protected><GuiaInvestigacao /></Protected>} />
      <Route path="/comparador" element={<Protected><ComparadorPeriodos /></Protected>} />

      {/* Protected — stats */}
      <Route path="/estatisticas" element={<Protected><PainelEstatisticas /></Protected>} />

      {/* Protected — management */}
      <Route path="/gestao/conteudos" element={<Protected><PainelGestaoConteudos /></Protected>} />
      <Route path="/gestao/utilizadores" element={<Protected><GestaoUtilizadores /></Protected>} />
      <Route path="/gestao/submeter-artigo" element={<Protected><SubmeterArtigo /></Protected>} />

      {/* Protected — confirmations */}
      <Route path="/confirmacao/publicacao" element={<Protected><ConfirmacaoPublicacao /></Protected>} />
      <Route path="/confirmacao/saida" element={<Protected><ConfirmacaoSaida /></Protected>} />

      {/* Protected — utility */}
      <Route path="/notificacoes" element={<Protected><Notificacoes /></Protected>} />
      <Route path="/pesquisa" element={<Protected><ResultadosPesquisa /></Protected>} />
      <Route path="/conteudos/provincia" element={<Protected><ConteudosProvincia /></Protected>} />
      <Route path="/aula-video" element={<Protected><AulaVideo /></Protected>} />
      <Route path="/documento/detalhe" element={<Protected><DetalheDocumento /></Protected>} />
      <Route path="/ajuda" element={<CentroAjuda />} />

      {/* Catch-all */}
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  )
}
