import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const quizzes = [
  { title: 'Fundamentos do Comércio em Luanda', desc: 'Conheça as primeiras rotas comerciais e os principais produtos de exportação do século XVIII.', level: 'Iniciante', levelColor: 'bg-emerald-50 text-emerald-700 border border-emerald-200', questions: 10 },
  { title: 'O Ciclo do Café no Planalto Central', desc: 'Identifique os fatores que tornaram Angola o terceiro maior produtor mundial de café.', level: 'Intermédio', levelColor: 'bg-amber-50 text-amber-700 border border-amber-200', questions: 8 },
  { title: 'História Bancária e do BNA', desc: 'Desde a fundação do Banco Nacional de Angola até à modernização do sistema financeiro.', level: 'Intermédio', levelColor: 'bg-amber-50 text-amber-700 border border-amber-200', questions: 12 },
  { title: 'Macroeconomia da Transição (1975–1980)', desc: 'Analise os desafios da transição para uma economia planificada nos primeiros anos da República.', level: 'Especialista', levelColor: 'bg-red-50 text-red-700 border border-red-200', questions: 15 },
]

const filters = ['Todos', 'Colonialismo', 'Pós-Independência', 'Comércio Atlântico']

export default function QuizHub() {
  const navigate = useNavigate()
  const [activeFilter, setActiveFilter] = useState('Todos')

  return (
    <AppShell searchPlaceholder="Pesquisar arquivo histórico...">
      <div className="px-10 py-10 max-w-[1160px] mx-auto">
        {/* Featured banner */}
        <section className="relative bg-[#8b1a1a] rounded-2xl overflow-hidden mb-12 flex items-center min-h-[340px] shadow-lg">
          <div className="w-full md:w-1/2 p-10 relative z-10">
            <span className="inline-block bg-white/15 text-white/90 px-4 py-1 rounded-full text-[10px] font-bold font-sans mb-5 uppercase tracking-[0.1em] border border-white/20">
              Quiz da Semana
            </span>
            <h2 className="text-[36px] font-extrabold text-white mb-4 leading-tight font-sans tracking-tight">A Evolução da Moeda Colonial no Século XIX</h2>
            <p className="text-sm text-white/80 mb-7 max-w-md font-serif leading-relaxed">
              "Entender o passado comercial de Angola através dos seus símbolos de troca e valor."
            </p>
            <div className="flex items-center gap-5">
              <button
                onClick={() => navigate('/quiz/em-curso')}
                className="bg-white text-[#8B1A1A] px-7 py-3 rounded-full text-sm font-bold font-sans flex items-center gap-2 hover:-translate-y-0.5 hover:shadow-md transition-all duration-150"
              >
                Começar Agora
                <span className="material-symbols-outlined text-[18px]">play_arrow</span>
              </button>
              <div className="flex items-center gap-2 text-white/80 text-sm font-sans">
                <span className="material-symbols-outlined text-[18px]">timer</span>
                12 Minutos
              </div>
            </div>
          </div>
          <div className="hidden md:flex w-1/2 h-full absolute right-0 top-0 items-center justify-center pointer-events-none">
            <span className="material-symbols-outlined text-white/8" style={{ fontSize: '260px' }}>quiz</span>
          </div>
        </section>

        {/* Thematic quizzes */}
        <section>
          <div className="flex items-end justify-between mb-7">
            <div>
              <h3 className="text-xl font-bold text-[#1c1b1b] font-sans">Explorar Quizzes Temáticos</h3>
              <p className="text-sm text-[#5d5f5d] font-serif mt-0.5">Aprofunde os seus conhecimentos por período histórico ou tema económico.</p>
            </div>
            <div className="flex gap-1.5">
              {filters.map((f) => (
                <button
                  key={f}
                  onClick={() => setActiveFilter(f)}
                  className={`px-3.5 py-1.5 rounded-full text-xs font-semibold font-sans transition-all duration-150 ${
                    activeFilter === f
                      ? 'bg-[#8B1A1A] text-white shadow-xs'
                      : 'bg-[#f0eded] text-[#5d5f5d] hover:bg-[#e8e2e1] hover:text-[#1c1b1b]'
                  }`}
                >
                  {f}
                </button>
              ))}
            </div>
          </div>

          <div className="grid grid-cols-12 gap-5">
            {quizzes.map((quiz) => (
              <div
                key={quiz.title}
                onClick={() => navigate('/quiz/em-curso')}
                className="col-span-12 md:col-span-4 bg-white rounded-xl overflow-hidden border border-[#ebe5e4] shadow-card hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 flex flex-col group cursor-pointer"
              >
                <div className="h-36 relative bg-gradient-to-br from-[#f0eded] to-[#e5e2e1] flex items-center justify-center overflow-hidden">
                  <span className="material-symbols-outlined text-[#8B1A1A]/20 group-hover:scale-105 transition-transform duration-300" style={{ fontSize: '64px' }}>quiz</span>
                  <span className={`absolute top-3 left-3 px-2.5 py-1 rounded-full text-xs font-bold font-sans ${quiz.levelColor}`}>{quiz.level}</span>
                </div>
                <div className="p-5 flex-grow flex flex-col">
                  <h4 className="text-base font-semibold text-[#1c1b1b] mb-2 font-sans leading-snug">{quiz.title}</h4>
                  <p className="text-sm text-[#5d5f5d] mb-5 flex-grow font-serif leading-relaxed">{quiz.desc}</p>
                  <div className="flex items-center justify-between mt-auto">
                    <span className="text-xs text-[#8c716e] font-sans">{quiz.questions} Questões</span>
                    <span className="text-[#8B1A1A] font-bold text-sm font-sans flex items-center gap-1">
                      Participar <span className="material-symbols-outlined text-[16px]">chevron_right</span>
                    </span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </section>

        {/* Stats */}
        <section className="mt-10 bg-white rounded-xl p-8 border border-[#ebe5e4] shadow-card flex gap-10 items-center">
          <div className="w-1/3">
            <h3 className="text-lg font-bold text-[#1c1b1b] mb-1 font-sans">A Sua Jornada</h3>
            <p className="text-sm text-[#5d5f5d] font-serif leading-relaxed">Carlos, o seu progresso como Investigador continua a crescer.</p>
          </div>
          <div className="flex flex-grow justify-between border-l border-[#ebe5e4] pl-10">
            {[
              { value: '24', label: 'Quizzes Concluídos' },
              { value: '88%', label: 'Precisão Média' },
              { value: '05', label: 'Temas Dominados' },
              { value: '12', label: 'Ranking Geral' },
            ].map((stat) => (
              <div key={stat.label} className="text-center">
                <p className="text-[36px] text-[#8B1A1A] font-extrabold leading-none font-sans mb-1">{stat.value}</p>
                <p className="text-[10px] text-[#8c716e] uppercase tracking-[0.08em] font-sans">{stat.label}</p>
              </div>
            ))}
          </div>
        </section>
      </div>
    </AppShell>
  )
}
