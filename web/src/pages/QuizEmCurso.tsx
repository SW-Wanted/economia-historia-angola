import { useState, useEffect } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { quizService } from '../services/api/quiz.service'

// Static questions — no GET /quizzes/:id endpoint exists in the backend
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
  const location = useLocation()
  const quizId = (location.state as { quizId?: string } | null)?.quizId

  const [attemptId, setAttemptId] = useState<string | null>(null)
  const [current, setCurrent] = useState(0)
  const [selected, setSelected] = useState<number | null>(null)
  const [answered, setAnswered] = useState(false)
  const [score, setScore] = useState(0)
  const [submitting, setSubmitting] = useState(false)

  useEffect(() => {
    if (!quizId) return
    quizService.start(quizId)
      .then((attempt) => setAttemptId(attempt.id))
      .catch(() => {
        // Attempt may already be started; proceed anyway with static questions
      })
  }, [quizId])

  const q = questions[current]
  const isLast = current === questions.length - 1

  function handleSelect(idx: number) {
    if (answered) return
    setSelected(idx)
    setAnswered(true)
    if (idx === q.correct) setScore((s) => s + 1)
  }

  async function handleNext() {
    if (isLast) {
      setSubmitting(true)
      if (attemptId) {
        try {
          await quizService.submit(attemptId)
        } catch {
          // ignore — navigate to result regardless
        }
      }
      setSubmitting(false)
      navigate('/quiz/resultado', {
        state: {
          score,
          total: questions.length,
          quizTitle: 'Quiz de História',
        },
      })
    } else {
      setCurrent((c) => c + 1)
      setSelected(null)
      setAnswered(false)
    }
  }

  if (!quizId) {
    return (
      <AppShell title="Quiz em Curso" showSearch={false}>
        <div className="px-10 py-16 max-w-[600px] mx-auto text-center">
          <span className="material-symbols-outlined text-[#8B1A1A]/30 text-5xl mb-3 block">quiz</span>
          <h2 className="text-xl font-bold text-[#1c1b1b] mb-2 font-sans">Nenhum quiz selecionado</h2>
          <p className="text-sm text-[#5d5f5d] font-serif mb-6">Escolha um quiz na lista para o iniciar.</p>
          <button onClick={() => navigate('/quiz')}
            className="bg-[#8B1A1A] text-white px-6 py-2.5 rounded-full text-sm font-semibold font-sans hover:bg-[#7a1616] transition-all">
            Ver Quizzes
          </button>
        </div>
      </AppShell>
    )
  }

  return (
    <AppShell title="Quiz em Curso" showSearch={false}>
      <div className="px-10 py-10 max-w-[760px] mx-auto">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <button
            onClick={() => navigate('/quiz')}
            className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors duration-150 text-sm font-semibold font-sans"
          >
            <span className="material-symbols-outlined text-[18px]">arrow_back</span>
            Sair do Quiz
          </button>
          <div className="flex items-center gap-2 text-sm text-[#5d5f5d] bg-[#f0eded] px-3 py-1.5 rounded-lg">
            <span className="material-symbols-outlined text-[16px]">quiz</span>
            <span className="font-semibold font-sans">{questions.length} questões</span>
          </div>
        </div>

        {/* Progress */}
        <div className="mb-8">
          <div className="flex justify-between items-center mb-2">
            <span className="text-xs font-semibold text-[#8c716e] font-sans">Questão {current + 1} de {questions.length}</span>
            <span className="text-xs font-semibold text-[#8B1A1A] font-sans">{score} corretas</span>
          </div>
          <div className="w-full bg-[#f0eded] h-1.5 rounded-full">
            <div
              className="bg-[#8B1A1A] h-1.5 rounded-full transition-all duration-500"
              style={{ width: `${((current + (answered ? 1 : 0)) / questions.length) * 100}%` }}
            />
          </div>
        </div>

        {/* Question card */}
        <div className="bg-white rounded-xl p-8 border border-[#ebe5e4] shadow-card mb-5">
          <div className="flex items-center gap-3 mb-6">
            <div className="w-9 h-9 bg-[#8B1A1A] rounded-lg flex items-center justify-center text-white font-bold text-sm font-sans flex-shrink-0">
              {current + 1}
            </div>
            <span className="text-[10px] font-semibold text-[#8c716e] uppercase tracking-[0.1em] font-sans">Questão</span>
          </div>
          <h2 className="text-xl font-bold text-[#1c1b1b] mb-7 font-sans leading-snug">{q.q}</h2>

          <div className="grid grid-cols-1 gap-2.5">
            {q.options.map((opt, idx) => {
              let cls = 'w-full text-left p-4 rounded-lg border text-sm font-semibold font-sans transition-all duration-150 '
              if (!answered) {
                cls += 'border-[#ebe5e4] hover:border-[#8B1A1A]/40 hover:bg-[#f8f5f4] cursor-pointer'
              } else if (idx === q.correct) {
                cls += 'border-emerald-400 bg-emerald-50 text-emerald-800'
              } else if (idx === selected && idx !== q.correct) {
                cls += 'border-red-300 bg-red-50 text-red-700'
              } else {
                cls += 'border-[#ebe5e4] opacity-45 cursor-not-allowed'
              }

              return (
                <button key={opt} className={cls} onClick={() => handleSelect(idx)}>
                  <span className="flex items-center gap-3">
                    <span className="w-6 h-6 rounded-full border-2 border-current flex items-center justify-center text-xs font-bold flex-shrink-0">
                      {String.fromCharCode(65 + idx)}
                    </span>
                    {opt}
                    {answered && idx === q.correct && (
                      <span className="material-symbols-outlined text-emerald-600 ml-auto text-[18px]">check_circle</span>
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
              disabled={submitting}
              className="bg-[#8B1A1A] text-white px-7 py-3 rounded-full text-sm font-bold font-sans flex items-center gap-2 hover:bg-[#7a1616] hover:shadow-md active:scale-[0.98] transition-all duration-150 disabled:opacity-60"
            >
              {submitting ? (
                <span className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
              ) : (
                <>
                  {isLast ? 'Ver Resultado' : 'Próxima Questão'}
                  <span className="material-symbols-outlined text-[18px]">arrow_forward</span>
                </>
              )}
            </button>
          </div>
        )}
      </div>
    </AppShell>
  )
}
