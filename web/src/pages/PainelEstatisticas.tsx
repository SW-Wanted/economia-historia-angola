import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { userService } from '../services/api/user.service'
import type { Progress } from '../services/types/api.types'

const tabs = ['Visão Geral', 'Leituras', 'Quizzes', 'Comunidade']

const TYPE_LABELS: Record<string, string> = {
  VIDEO: 'Vídeo', PODCAST: 'Podcast', TEXT: 'Texto',
  MICROTEXT: 'Microtexto', PDF: 'Documento', ARTICLE: 'Jindungo', AUDIO: 'Áudio',
}

function getContentRoute(type: string): string {
  if (type === 'VIDEO' || type === 'AUDIO' || type === 'PODCAST') return '/aula-video'
  if (type === 'PDF') return '/documento/detalhe'
  if (type === 'ARTICLE') return '/leitura/jindungo'
  return '/leitura/microtexto'
}

export default function PainelEstatisticas() {
  const navigate = useNavigate()
  const [activeTab, setActiveTab] = useState('Visão Geral')
  const [progress, setProgress] = useState<Progress[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    userService.getMyProgress()
      .then((data) => setProgress(Array.isArray(data) ? data : []))
      .catch(() => setProgress([]))
      .finally(() => setLoading(false))
  }, [])

  const completed = progress.filter((p) => p.completedAt || p.percentage === 100)
  const inProgress = progress.filter((p) => !p.completedAt && p.percentage > 0 && p.percentage < 100)

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
            {/* Stats */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-5 mb-8">
              {[
                { icon: 'stars', value: '—', label: 'Pontos de Mérito' },
                { icon: 'library_books', value: loading ? '…' : String(completed.length), label: 'Artigos Lidos' },
                { icon: 'quiz', value: '—', label: 'Quizzes Feitos' },
                { icon: 'forum', value: '—', label: 'Contribuições' },
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

            {/* Reading progress */}
            <div className="bg-white rounded-xl p-7 border border-[#ebe5e4] shadow-card mb-5">
              <h3 className="text-base font-bold text-[#1c1b1b] mb-6 font-sans">Leituras em Curso</h3>
              {loading ? (
                <div className="space-y-4">
                  {[0, 1, 2].map((i) => (
                    <div key={i} className="h-10 bg-[#f0eded] rounded-lg animate-pulse" />
                  ))}
                </div>
              ) : inProgress.length === 0 ? (
                <div className="text-center py-6">
                  <span className="material-symbols-outlined text-[#8B1A1A]/20 text-4xl mb-2 block">auto_stories</span>
                  <p className="text-sm text-[#5d5f5d] font-serif">Nenhuma leitura em curso. Explore o arquivo para começar.</p>
                  <button onClick={() => navigate('/explorar')} className="mt-3 text-sm font-semibold text-[#8B1A1A] font-sans hover:underline">
                    Explorar conteúdos →
                  </button>
                </div>
              ) : (
                <div className="space-y-5">
                  {inProgress.slice(0, 5).map((p) => (
                    <div key={p.id}>
                      <div className="flex justify-between items-center mb-1.5">
                        <span className="text-sm font-semibold text-[#1c1b1b] font-sans truncate max-w-[70%]">{p.content.title}</span>
                        <span className="text-xs text-[#8c716e] font-sans flex-shrink-0 ml-2">{TYPE_LABELS[p.content.type] ?? p.content.type}</span>
                      </div>
                      <div className="w-full bg-[#f0eded] h-1.5 rounded-full">
                        <div className="bg-[#8B1A1A] h-1.5 rounded-full transition-all" style={{ width: `${p.percentage}%` }} />
                      </div>
                      <span className="text-xs text-[#8B1A1A] font-semibold font-sans mt-1 block">{p.percentage}%</span>
                    </div>
                  ))}
                </div>
              )}
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
            {loading ? (
              <div className="space-y-3">
                {[0, 1, 2, 3].map((i) => (
                  <div key={i} className="h-20 bg-white border border-[#ebe5e4] rounded-xl animate-pulse" />
                ))}
              </div>
            ) : progress.length === 0 ? (
              <div className="bg-white rounded-xl border border-[#ebe5e4] p-10 text-center">
                <span className="material-symbols-outlined text-[#8B1A1A]/20 text-5xl mb-3 block">library_books</span>
                <p className="text-sm text-[#5d5f5d] font-serif">Ainda não iniciou nenhuma leitura.</p>
                <button onClick={() => navigate('/explorar')} className="mt-4 text-sm font-semibold text-[#8B1A1A] font-sans hover:underline">
                  Explorar conteúdos →
                </button>
              </div>
            ) : (
              <>
                {progress.map((item) => (
                  <div
                    key={item.id}
                    onClick={() => navigate(getContentRoute(item.content.type), { state: { contentId: item.contentId } })}
                    className="bg-white rounded-xl p-4 border border-[#ebe5e4] shadow-card hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 cursor-pointer flex items-center gap-4"
                  >
                    <div className="w-9 h-9 bg-[#fff5f4] rounded-lg flex items-center justify-center flex-shrink-0">
                      <span className="material-symbols-outlined text-[#8B1A1A] text-[18px]">article</span>
                    </div>
                    <div className="flex-grow min-w-0">
                      <div className="flex items-center gap-2 mb-1">
                        <span className="text-[10px] font-bold text-[#8B1A1A] bg-[#fff5f4] px-2 py-0.5 rounded-full font-sans">
                          {TYPE_LABELS[item.content.type] ?? item.content.type}
                        </span>
                      </div>
                      <h4 className="text-sm font-semibold text-[#1c1b1b] font-sans leading-snug truncate">{item.content.title}</h4>
                      <div className="w-full bg-[#f0eded] h-1.5 rounded-full mt-2">
                        <div className="bg-[#8B1A1A] h-1.5 rounded-full" style={{ width: `${item.percentage}%` }} />
                      </div>
                    </div>
                    <span className="text-xs font-bold text-[#8B1A1A] font-sans flex-shrink-0">{item.percentage}%</span>
                  </div>
                ))}
                <button
                  onClick={() => navigate('/biblioteca')}
                  className="w-full py-3 text-sm font-semibold text-[#8B1A1A] hover:text-[#7a1616] transition-colors duration-150 font-sans"
                >
                  Ver toda a biblioteca →
                </button>
              </>
            )}
          </div>
        )}

        {activeTab === 'Quizzes' && (
          <div className="bg-white rounded-xl border border-[#ebe5e4] p-10 text-center">
            <span className="material-symbols-outlined text-[#8B1A1A]/20 text-5xl mb-3 block">quiz</span>
            <p className="text-base font-bold text-[#1c1b1b] mb-1 font-sans">Histórico de Quizzes</p>
            <p className="text-sm text-[#5d5f5d] font-serif mb-5">O histórico detalhado de quizzes estará disponível em breve.</p>
            <button
              onClick={() => navigate('/quiz')}
              className="bg-[#8B1A1A] text-white px-6 py-2.5 rounded-full text-sm font-semibold font-sans hover:bg-[#7a1616] transition-all"
            >
              Fazer um Quiz
            </button>
          </div>
        )}

        {activeTab === 'Comunidade' && (
          <div className="bg-white rounded-xl border border-[#ebe5e4] p-10 text-center">
            <span className="material-symbols-outlined text-[#8B1A1A]/20 text-5xl mb-3 block">forum</span>
            <p className="text-base font-bold text-[#1c1b1b] mb-1 font-sans">Atividade na Comunidade</p>
            <p className="text-sm text-[#5d5f5d] font-serif mb-5">As suas contribuições e atividade no fórum estarão disponíveis em breve.</p>
            <button
              onClick={() => navigate('/forum')}
              className="bg-[#8B1A1A] text-white px-6 py-2.5 rounded-full text-sm font-semibold font-sans hover:bg-[#7a1616] transition-all"
            >
              Ir ao Fórum
            </button>
          </div>
        )}
      </div>
    </AppShell>
  )
}
