import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const tabs = ['Leituras', 'Contribuições', 'Medalhas', 'Atividade']

const badges = [
  { icon: 'auto_stories', label: 'Leitor Voraz: 100 artigos lidos', unlocked: true },
  { icon: 'history_edu', label: 'Arquivista: 10 documentos enviados', unlocked: true },
  { icon: 'stars', label: 'Elite: Top 5% Contribuidores', unlocked: true },
  { icon: 'groups', label: 'Mentor: Ajude 50 novos membros', unlocked: false },
  { icon: 'quiz', label: 'Especialista em Quiz: 20 quizzes', unlocked: false },
  { icon: 'forum', label: 'Debatedor: 50 respostas no fórum', unlocked: false },
]

const readings = [
  { category: 'Microtextos', title: 'A Evolução da Moeda Kwanza: Do Zimbo ao Digital', progress: 75, remaining: '12 min restantes' },
  { category: 'Arquivo', title: 'Tratados de Comércio no Reino do Kongo (1845)', progress: 30, remaining: '45 min restantes' },
  { category: 'Jindungo', title: 'A Geopolítica do Diamante na Lunda Norte', progress: 100, remaining: 'Concluído' },
  { category: 'Microtextos', title: 'O Ciclo do Café e a Transformação do Planalto Central', progress: 60, remaining: '8 min restantes' },
]

