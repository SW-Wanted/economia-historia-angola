import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const tabs = ['Visão Geral', 'Leituras', 'Quizzes', 'Comunidade']

export default function PainelEstatisticas() {
  const navigate = useNavigate()
  const [activeTab, setActiveTab] = useState('Visão Geral')

  return (
    <AppShell title="Painel de Estatísticas" showSearch={false}>
      <div className="px-10 py-10 max-w-[1160px] mx-auto">
        <div className="mb-8">
          <h2 className="text-[40px] font-extrabold text-[#1c1b1b] mb-2 font-sans tracking-tight">As Suas Estatísticas</h2>
          <p className="text-sm text-[#5d5f5d] font-serif leading-relaxed">
            Acompanhe o seu progresso e impacto na plataforma.
          </p>
        </div>

        {/* Tabs */}
        <div className="border-b border-[#ebe5e4] mb-8">
          <div className="flex gap-6">
            {tabs.map((tab) => (
              <button
                key={tab}
                onClick={() => setActiveTab(tab)}
                className={`pb-3.5 text-sm font-semibold font-sans transition-all duration-150 border-b-2 -mb-px ${
                  activeTab === tab ? 'border-[#8B1A1A] text-[#8B1A1A]' : 'border-transparent text-[#5d5f5d] hover:text-[#1c1b1b]'
                }`}
              >
                {tab}
              </button>
            ))}
          </div>
        </div>

        {activeTab === 'Visão Geral' && (
          <>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-5 mb-8">
              {[
                { icon: 'stars', value: '1,250', label: 'Pontos de Mérito' },
                { icon: 'library_books', value: '142', label: 'Artigos Lidos' },
                { icon: 'quiz', value: '24', label: 'Quizzes Feitos' },
                { icon: 'forum', value: '38', label: 'Contribuições' },
              ].map((s) => (
                <div key={s.label} className="bg-white rounded-xl p-6 border border-[#ebe5e4] shadow-card text-center">
                  <span className="w-9 h-9 rounded-lg bg-[#fff5f4] flex items-center justify-center mx-auto mb-4">
                    <span className="material-symbols-outlined text-[#8B1A1A] text-[20px]" style={{ fontVariationSettings: "'FILL' 1" }}>{s.icon}</span>
                  </span>
                  <p className="text-[36px] font-extrabold text-[#1c1b1b] leading-none font-sans mb-1">{s.value}</p>
                  <p className="text-[10px] text-[#8c716e] uppercase tracking-[0.08em] font-sans">{s.label}</p>
                </div>
              ))}
            </div>

            <div className="bg-white rounded-xl p-7 border border-[#ebe5e4] shadow-card mb-5">
              <h3 className="text-base font-bold text-[#1c1b1b] mb-6 font-sans">Progresso por Colecção</h3>
              <div className="space-y-5">
                {[
                  { label: 'Era Colonial', progress: 75, articles: '18/24' },
                  { label: 'Pós-Independência', progress: 40, articles: '8/20' },
                  { label: 'Economia Contemporânea', progress: 20, articles: '4/18' },
                  { label: 'Comércio Atlântico', progress: 60, articles: '9/15' },
                ].map((col) => (
                  <div key={col.label}>
                    <div className="flex justify-between items-center mb-1.5">
                      <span className="text-sm font-semibold text-[#1c1b1b] font-sans">{col.label}</span>
                      <span className="text-xs text-[#8c716e] font-sans">{col.articles} artigos</span>
                    </div>
                    <div className="w-full bg-[#f0eded] h-1.5 rounded-full">
                      <div className="bg-[#8B1A1A] h-1.5 rounded-full transition-all" style={{ width: `${col.progress}%` }} />
                    </div>
                    <span className="text-xs text-[#8B1A1A] font-semibold font-sans mt-1 block">{col.progress}%</span>
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
                <button
                  key={a.label}
                  onClick={() => navigate(a.route)}
                  className="bg-white rounded-xl p-5 border border-[#ebe5e4] shadow-card hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 text-left flex items-center gap-4"
                >
                  <div className="w-10 h-10 bg-[#fff5f4] rounded-xl flex items-center justify-center flex-shrink-0">
                    <span className="material-symbols-outlined text-[#8B1A1A] text-[22px]">{a.icon}</span>
                  </div>
                  <div>
                    <p className="text-sm font-bold text-[#1c1b1b] font-sans">{a.label}</p>
                    <p className="text-xs text-[#8c716e] font-sans">{a.desc}</p>
                  </div>
                </button>
              ))}
            </div>
          </>
        )}

        {activeTab === 'Leituras' && (
          <div className="space-y-3">
            {[
              { title: 'A Rota dos Diamantes: Da Exploração Colonial à Independência', category: 'Microtexto', progress: 100, route: '/leitura/microtexto' },
              { title: 'A Geopolítica do Diamante na Lunda Norte', category: 'Jindungo', progress: 75, route: '/leitura/jindungo' },
              { title: 'Tratado de Comércio de 1891', category: 'Arquivo', progress: 100, route: '/documento/detalhe' },
              { title: 'O Ciclo do Café e a Transformação do Planalto Central', category: 'Microtexto', progress: 60, route: '/leitura/microtexto' },
            ].map((r) => (
              <div
                key={r.title}
                onClick={() => navigate(r.route)}
                className="bg-white rounded-xl p-4 border border-[#ebe5e4] shadow-card hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 cursor-pointer flex items-center gap-4"
              >
                <div className="w-9 h-9 bg-[#fff5f4] rounded-lg flex items-center justify-center flex-shrink-0">
                  <span className="material-symbols-outlined text-[#8B1A1A] text-[18px]">article</span>
                </div>
                <div className="flex-grow min-w-0">
                  <div className="flex items-center gap-2 mb-1">
                    <span className="text-[10px] font-bold text-[#8B1A1A] bg-[#fff5f4] px-2 py-0.5 rounded-full font-sans">{r.category}</span>
                  </div>
                  <h4 className="text-sm font-semibold text-[#1c1b1b] font-sans leading-snug truncate">{r.title}</h4>
                  <div className="w-full bg-[#f0eded] h-1.5 rounded-full mt-2">
                    <div className="bg-[#8B1A1A] h-1.5 rounded-full" style={{ width: `${r.progress}%` }} />
                  </div>
                </div>
                <span className="text-xs font-bold text-[#8B1A1A] font-sans flex-shrink-0">{r.progress}%</span>
              </div>
            ))}
            <button
              onClick={() => navigate('/biblioteca')}
              className="w-full py-3 text-sm font-semibold text-[#8B1A1A] hover:text-[#7a1616] transition-colors duration-150 font-sans"
            >
              Ver toda a biblioteca →
            </button>
          </div>
        )}

        {activeTab === 'Quizzes' && (
          <div className="space-y-3">
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
              {[
                { value: '24', label: 'Concluídos' },
                { value: '88%', label: 'Precisão Média' },
                { value: '5', label: 'Temas Dominados' },
                { value: '#12', label: 'Ranking' },
              ].map((s) => (
                <div key={s.label} className="bg-white rounded-xl p-5 border border-[#ebe5e4] shadow-card text-center">
                  <p className="text-[28px] font-extrabold text-[#8B1A1A] leading-none font-sans mb-1">{s.value}</p>
                  <p className="text-[10px] text-[#8c716e] uppercase tracking-[0.08em] font-sans">{s.label}</p>
                </div>
              ))}
            </div>
            {[
              { title: 'A Evolução da Moeda Colonial', score: '88%', date: 'Hoje', route: '/quiz/resultado' },
              { title: 'Fundamentos do Comércio em Luanda', score: '92%', date: '3 dias atrás', route: '/quiz/resultado' },
              { title: 'O Ciclo do Café no Planalto Central', score: '76%', date: '1 semana atrás', route: '/quiz/resultado' },
            ].map((q) => (
              <div
                key={q.title}
                onClick={() => navigate(q.route)}
                className="bg-white rounded-xl p-4 border border-[#ebe5e4] shadow-card hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 cursor-pointer flex items-center gap-4"
              >
                <div className="w-9 h-9 bg-[#8B1A1A] rounded-full flex items-center justify-center flex-shrink-0 text-white font-bold text-xs font-sans">
                  {q.score}
                </div>
                <div className="flex-grow">
                  <h4 className="text-sm font-semibold text-[#1c1b1b] font-sans">{q.title}</h4>
                  <span className="text-xs text-[#8c716e] font-sans">{q.date}</span>
                </div>
                <span className="material-symbols-outlined text-[#c4b5b3] text-[20px]">chevron_right</span>
              </div>
            ))}
            <button
              onClick={() => navigate('/quiz')}
              className="w-full py-3 text-sm font-semibold text-[#8B1A1A] hover:text-[#7a1616] transition-colors duration-150 font-sans"
            >
              Ver todos os quizzes →
            </button>
          </div>
        )}

        {activeTab === 'Comunidade' && (
          <div className="space-y-3">
            <div className="grid grid-cols-3 gap-4 mb-6">
              {[
                { value: '38', label: 'Contribuições' },
                { value: '156', label: 'Votos Recebidos' },
                { value: '12', label: 'Tópicos Criados' },
              ].map((s) => (
                <div key={s.label} className="bg-white rounded-xl p-5 border border-[#ebe5e4] shadow-card text-center">
                  <p className="text-[28px] font-extrabold text-[#8B1A1A] leading-none font-sans mb-1">{s.value}</p>
                  <p className="text-[10px] text-[#8c716e] uppercase tracking-[0.08em] font-sans">{s.label}</p>
                </div>
              ))}
            </div>
            {[
              { icon: 'chat_bubble', text: 'Respondeu ao tópico "O impacto do café no Huambo"', time: 'Há 2 horas', route: '/forum/detalhe' },
              { icon: 'thumb_up', text: 'Recebeu 15 votos positivos no ensaio sobre o Zimbo', time: 'Ontem', route: '/forum' },
              { icon: 'edit_note', text: 'Iniciou novo tópico: "Fontes primárias para o século XVIII"', time: 'Há 3 dias', route: '/forum/detalhe' },
            ].map((a) => (
              <div
                key={a.text}
                onClick={() => navigate(a.route)}
                className="bg-white rounded-xl p-4 border border-[#ebe5e4] shadow-card hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 cursor-pointer flex items-start gap-3.5"
              >
                <div className="w-8 h-8 rounded-lg bg-[#fff5f4] flex items-center justify-center flex-shrink-0 mt-0.5">
                  <span className="material-symbols-outlined text-[#8B1A1A] text-[16px]" style={{ fontVariationSettings: "'FILL' 1" }}>{a.icon}</span>
                </div>
                <div>
                  <p className="text-sm font-semibold text-[#1c1b1b] font-sans leading-snug">{a.text}</p>
                  <span className="text-xs text-[#8c716e] font-sans">{a.time}</span>
                </div>
              </div>
            ))}
            <button
              onClick={() => navigate('/forum')}
              className="w-full py-3 text-sm font-semibold text-[#8B1A1A] hover:text-[#7a1616] transition-colors duration-150 font-sans"
            >
              Ver fórum →
            </button>
          </div>
        )}
      </div>
    </AppShell>
  )
}
