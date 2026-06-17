import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const questions = [
  {
    q: 'Em que ano foi introduzida a moeda Kwanza em Angola?',
    options: ['1975', '1977', '1980', '1985'],
    correct: 1,
  },
  {
    q: 'Qual era a principal moeda colonial utilizada em Angola antes da independência?',
    options: ['Real', 'Escudo', 'Franco', 'Libra'],
    correct: 1,
  },
  {
    q: 'Qual foi o principal produto de exportação angolano no século XIX?',
    options: ['Petróleo', 'Diamantes', 'Café', 'Algodão'],
    correct: 2,
  },
]

export default function QuizEmCurso() {
  const navigate = useNavigate()
  const [current, setCurrent] = useState(0)
  const [selected, setSelected] = useState<number | null>(null)
  const [answered, setAnswered] = useState(false)
  const [score, setScore] = useState(0)

  const q = questions[current]
  const isLast = current === questions.length - 1

  function handleSelect(idx: number) {
    if (answered) return
    setSelected(idx)
    setAnswered(true)
    if (idx === q.correct) setScore((s) => s + 1)
  }

  function handleNext() {
    if (isLast) {
      navigate('/quiz/resultado')
    } else {
      setCurrent((c) => c + 1)
      setSelected(null)
      setAnswered(false)
    }
  }

  return (
    <AppShell title="Quiz em Curso" showSearch={false}>
      <div className="px-10 py-16 max-w-[800px] mx-auto">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <button
            onClick={() => navigate('/quiz')}
            className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors text-sm font-semibold"
          >
            <span className="material-symbols-outlined text-[18px]">arrow_back</span>
            Sair do Quiz
          </button>
          <div className="flex items-center gap-2 text-sm text-[#5d5f5d]">
            <span className="material-symbols-outlined text-[18px]">timer</span>
            <span className="font-semibold">8:42</span>
          </div>
        </div>

        {/* Progress */}
        <div className="mb-8">
          <div className="flex justify-between items-center mb-2">
            <span className="text-xs font-semibold text-[#5d5f5d]">Questão {current + 1} de {questions.length}</span>
            <span className="text-xs font-semibold text-[#8B1A1A]">{score} corretas</span>
          </div>
          <div className="w-full bg-[#eae7e7] h-2 rounded-full">
            <div
              className="bg-[#8B1A1A] h-2 rounded-full transition-all duration-500"
              style={{ width: `${((current + (answered ? 1 : 0)) / questions.length) * 100}%` }}
            />
          </div>
        </div>

        {/* Question card */}
        <div className="bg-white rounded-xl p-10 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] mb-6">
          <div className="flex items-center gap-3 mb-6">
            <div className="w-10 h-10 bg-[#8B1A1A] rounded-full flex items-center justify-center text-white font-bold text-sm">
              {current + 1}
            </div>
            <span className="text-xs font-semibold text-[#5d5f5d] uppercase tracking-widest">A Evolução da Moeda Colonial</span>
          </div>
          <h2 className="text-2xl font-bold text-[#1c1b1b] mb-8">{q.q}</h2>

          <div className="grid grid-cols-1 gap-3">
            {q.options.map((opt, idx) => {
              let cls = 'w-full text-left p-4 rounded-xl border-2 text-sm font-semibold transition-all '
              if (!answered) {
                cls += 'border-[#e0bfbc] hover:border-[#8B1A1A] hover:bg-[#f6f3f2] cursor-pointer'
              } else if (idx === q.correct) {
                cls += 'border-green-500 bg-green-50 text-green-800'
              } else if (idx === selected && idx !== q.correct) {
                cls += 'border-red-400 bg-red-50 text-red-700'
              } else {
                cls += 'border-[#e0bfbc] opacity-50 cursor-not-allowed'
              }

              return (
                <button key={opt} className={cls} onClick={() => handleSelect(idx)}>
                  <span className="flex items-center gap-3">
                    <span className="w-6 h-6 rounded-full border-2 border-current flex items-center justify-center text-xs font-bold flex-shrink-0">
                      {String.fromCharCode(65 + idx)}
                    </span>
                    {opt}
                    {answered && idx === q.correct && (
                      <span className="material-symbols-outlined text-green-600 ml-auto text-[18px]">check_circle</span>
                    )}
                    {answered && idx === selected && idx !== q.correct && (
                      <span className="material-symbols-outlined text-red-500 ml-auto text-[18px]">cancel</span>
                    )}
                  </span>
                </button>
              )
            })}
          </div>
        </div>

        {answered && (
          <div className="flex justify-end">
            <button
              onClick={handleNext}
              className="bg-[#8B1A1A] text-white px-8 py-4 rounded-full text-sm font-bold flex items-center gap-2 hover:opacity-90 transition-all"
            >
              {isLast ? 'Ver Resultado' : 'Próxima Questão'}
              <span className="material-symbols-outlined">arrow_forward</span>
            </button>
          </div>
        )}
      </div>
    </AppShell>
  )
}