export default function Perfil() {
  const navigate = useNavigate()
  const [activeTab, setActiveTab] = useState('Leituras')

  return (
    <AppShell title="Perfil do Investigador" showSearch={false}>
      <div className="px-10 py-10 max-w-[1160px] mx-auto space-y-8">
        {/* Hero */}
        <section className="bg-white p-7 rounded-xl shadow-card flex flex-col md:flex-row gap-7 items-start border border-[#ebe5e4]">
          <div className="relative flex-shrink-0">
            <div className="w-28 h-28 rounded-2xl bg-gradient-to-br from-[#f0eded] to-[#e5e2e1] border-4 border-white shadow-sm flex items-center justify-center">
              <span className="text-3xl font-bold text-[#8B1A1A]/40 font-sans leading-none">CT</span>
            </div>
            <div className="absolute -bottom-2 -right-2 bg-[#8B1A1A] text-white p-1.5 rounded-full shadow-md">
              <span className="material-symbols-outlined text-[14px]" style={{ fontVariationSettings: "'FILL' 1" }}>verified</span>
            </div>
          </div>
          <div className="flex-1 space-y-3 min-w-0">
            <div className="flex items-center gap-3 flex-wrap">
              <h1 className="text-[28px] font-bold text-[#1c1b1b] font-sans tracking-tight">Carlos Tchípia</h1>
              <span className="bg-[#fff5f4] text-[#8B1A1A] px-3 py-1 rounded-full text-xs font-semibold font-sans border border-[#8B1A1A]/15">Investigador Sénior</span>
            </div>
            <p className="text-sm text-[#5d5f5d] max-w-2xl font-serif leading-relaxed">
              Especialista em História Económica de Angola do século XIX, focado nas rotas comerciais transatlânticas e na evolução das moedas locais.
            </p>
            <div className="flex flex-wrap gap-5 pt-1">
              <div className="flex items-center gap-1.5 text-[#8c716e]">
                <span className="material-symbols-outlined text-[16px]">calendar_today</span>
                <span className="text-xs font-sans">Membro desde Outubro 2023</span>
              </div>
              <div className="flex items-center gap-1.5 text-[#8c716e]">
                <span className="material-symbols-outlined text-[16px]">location_on</span>
                <span className="text-xs font-sans">Luanda, Angola</span>
              </div>
            </div>
          </div>
          <button
            onClick={() => navigate('/perfil')}
            className="bg-[#8B1A1A] text-white px-5 py-2.5 rounded-full text-sm font-semibold font-sans hover:bg-[#7a1616] active:scale-[0.98] transition-all duration-150 whitespace-nowrap"
          >
            Editar Perfil
          </button>
        </section>

        {/* Stats */}
        <section className="grid grid-cols-1 md:grid-cols-3 gap-5">
          {[
            { icon: 'menu_book', value: '142', label: 'Artigos Lidos', route: '/explorar' },
            { icon: 'cloud_upload', value: '28', label: 'Contribuições ao Arquivo', route: '/gestao/submeter-artigo' },
            { icon: 'workspace_premium', value: '12', label: 'Medalhas Desbloqueadas', route: null },
          ].map((stat) => (
            <button
              key={stat.label}
              onClick={() => stat.route && navigate(stat.route)}
              className={`bg-white p-6 rounded-xl shadow-card border border-[#ebe5e4] text-center ${stat.route ? 'hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 cursor-pointer' : ''}`}
            >
              <span className="w-10 h-10 rounded-xl bg-[#fff5f4] flex items-center justify-center mx-auto mb-4">
                <span className="material-symbols-outlined text-[#8B1A1A] text-[22px]">{stat.icon}</span>
              </span>
              <h3 className="text-[40px] font-extrabold text-[#1c1b1b] leading-none font-sans mb-1">{stat.value}</h3>
              <p className="text-xs font-semibold text-[#8c716e] uppercase tracking-[0.08em] font-sans">{stat.label}</p>
            </button>
          ))}
        </section>

        {/* Tabs */}
        <div className="border-b border-[#ebe5e4]">
          <div className="flex gap-6">
            {tabs.map((tab) => (
              <button
                key={tab}
                onClick={() => setActiveTab(tab)}
                className={`pb-3.5 text-sm font-semibold font-sans transition-all duration-150 border-b-2 -mb-px ${
                  activeTab === tab
                    ? 'border-[#8B1A1A] text-[#8B1A1A]'
                    : 'border-transparent text-[#5d5f5d] hover:text-[#1c1b1b]'
                }`}
              >
                {tab}
              </button>
            ))}
          </div>
        </div>

        {/* Tab content */}
        {activeTab === 'Leituras' && (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
            {readings.map((r) => (
              <div
                key={r.title}
                onClick={() => navigate('/leitura/microtexto')}
                className="bg-white rounded-xl overflow-hidden shadow-card border border-[#ebe5e4] hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 group cursor-pointer"
              >
                <div className="h-36 bg-gradient-to-br from-[#f0eded] to-[#e5e2e1] flex items-center justify-center">
                  <span className="material-symbols-outlined text-[#8B1A1A]/20 group-hover:scale-105 transition-transform duration-300" style={{ fontSize: '64px' }}>history_edu</span>
                </div>
                <div className="p-4 space-y-2">
                  <span className="bg-[#fff5f4] text-[#8B1A1A] px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-[0.06em] font-sans">{r.category}</span>
                  <h4 className="text-base font-semibold text-[#1c1b1b] line-clamp-2 font-sans leading-snug">{r.title}</h4>
                  <div className="w-full bg-[#f0eded] h-1.5 rounded-full overflow-hidden">
                    <div className="bg-[#8B1A1A] h-full transition-all" style={{ width: `${r.progress}%` }} />
                  </div>
                  <div className="flex justify-between items-center text-[#8c716e] text-xs font-sans">
                    <span>{r.progress}% Concluído</span>
                    <span>{r.remaining}</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}

        {activeTab === 'Medalhas' && (
          <div className="grid grid-cols-3 md:grid-cols-6 gap-4">
            {badges.map((badge) => (
              <div
                key={badge.icon}
                className={`aspect-square rounded-2xl flex items-center justify-center group relative cursor-help ${
                  badge.unlocked ? 'bg-[#fff5f4] border border-[#8B1A1A]/15' : 'bg-[#f8f5f4] border border-[#ebe5e4] grayscale opacity-40'
                }`}
              >
                <span
                  className={`material-symbols-outlined text-3xl ${badge.unlocked ? 'text-[#8B1A1A]' : 'text-[#5d5f5d]'}`}
                  style={badge.unlocked ? { fontVariationSettings: "'FILL' 1" } : undefined}
                >
                  {badge.icon}
                </span>
                <div className="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 w-36 bg-[#2a2929] text-white text-[10px] p-2 rounded-lg opacity-0 group-hover:opacity-100 transition-opacity duration-150 pointer-events-none z-10 text-center leading-snug">
                  {badge.label}
                </div>
              </div>
            ))}
          </div>
        )}

        {activeTab === 'Contribuições' && (
          <div className="bg-white rounded-xl p-8 border border-[#ebe5e4] shadow-card text-center">
            <span className="material-symbols-outlined text-[#8B1A1A]/20 mb-3" style={{ fontSize: '64px' }}>cloud_upload</span>
            <h3 className="text-2xl font-bold text-[#1c1b1b] mb-1.5 font-sans">28 Contribuições</h3>
            <p className="text-sm text-[#5d5f5d] mb-6 font-serif leading-relaxed max-w-sm mx-auto">Documentos históricos submetidos ao arquivo digital.</p>
            <button
              onClick={() => navigate('/gestao/submeter-artigo')}
              className="bg-[#8B1A1A] text-white px-7 py-2.5 rounded-full text-sm font-semibold font-sans hover:bg-[#7a1616] active:scale-[0.98] transition-all duration-150"
            >
              Submeter Novo Documento
            </button>
          </div>
        )}

        {activeTab === 'Atividade' && (
          <div className="bg-white rounded-xl p-6 border border-[#ebe5e4] shadow-card space-y-5">
            {[
              { icon: 'chat_bubble', text: 'Respondeu ao tópico "O impacto do café no Huambo"', time: 'Há 2 horas', route: '/forum/detalhe' },
              { icon: 'thumb_up', text: 'Recebeu 15 votos positivos no seu ensaio sobre o Zimbo', time: 'Ontem', route: '/forum' },
              { icon: 'edit_note', text: 'Iniciou novo tópico: "Fontes primárias para o século XVIII"', time: 'Há 3 dias', route: '/forum/detalhe' },
              { icon: 'workspace_premium', text: 'Desbloqueou medalha "Leitor Voraz"', time: 'Há 1 semana', route: null },
            ].map((a) => (
              <div
                key={a.text}
                onClick={() => a.route && navigate(a.route)}
                className={`flex gap-3 items-start ${a.route ? 'cursor-pointer hover:bg-[#f8f5f4] rounded-lg p-2.5 -mx-2.5 transition-all duration-150' : 'px-2.5'}`}
              >
                <div className="w-7 h-7 rounded-lg bg-[#fff5f4] flex items-center justify-center flex-shrink-0 mt-0.5">
                  <span className="material-symbols-outlined text-[#8B1A1A] text-[15px]" style={{ fontVariationSettings: "'FILL' 1" }}>{a.icon}</span>
                </div>
                <div className="min-w-0">
                  <p className="text-sm font-semibold text-[#1c1b1b] font-sans leading-snug">{a.text}</p>
                  <span className="text-xs text-[#8c716e] font-sans">{a.time}</span>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </AppShell>
  )
}
