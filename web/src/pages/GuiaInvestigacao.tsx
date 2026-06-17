import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const sections = [
  {
    icon: 'search',
    title: 'Como Pesquisar',
    desc: 'Use a barra de pesquisa no topo para encontrar artigos, documentos e termos do glossário. Pode pesquisar por palavras-chave, períodos históricos ou setores económicos.',
    tip: 'Tente pesquisar "diamante", "café" ou "kwanza"',
  },
  {
    icon: 'filter_list',
    title: 'Filtrar por Categoria',
    desc: 'Na página Explorar, use os filtros de categoria (Microtextos, Jindungo, Arquivo) para encontrar o tipo de conteúdo que precisa.',
    tip: 'Os Textos Jindungo são análises mais profundas e detalhadas',
  },
  {
    icon: 'map',
    title: 'Usar o Mapa Económico',
    desc: 'O Mapa permite visualizar dados por província e por período histórico. Clique numa província para ver todos os conteúdos relacionados.',
    tip: 'Mude o período histórico para ver como a economia evoluiu',
  },
  {
    icon: 'bookmark',
    title: 'Guardar Conteúdos',
    desc: 'Clique no ícone de marcador em qualquer artigo para o adicionar aos seus Favoritos. Pode aceder a todos os guardados no seu Perfil.',
    tip: 'Use os Favoritos para criar uma lista de leitura personalizada',
  },
  {
    icon: 'forum',
    title: 'Participar no Fórum',
    desc: 'No Fórum pode iniciar discussões, responder a tópicos e partilhar documentos históricos com a comunidade de investigadores.',
    tip: 'As respostas mais votadas ganham destaque e pontos extra',
  },
  {
    icon: 'quiz',
    title: 'Testar Conhecimentos',
    desc: 'Os Quizzes estão organizados por nível (Iniciante, Intermédio, Especialista) e por tema. Complete-os para ganhar pontos de mérito.',
    tip: 'O Quiz da Semana tem pontuação dupla',
  },
]

export default function GuiaInvestigacao() {
  const navigate = useNavigate()

  return (
    <AppShell title="Guia de Investigação" showSearch={false}>
      <div className="px-10 py-8 max-w-[900px] mx-auto">
        <div className="mb-10">
          <h2 className="text-[40px] font-extrabold text-[#1c1b1b] mb-3">Guia de Investigação</h2>
          <p className="text-lg text-[#5d5f5d] max-w-2xl" style={{ fontFamily: 'Merriweather, serif' }}>
            Aprenda a tirar o máximo partido da plataforma Economia com História para as suas investigações.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-10">
          {sections.map((s) => (
            <div key={s.title} className="bg-white rounded-xl p-6 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)]">
              <div className="flex items-center gap-3 mb-4">
                <div className="w-10 h-10 bg-[#8B1A1A]/10 rounded-xl flex items-center justify-center">
                  <span className="material-symbols-outlined text-[#8B1A1A]">{s.icon}</span>
                </div>
                <h3 className="text-xl font-bold text-[#1c1b1b]">{s.title}</h3>
              </div>
              <p className="text-sm text-[#5d5f5d] leading-relaxed mb-3" style={{ fontFamily: 'Merriweather, serif' }}>{s.desc}</p>
              <div className="bg-[#8B1A1A]/5 border border-[#8B1A1A]/10 rounded-lg px-3 py-2">
                <p className="text-xs text-[#8B1A1A] flex items-start gap-2">
                  <span className="material-symbols-outlined text-[14px] mt-0.5 flex-shrink-0">lightbulb</span>
                  {s.tip}
                </p>
              </div>
            </div>
          ))}
        </div>

        {/* Methodology section */}
        <div className="bg-white rounded-xl p-8 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] mb-6">
          <h3 className="text-2xl font-bold text-[#1c1b1b] mb-4">Metodologia Editorial</h3>
          <p className="text-base text-[#5d5f5d] leading-relaxed mb-4" style={{ fontFamily: 'Merriweather, serif' }}>
            Todo o conteúdo da plataforma passa por um rigoroso processo de verificação factual. Os nossos artigos são escritos por especialistas e revistos por historiadores económicos antes de serem publicados.
          </p>
          <div className="grid grid-cols-3 gap-4">
            {[
              { icon: 'verified', label: 'Verificado', desc: 'Todas as fontes são verificadas' },
              { icon: 'groups', label: 'Revisto', desc: 'Por especialistas da área' },
              { icon: 'history_edu', label: 'Arquivado', desc: 'Referências primárias citadas' },
            ].map((item) => (
              <div key={item.label} className="text-center p-4 bg-[#f6f3f2] rounded-xl">
                <span className="material-symbols-outlined text-[#8B1A1A] text-3xl mb-2" style={{ fontVariationSettings: "'FILL' 1" }}>{item.icon}</span>
                <p className="text-sm font-bold text-[#1c1b1b]">{item.label}</p>
                <p className="text-xs text-[#5d5f5d]">{item.desc}</p>
              </div>
            ))}
          </div>
        </div>

        <div className="flex gap-4">
          <button onClick={() => navigate('/explorar')}
            className="flex items-center gap-2 bg-[#8B1A1A] text-white px-6 py-3 rounded-full text-sm font-semibold hover:opacity-90 transition-all">
            <span className="material-symbols-outlined text-[18px]">explore</span>
            Começar a Explorar
          </button>
          <button onClick={() => navigate('/ajuda')}
            className="flex items-center gap-2 border border-[#e0bfbc] text-[#1c1b1b] px-6 py-3 rounded-full text-sm font-semibold hover:bg-[#f6f3f2] transition-all">
            <span className="material-symbols-outlined text-[18px]">help</span>
            Centro de Ajuda
          </button>
        </div>
      </div>
    </AppShell>
  )
}
