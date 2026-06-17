import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const quizzes = [
  { title: 'Fundamentos do Comércio em Luanda', desc: 'Conheça as primeiras rotas comerciais e os principais produtos de exportação do século XVIII.', level: 'Iniciante', levelColor: 'bg-green-100 text-green-800 border-green-200', questions: 10 },
  { title: 'O Ciclo do Café no Planalto Central', desc: 'Identifique os fatores que tornaram Angola o terceiro maior produtor mundial de café.', level: 'Intermédio', levelColor: 'bg-amber-100 text-amber-800 border-amber-200', questions: 8 },
  { title: 'História Bancária e do BNA', desc: 'Desde a fundação do Banco Nacional de Angola até à modernização do sistema financeiro.', level: 'Intermédio', levelColor: 'bg-amber-100 text-amber-800 border-amber-200', questions: 12 },
  { title: 'Macroeconomia da Transição (1975–1980)', desc: 'Analise os desafios da transição para uma economia planificada nos primeiros anos da República.', level: 'Especialista', levelColor: 'bg-red-100 text-red-800 border-red-200', questions: 15 },
]

const filters = ['Todos', 'Colonialismo', 'Pós-Independência', 'Comércio Atlântico']

export default function QuizHub() {
  const navigate = useNavigate()
  const [activeFilter, setActiveFilter] = useState('Todos')

  return (
    <AppShell searchPlaceholder="Pesquisar arquivo histórico...">
      <div className="px-10 py-8 max-w-[1160px] mx-auto">
        {/* Featured banner */}
        <section className="relative bg-[#8b1a1a] rounded-[24px] overflow-hidden mb-16 flex items-center min-h-[380px] shadow-xl">
          <div className="w-full md:w-1/2 p-12 relative z-10">
            <span className="inline-block bg-[#8B1A1A] text-white px-4 py-1 rounded-full text-xs font-semibold mb-6 uppercase tracking-widest border border-white/20">
              Quiz da Semana
            </span>
            <h2 className="text-[48px] font-extrabold text-white mb-6 leading-tight">A Evolução da Moeda Colonial no Século XIX</h2>
            <p className="text-lg text-white/90 mb-8 max-w-md italic" style={{ fontFamily: 'Merriweather, serif' }}>
              "Entender o passado comercial de Angola através dos seus símbolos de troca e valor."
            </p>
            <div className="flex items-center gap-6">
              <button
                onClick={() => navigate('/quiz/em-curso')}
                className="bg-white text-[#8B1A1A] px-8 py-4 rounded-full text-sm font-bold flex items-center gap-2 hover:scale-105 transition-transform"
              >
                Começar Agora
                <span className="material-symbols-outlined">play_arrow</span>
              </button>
              <div className="flex items-center gap-2 text-white text-sm font-semibold">
                <span className="material-symbols-outlined">timer</span>
                12 Minutos
              </div>
            </div>
          </div>
          <div className="hidden md:flex w-1/2 h-full absolute right-0 top-0 items-center justify-center">
            <span className="material-symbols-outlined text-white/10" style={{ fontSize: '300px' }}>quiz</span>
          </div>
        </section>

        {/* Thematic quizzes */}
        <section>
          <div className="flex items-end justify-between mb-8">
            <div>
              <h3 className="text-2xl font-bold text-[#1c1b1b]">Explorar Quizzes Temáticos</h3>
              <p className="text-base text-[#5d5f5d]" style={{ fontFamily: 'Merriweather, serif' }}>Aprofunde os seus conhecimentos por período histórico ou tema económico.</p>
            </div>
            <div className="flex gap-2">
              {filters.map((f) => (
                <button
                  key={f}
                  onClick={() => setActiveFilter(f)}
                  className={`px-4 py-2 rounded-full text-xs font-semibold ${activeFilter === f ? 'bg-[#8B1A1A] text-white' : 'bg-[#eae7e7] text-[#5d5f5d] hover:bg-[#e5e2e1]'}`}
                >
                  {f}
                </button>
              ))}
            </div>
          </div>

          <div className="grid grid-cols-12 gap-6">
            {quizzes.map((quiz) => (
              <div
                key={quiz.title}
                onClick={() => navigate('/quiz/em-curso')}
                className="col-span-12 md:col-span-4 bg-white rounded-xl overflow-hidden border border-[#e0bfbc] hover:-translate-y-1 transition-all shadow-sm flex flex-col group cursor-pointer"
              >
                <div className="h-40 relative bg-[#eae7e7] flex items-center justify-center overflow-hidden">
                  <span className="material-symbols-outlined text-[#8B1A1A]/20 group-hover:scale-105 transition-transform" style={{ fontSize: '80px' }}>quiz</span>
                  <span className={`absolute top-4 left-4 px-3 py-1 rounded-full text-xs font-bold border ${quiz.levelColor}`}>{quiz.level}</span>
                </div>
                <div className="p-6 flex-grow flex flex-col">
                  <h4 className="text-xl font-semibold text-[#1c1b1b] mb-2">{quiz.title}</h4>
                  <p className="text-base text-[#5d5f5d] mb-6 flex-grow" style={{ fontFamily: 'Merriweather, serif' }}>{quiz.desc}</p>
                  <div className="flex items-center justify-between mt-auto">
                    <span className="text-xs text-[#5d5f5d]">{quiz.questions} Questões</span>
                    <span className="text-[#8B1A1A] font-bold text-sm flex items-center gap-1">
                      Participar <span className="material-symbols-outlined text-[16px]">chevron_right</span>
                    </span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </section>

        {/* Stats */}
        <section className="mt-16 bg-[#f6f3f2] rounded-[24px] p-10 flex gap-12 items-center">
          <div className="w-1/3">
            <h3 className="text-2xl font-bold text-[#1c1b1b] mb-2">A Sua Jornada</h3>
            <p className="text-base text-[#5d5f5d]" style={{ fontFamily: 'Merriweather, serif' }}>Carlos, o seu progresso como Investigador continua a crescer.</p>
          </div>
          <div className="flex flex-grow justify-between border-l border-[#e0bfbc] pl-12">
            {[
              { value: '24', label: 'Quizzes Concluídos' },
              { value: '88%', label: 'Precisão Média' },
              { value: '05', label: 'Temas Dominados' },
              { value: '12', label: 'Ranking Geral' },
            ].map((stat) => (
              <div key={stat.label} className="text-center">
                <p className="text-[40px] text-[#8B1A1A] font-extrabold">{stat.value}</p>
                <p className="text-xs text-[#5d5f5d] uppercase tracking-wider">{stat.label}</p>
              </div>
            ))}
          </div>
        </section>
      </div>
    </AppShell>
  )
}
