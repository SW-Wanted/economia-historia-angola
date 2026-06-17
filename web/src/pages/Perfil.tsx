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
      <div className="px-10 py-8 max-w-[1160px] mx-auto space-y-8">
        {/* Hero */}
        <section className="bg-white p-8 rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.04)] flex flex-col md:flex-row gap-8 items-start border border-[#e0bfbc]/30">
          <div className="relative">
            <div className="w-32 h-32 rounded-2xl bg-[#eae7e7] border-4 border-white shadow-sm flex items-center justify-center">
              <span className="material-symbols-outlined text-[#8B1A1A]/30" style={{ fontSize: '60px' }}>person</span>
            </div>
            <div className="absolute -bottom-2 -right-2 bg-[#8B1A1A] text-white p-2 rounded-full shadow-lg">
              <span className="material-symbols-outlined text-sm" style={{ fontVariationSettings: "'FILL' 1" }}>verified</span>
            </div>
          </div>
          <div className="flex-1 space-y-3">
            <div className="flex items-center gap-4 flex-wrap">
              <h1 className="text-[32px] font-bold text-[#1c1b1b]">Carlos Tchípia</h1>
              <span className="bg-[#ffdad6] text-[#8B1A1A] px-3 py-1 rounded-full text-xs font-semibold">Investigador Sénior</span>
            </div>
            <p className="text-lg text-[#5d5f5d] max-w-2xl" style={{ fontFamily: 'Merriweather, serif' }}>
              Especialista em História Económica de Angola do século XIX, focado nas rotas comerciais transatlânticas e na evolução das moedas locais.
            </p>
            <div className="flex flex-wrap gap-6 pt-2">
              <div className="flex items-center gap-2 text-[#5d5f5d]">
                <span className="material-symbols-outlined text-sm">calendar_today</span>
                <span className="text-sm">Membro desde Outubro 2023</span>
              </div>
              <div className="flex items-center gap-2 text-[#5d5f5d]">
                <span className="material-symbols-outlined text-sm">location_on</span>
                <span className="text-sm">Luanda, Angola</span>
              </div>
            </div>
          </div>
          <button
            onClick={() => navigate('/perfil')}
            className="bg-[#8B1A1A] text-white px-6 py-2 rounded-full text-sm font-semibold hover:opacity-90 active:scale-95 transition-all"
          >
            Editar Perfil
          </button>
        </section>

        {/* Stats */}
        <section className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {[
            { icon: 'menu_book', value: '142', label: 'Artigos Lidos', route: '/explorar' },
            { icon: 'cloud_upload', value: '28', label: 'Contribuições ao Arquivo', route: '/gestao/submeter-artigo' },
            { icon: 'workspace_premium', value: '12', label: 'Medalhas Desbloqueadas', route: null },
          ].map((stat) => (
            <button
              key={stat.label}
              onClick={() => stat.route && navigate(stat.route)}
              className={`bg-white p-4 rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.04)] border border-[#e0bfbc]/30 text-center ${stat.route ? 'hover:-translate-y-1 transition-transform cursor-pointer' : ''}`}
            >
              <span className="material-symbols-outlined text-[#8B1A1A] mb-2 text-3xl">{stat.icon}</span>
              <h3 className="text-[48px] font-extrabold text-[#1c1b1b]">{stat.value}</h3>
              <p className="text-sm font-semibold text-[#5d5f5d]">{stat.label}</p>
            </button>
          ))}
        </section>

        {/* Tabs */}
        <div className="border-b border-[#e0bfbc]">
          <div className="flex gap-8">
            {tabs.map((tab) => (
              <button
                key={tab}
                onClick={() => setActiveTab(tab)}
                className={`pb-4 text-sm font-semibold transition-colors border-b-2 -mb-px ${
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
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {readings.map((r) => (
              <div
                key={r.title}
                onClick={() => navigate('/leitura/microtexto')}
                className="bg-white rounded-xl overflow-hidden shadow-[0px_4px_20px_rgba(0,0,0,0.04)] border border-[#e0bfbc]/30 hover:-translate-y-1 transition-transform group cursor-pointer"
              >
                <div className="h-40 bg-[#eae7e7] flex items-center justify-center">
                  <span className="material-symbols-outlined text-[#8B1A1A]/20 group-hover:scale-105 transition-transform" style={{ fontSize: '80px' }}>history_edu</span>
                </div>
                <div className="p-4 space-y-2">
                  <span className="bg-[#f0eded] text-[#5d5f5d] px-2 py-0.5 rounded text-xs font-semibold uppercase tracking-wider">{r.category}</span>
                  <h4 className="text-xl font-semibold text-[#1c1b1b] line-clamp-2">{r.title}</h4>
                  <div className="w-full bg-[#eae7e7] h-1.5 rounded-full overflow-hidden">
                    <div className="bg-[#8B1A1A] h-full" style={{ width: `${r.progress}%` }} />
                  </div>
                  <div className="flex justify-between items-center text-[#5d5f5d] text-xs">
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
                className={`aspect-square rounded-full flex items-center justify-center group relative cursor-help ${
                  badge.unlocked ? 'bg-[#8B1A1A]/10' : 'bg-[#f0eded] grayscale opacity-40'
                }`}
              >
                <span
                  className={`material-symbols-outlined text-3xl ${badge.unlocked ? 'text-[#8B1A1A]' : 'text-[#5d5f5d]'}`}
                  style={badge.unlocked ? { fontVariationSettings: "'FILL' 1" } : undefined}
                >
                  {badge.icon}
                </span>
                <div className="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 w-32 bg-[#313030] text-white text-[10px] p-2 rounded opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none z-10 text-center">
                  {badge.label}
                </div>
              </div>
            ))}
          </div>
        )}

        {activeTab === 'Contribuições' && (
          <div className="bg-white rounded-xl p-8 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] text-center">
            <span className="material-symbols-outlined text-[#8B1A1A]/30 mb-4" style={{ fontSize: '80px' }}>cloud_upload</span>
            <h3 className="text-2xl font-bold text-[#1c1b1b] mb-2">28 Contribuições</h3>
            <p className="text-base text-[#5d5f5d] mb-6" style={{ fontFamily: 'Merriweather, serif' }}>Documentos históricos submetidos ao arquivo digital.</p>
            <button
              onClick={() => navigate('/gestao/submeter-artigo')}
              className="bg-[#8B1A1A] text-white px-8 py-3 rounded-full text-sm font-semibold hover:opacity-90 transition-all"
            >
              Submeter Novo Documento
            </button>
          </div>
        )}

        {activeTab === 'Atividade' && (
          <div className="bg-white rounded-xl p-8 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] space-y-6">
            {[
              { icon: 'chat_bubble', text: 'Respondeu ao tópico "O impacto do café no Huambo"', time: 'Há 2 horas', route: '/forum/detalhe' },
              { icon: 'thumb_up', text: 'Recebeu 15 votos positivos no seu ensaio sobre o Zimbo', time: 'Ontem', route: '/forum' },
              { icon: 'edit_note', text: 'Iniciou novo tópico: "Fontes primárias para o século XVIII"', time: 'Há 3 dias', route: '/forum/detalhe' },
              { icon: 'workspace_premium', text: 'Desbloqueou medalha "Leitor Voraz"', time: 'Há 1 semana', route: null },
            ].map((a) => (
              <div
                key={a.text}
                onClick={() => a.route && navigate(a.route)}
                className={`flex gap-4 ${a.route ? 'cursor-pointer hover:bg-[#f6f3f2] rounded-lg p-2 -mx-2 transition-colors' : ''}`}
              >
                <div className="mt-1">
                  <span className="material-symbols-outlined text-[#8B1A1A] text-sm" style={{ fontVariationSettings: "'FILL' 1" }}>{a.icon}</span>
                </div>
                <div>
                  <p className="text-sm font-semibold text-[#1c1b1b]">{a.text}</p>
                  <span className="text-xs text-[#5d5f5d]">{a.time}</span>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </AppShell>
  )
}
