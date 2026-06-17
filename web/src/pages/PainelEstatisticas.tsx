import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const tabs = ['Visão Geral', 'Leituras', 'Quizzes', 'Comunidade']

export default function PainelEstatisticas() {
  const navigate = useNavigate()
  const [activeTab, setActiveTab] = useState('Visão Geral')

  return (
    <AppShell title="Painel de Estatísticas" showSearch={false}>
      <div className="px-10 py-8 max-w-[1160px] mx-auto">
        <div className="mb-8">
          <h2 className="text-[40px] font-extrabold text-[#1c1b1b] mb-2">As Suas Estatísticas</h2>
          <p className="text-base text-[#5d5f5d]" style={{ fontFamily: 'Merriweather, serif' }}>
            Acompanhe o seu progresso e impacto na plataforma.
          </p>
        </div>

        {/* Tabs */}
        <div className="border-b border-[#e0bfbc] mb-8">
          <div className="flex gap-8">
            {tabs.map((tab) => (
              <button key={tab} onClick={() => setActiveTab(tab)}
                className={`pb-4 text-sm font-semibold transition-colors border-b-2 -mb-px ${
                  activeTab === tab ? 'border-[#8B1A1A] text-[#8B1A1A]' : 'border-transparent text-[#5d5f5d] hover:text-[#1c1b1b]'
                }`}>
                {tab}
              </button>
            ))}
          </div>
        </div>

        {activeTab === 'Visão Geral' && (
          <>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-6 mb-10">
              {[
                { icon: 'stars', value: '1,250', label: 'Pontos de Mérito', color: 'text-[#8B1A1A]' },
                { icon: 'library_books', value: '142', label: 'Artigos Lidos', color: 'text-[#8B1A1A]' },
                { icon: 'quiz', value: '24', label: 'Quizzes Feitos', color: 'text-[#8B1A1A]' },
                { icon: 'forum', value: '38', label: 'Contribuições', color: 'text-[#8B1A1A]' },
              ].map((s) => (
                <div key={s.label} className="bg-white rounded-xl p-6 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] text-center">
                  <span className={`material-symbols-outlined text-3xl mb-2 ${s.color}`} style={{ fontVariationSettings: "'FILL' 1" }}>{s.icon}</span>
                  <p className="text-[40px] font-extrabold text-[#1c1b1b]">{s.value}</p>
                  <p className="text-xs text-[#5d5f5d] uppercase tracking-wider">{s.label}</p>
                </div>
              ))}
            </div>

            <div className="bg-white rounded-xl p-8 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] mb-6">
              <h3 className="text-xl font-bold text-[#1c1b1b] mb-6">Progresso por Colecção</h3>
              <div className="space-y-5">
                {[
                  { label: 'Era Colonial', progress: 75, articles: '18/24' },
                  { label: 'Pós-Independência', progress: 40, articles: '8/20' },
                  { label: 'Economia Contemporânea', progress: 20, articles: '4/18' },
                  { label: 'Comércio Atlântico', progress: 60, articles: '9/15' },
                ].map((col) => (
                  <div key={col.label}>
                    <div className="flex justify-between items-center mb-2">
                      <span className="text-sm font-semibold text-[#1c1b1b]">{col.label}</span>
                      <span className="text-xs text-[#5d5f5d]">{col.articles} artigos</span>
                    </div>
                    <div className="w-full bg-[#eae7e7] h-2 rounded-full">
                      <div className="bg-[#8B1A1A] h-2 rounded-full transition-all" style={{ width: `${col.progress}%` }} />
                    </div>
                    <span className="text-xs text-[#8B1A1A] font-semibold mt-1 block">{col.progress}%</span>
                  </div>
                ))}
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              {[
                { icon: 'explore', label: 'Continuar a Ler', route: '/explorar', desc: 'Retome onde parou' },
                { icon: 'quiz', label: 'Fazer Quiz', route: '/quiz', desc: 'Teste os seus conhecimentos' },
                { icon: 'forum', label: 'Ver Fórum', route: '/forum', desc: 'Participe nas discussões' },
              ].map((a) => (
                <button key={a.label} onClick={() => navigate(a.route)}
                  className="bg-white rounded-xl p-6 border border-[#e0bfbc] hover:border-[#8B1A1A] hover:shadow-md transition-all text-left flex items-center gap-4">
                  <div className="w-12 h-12 bg-[#8B1A1A]/10 rounded-xl flex items-center justify-center">
                    <span className="material-symbols-outlined text-[#8B1A1A] text-2xl">{a.icon}</span>
                  </div>
                  <div>
                    <p className="text-sm font-bold text-[#1c1b1b]">{a.label}</p>
                    <p className="text-xs text-[#5d5f5d]">{a.desc}</p>
                  </div>
                </button>
              ))}
            </div>
          </>
        )}

        {activeTab === 'Leituras' && (
          <div className="space-y-4">
            {[
              { title: 'A Rota dos Diamantes: Da Exploração Colonial à Independência', category: 'Microtexto', progress: 100, route: '/leitura/microtexto' },
              { title: 'A Geopolítica do Diamante na Lunda Norte', category: 'Jindungo', progress: 75, route: '/leitura/jindungo' },
              { title: 'Tratado de Comércio de 1891', category: 'Arquivo', progress: 100, route: '/documento/detalhe' },
              { title: 'O Ciclo do Café e a Transformação do Planalto Central', category: 'Microtexto', progress: 60, route: '/leitura/microtexto' },
            ].map((r) => (
              <div key={r.title} onClick={() => navigate(r.route)}
                className="bg-white rounded-xl p-5 border border-[#e0bfbc] hover:border-[#8B1A1A] hover:shadow-md transition-all cursor-pointer flex items-center gap-5">
                <div className="w-10 h-10 bg-[#8B1A1A]/10 rounded-lg flex items-center justify-center flex-shrink-0">
                  <span className="material-symbols-outlined text-[#8B1A1A] text-sm">article</span>
                </div>
                <div className="flex-grow">
                  <div className="flex items-center gap-2 mb-1">
                    <span className="text-xs font-semibold text-[#8B1A1A] bg-[#8B1A1A]/10 px-2 py-0.5 rounded-full">{r.category}</span>
                  </div>
                  <h4 className="text-sm font-semibold text-[#1c1b1b]">{r.title}</h4>
                  <div className="w-full bg-[#eae7e7] h-1 rounded-full mt-2">
                    <div className="bg-[#8B1A1A] h-1 rounded-full" style={{ width: `${r.progress}%` }} />
                  </div>
                </div>
                <span className="text-xs font-bold text-[#8B1A1A]">{r.progress}%</span>
              </div>
            ))}
            <button onClick={() => navigate('/biblioteca')}
              className="w-full py-3 text-sm font-semibold text-[#8B1A1A] hover:underline">
              Ver toda a biblioteca →
            </button>
          </div>
        )}

        {activeTab === 'Quizzes' && (
          <div className="space-y-4">
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
              {[
                { value: '24', label: 'Concluídos' },
                { value: '88%', label: 'Precisão Média' },
                { value: '5', label: 'Temas Dominados' },
                { value: '#12', label: 'Ranking' },
              ].map((s) => (
                <div key={s.label} className="bg-white rounded-xl p-5 border border-[#e0bfbc] text-center shadow-[0px_4px_20px_rgba(0,0,0,0.04)]">
                  <p className="text-[32px] font-extrabold text-[#8B1A1A]">{s.value}</p>
                  <p className="text-xs text-[#5d5f5d] uppercase tracking-wider">{s.label}</p>
                </div>
              ))}
            </div>
            {[
              { title: 'A Evolução da Moeda Colonial', score: '88%', date: 'Hoje', route: '/quiz/resultado' },
              { title: 'Fundamentos do Comércio em Luanda', score: '92%', date: '3 dias atrás', route: '/quiz/resultado' },
              { title: 'O Ciclo do Café no Planalto Central', score: '76%', date: '1 semana atrás', route: '/quiz/resultado' },
            ].map((q) => (
              <div key={q.title} onClick={() => navigate(q.route)}
                className="bg-white rounded-xl p-5 border border-[#e0bfbc] hover:border-[#8B1A1A] hover:shadow-md transition-all cursor-pointer flex items-center gap-5">
                <div className="w-10 h-10 bg-[#8B1A1A] rounded-full flex items-center justify-center flex-shrink-0 text-white font-bold text-sm">
                  {q.score}
                </div>
                <div className="flex-grow">
                  <h4 className="text-sm font-semibold text-[#1c1b1b]">{q.title}</h4>
                  <span className="text-xs text-[#5d5f5d]">{q.date}</span>
                </div>
                <span className="material-symbols-outlined text-[#5d5f5d]">chevron_right</span>
              </div>
            ))}
            <button onClick={() => navigate('/quiz')}
              className="w-full py-3 text-sm font-semibold text-[#8B1A1A] hover:underline">
              Ver todos os quizzes →
            </button>
          </div>
        )}

        {activeTab === 'Comunidade' && (
          <div className="space-y-4">
            <div className="grid grid-cols-3 gap-4 mb-6">
              {[
                { value: '38', label: 'Contribuições' },
                { value: '156', label: 'Votos Recebidos' },
                { value: '12', label: 'Tópicos Criados' },
              ].map((s) => (
                <div key={s.label} className="bg-white rounded-xl p-5 border border-[#e0bfbc] text-center shadow-[0px_4px_20px_rgba(0,0,0,0.04)]">
                  <p className="text-[32px] font-extrabold text-[#8B1A1A]">{s.value}</p>
                  <p className="text-xs text-[#5d5f5d] uppercase tracking-wider">{s.label}</p>
                </div>
              ))}
            </div>
            {[
              { icon: 'chat_bubble', text: 'Respondeu ao tópico "O impacto do café no Huambo"', time: 'Há 2 horas', route: '/forum/detalhe' },
              { icon: 'thumb_up', text: 'Recebeu 15 votos positivos no ensaio sobre o Zimbo', time: 'Ontem', route: '/forum' },
              { icon: 'edit_note', text: 'Iniciou novo tópico: "Fontes primárias para o século XVIII"', time: 'Há 3 dias', route: '/forum/detalhe' },
            ].map((a) => (
              <div key={a.text} onClick={() => navigate(a.route)}
                className="bg-white rounded-xl p-5 border border-[#e0bfbc] hover:border-[#8B1A1A] hover:shadow-md transition-all cursor-pointer flex items-start gap-4">
                <span className="material-symbols-outlined text-[#8B1A1A] mt-0.5" style={{ fontVariationSettings: "'FILL' 1" }}>{a.icon}</span>
                <div>
                  <p className="text-sm font-semibold text-[#1c1b1b]">{a.text}</p>
                  <span className="text-xs text-[#5d5f5d]">{a.time}</span>
                </div>
              </div>
            ))}
            <button onClick={() => navigate('/forum')}
              className="w-full py-3 text-sm font-semibold text-[#8B1A1A] hover:underline">
              Ver fórum →
            </button>
          </div>
        )}
      </div>
    </AppShell>
  )
}
