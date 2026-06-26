import { useState, useEffect } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { quizService } from '../services/api/quiz.service'

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

const OPTION_LETTERS = ['A', 'B', 'C', 'D']

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
      .catch(() => { /* proceed with static questions */ })
  }, [quizId])

  const q = questions[current]
  const isLast = current === questions.length - 1
  const progressPct = ((current + (answered ? 1 : 0)) / questions.length) * 100

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
        try { await quizService.submit(attemptId) } catch { /* ignore */ }
      }
      setSubmitting(false)
      navigate('/quiz/resultado', { state: { score, total: questions.length, quizTitle: 'Quiz de História' } })
    } else {
      setCurrent((c) => c + 1)
      setSelected(null)
      setAnswered(false)
    }
  }

  if (!quizId) {
    return (
      <AppShell showSearch={false}>
        <div className="page-content-narrow text-center py-20">
          <div className="w-16 h-16 rounded-2xl bg-surface-container flex items-center justify-center mx-auto mb-4">
            <span className="material-symbols-outlined text-primary/30 text-[32px]">quiz</span>
          </div>
          <h2 className="text-headline-lg font-bold text-text font-sans mb-2">Nenhum quiz selecionado</h2>
          <p className="text-body-md text-secondary font-body mb-6">Escolha um quiz na lista para começar.</p>
          <button onClick={() => navigate('/quiz')} className="btn-primary mx-auto">Ver Quizzes</button>
        </div>
      </AppShell>
    )
  }

  return (
    <AppShell showSearch={false}>
      {/* Top progress strip */}
      <div className="fixed top-topbar left-sidebar right-0 z-30 h-[3px] bg-surface-container">
        <div className="h-full bg-primary transition-all duration-500 ease-out" style={{ width: `${progressPct}%` }} />
      </div>

      <div className="page-content-narrow pt-8 pb-16 animate-fade-in">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <button
            onClick={() => navigate('/quiz')}
            className="flex items-center gap-2 text-secondary hover:text-primary transition-colors duration-150 text-sm font-semibold font-sans"
          >
            <span className="material-symbols-outlined text-[18px]">arrow_back</span>
            Sair do Quiz
          </button>
          <div className="flex items-center gap-4">
            <div className="flex items-center gap-2 bg-success/10 text-success px-3 py-1.5 rounded-full border border-success/20">
              <span className="material-symbols-outlined text-[15px]"
                style={{ fontVariationSettings: "'FILL' 1" }}>check_circle</span>
              <span className="text-sm font-bold font-sans">{score} corretas</span>
            </div>
            <span className="text-sm text-secondary font-body">
              {current + 1} / {questions.length}
            </span>
          </div>
        </div>

        {/* Progress dots */}
        <div className="flex items-center gap-1.5 mb-8">
          {questions.map((_, i) => (
            <div
              key={i}
              className={`h-1.5 flex-1 rounded-full transition-all duration-300 ${
                i < current ? 'bg-primary' :
                i === current ? 'bg-primary/40' :
                'bg-surface-container'
              }`}
            />
          ))}
        </div>

        {/* Question card */}
        <div className="card p-8 mb-5 animate-scale-in">
          <div className="flex items-center gap-3 mb-6">
            <div className="w-9 h-9 bg-primary rounded-lg flex items-center justify-center text-white font-bold text-sm font-sans flex-shrink-0">
              {current + 1}
            </div>
            <span className="text-label-md uppercase tracking-wider text-secondary font-sans">Questão</span>
          </div>
          <h2 className="text-headline-lg font-bold text-text font-sans leading-snug mb-7">{q.q}</h2>

          <div className="flex flex-col gap-2.5">
            {q.options.map((opt, idx) => {
              const isCorrect = idx === q.correct
              const isSelected = idx === selected

              let classes = 'w-full text-left p-4 rounded-button border-2 text-sm font-semibold font-sans transition-all duration-200 flex items-center gap-3 '

              if (!answered) {
                classes += 'border-outline-variant/40 hover:border-primary/50 hover:bg-primary/4 cursor-pointer'
              } else if (isCorrect) {
                classes += 'border-success bg-success/8 text-success'
              } else if (isSelected && !isCorrect) {
                classes += 'border-error bg-error/8 text-error'
              } else {
                classes += 'border-outline-variant/25 text-text/35 cursor-not-allowed'
              }

              return (
                <button key={opt} className={classes} onClick={() => handleSelect(idx)}>
                  <span className={`w-7 h-7 rounded-full flex items-center justify-center text-xs font-bold flex-shrink-0 border-2 transition-all duration-200 ${
                    !answered ? 'border-current' :
                    isCorrect ? 'bg-success text-white border-success' :
                    isSelected ? 'bg-error text-white border-error' :
                    'border-current opacity-40'
                  }`}>
                    {answered && isCorrect ? (
                      <span className="material-symbols-outlined text-[14px]"
                        style={{ fontVariationSettings: "'FILL' 1" }}>check</span>
                    ) : answered && isSelected && !isCorrect ? (
                      <span className="material-symbols-outlined text-[14px]"
                        style={{ fontVariationSettings: "'FILL' 1" }}>close</span>
                    ) : (
                      OPTION_LETTERS[idx]
                    )}
                  </span>
                  <span className="flex-1">{opt}</span>
                </button>
              )
            })}
          </div>

          {/* Feedback message */}
          {answered && (
            <div className={`mt-5 p-3 rounded-xl flex items-center gap-3 animate-fade-in ${
              selected === q.correct
                ? 'bg-success/8 border border-success/20'
                : 'bg-error/8 border border-error/20'
            }`}>
              <span className={`material-symbols-outlined text-[20px] ${selected === q.correct ? 'text-success' : 'text-error'}`}
                style={{ fontVariationSettings: "'FILL' 1" }}>
                {selected === q.correct ? 'check_circle' : 'info'}
              </span>
              <p className={`text-sm font-semibold font-sans ${selected === q.correct ? 'text-success' : 'text-error'}`}>
                {selected === q.correct
                  ? 'Correto! Excelente resposta.'
                  : `Incorreto. A resposta certa é "${q.options[q.correct]}".`}
              </p>
            </div>
          )}
        </div>

        {answered && (
          <div className="flex justify-end">
            <button
              onClick={handleNext}
              disabled={submitting}
              className="btn-primary"
            >
              {submitting ? (
                <span className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
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
