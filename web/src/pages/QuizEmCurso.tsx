import { useState, useEffect } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { quizService } from '../services/api/quiz.service'
import { getErrorMessage } from '../utils/errors'
import type { QuizWithQuestions, QuizQuestion, UserAnswerResult } from '../services/types/api.types'

const OPTION_LETTERS = ['A', 'B', 'C', 'D', 'E']

interface AnsweredState {
  optionId: string
  isCorrect: boolean
  pointsEarned: number
}

export default function QuizEmCurso() {
  const navigate = useNavigate()
  const location = useLocation()
  const quizId = (location.state as { quizId?: string } | null)?.quizId

  const [quiz, setQuiz] = useState<QuizWithQuestions | null>(null)
  const [loading, setLoading] = useState(true)
  const [loadError, setLoadError] = useState('')
  const [attemptId, setAttemptId] = useState<string | null>(null)

  const [current, setCurrent] = useState(0)
  const [answeredState, setAnsweredState] = useState<AnsweredState | null>(null)
  const [answering, setAnswering] = useState(false)
  const [answerError, setAnswerError] = useState('')

  const [totalScore, setTotalScore] = useState(0)
  const [correctCount, setCorrectCount] = useState(0)
  const [submitting, setSubmitting] = useState(false)

  useEffect(() => {
    if (!quizId) { setLoading(false); return }

    Promise.all([
      quizService.findById(quizId),
      quizService.start(quizId),
    ])
      .then(([quizData, attempt]) => {
        setQuiz(quizData)
        setAttemptId(attempt.id)
      })
      .catch((err) => setLoadError(getErrorMessage(err)))
      .finally(() => setLoading(false))
  }, [quizId])

  const questions: QuizQuestion[] = quiz?.questions ?? []
  const q = questions[current]
  const isLast = current === questions.length - 1
  const progressPct = questions.length > 0
    ? ((current + (answeredState ? 1 : 0)) / questions.length) * 100
    : 0

  async function handleSelect(optionId: string) {
    if (answeredState || answering || !q || !attemptId) return
    setAnswering(true)
    setAnswerError('')
    try {
      const result: UserAnswerResult = await quizService.answer(attemptId, q.id, optionId)
      setAnsweredState({ optionId, isCorrect: result.isCorrect, pointsEarned: result.pointsEarned })
      if (result.isCorrect) {
        setCorrectCount((c) => c + 1)
        setTotalScore((s) => s + result.pointsEarned)
      }
    } catch (err) {
      setAnswerError(getErrorMessage(err))
    } finally {
      setAnswering(false)
    }
  }

  async function handleNext() {
    if (isLast) {
      setSubmitting(true)
      let finalScore = totalScore
      try {
        if (attemptId) {
          const submitted = await quizService.submit(attemptId)
          finalScore = submitted.score ?? totalScore
        }
      } catch {
        // use locally computed score
      } finally {
        setSubmitting(false)
      }
      navigate('/quiz/resultado', {
        state: {
          score: correctCount,
          total: questions.length,
          points: finalScore,
          quizTitle: quiz?.title ?? 'Quiz',
        },
      })
    } else {
      setCurrent((c) => c + 1)
      setAnsweredState(null)
      setAnswerError('')
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

  if (loading) {
    return (
      <AppShell showSearch={false}>
        <div className="page-content-narrow pt-8 pb-16">
          <div className="space-y-5 animate-fade-in">
            <div className="skeleton h-4 w-48 rounded" />
            <div className="skeleton h-10 w-3/4 rounded-lg" />
            <div className="skeleton h-48 rounded-card" />
            {[0, 1, 2, 3].map((i) => <div key={i} className="skeleton h-14 rounded-button" />)}
          </div>
        </div>
      </AppShell>
    )
  }

  if (loadError) {
    return (
      <AppShell showSearch={false}>
        <div className="page-content-narrow text-center py-20">
          <div className="w-16 h-16 rounded-2xl bg-surface-container flex items-center justify-center mx-auto mb-4">
            <span className="material-symbols-outlined text-error/50 text-[32px]">error_outline</span>
          </div>
          <h2 className="text-headline-lg font-bold text-text font-sans mb-2">Não foi possível carregar o quiz</h2>
          <p className="text-body-md text-secondary font-body mb-6">{loadError}</p>
          <button onClick={() => navigate('/quiz')} className="btn-primary mx-auto">Voltar aos Quizzes</button>
        </div>
      </AppShell>
    )
  }

  if (!quiz || questions.length === 0) {
    return (
      <AppShell showSearch={false}>
        <div className="page-content-narrow text-center py-20">
          <div className="w-16 h-16 rounded-2xl bg-surface-container flex items-center justify-center mx-auto mb-4">
            <span className="material-symbols-outlined text-primary/30 text-[32px]">quiz</span>
          </div>
          <h2 className="text-headline-lg font-bold text-text font-sans mb-2">Quiz sem perguntas</h2>
          <p className="text-body-md text-secondary font-body mb-6">Este quiz ainda não tem perguntas disponíveis.</p>
          <button onClick={() => navigate('/quiz')} className="btn-primary mx-auto">Voltar aos Quizzes</button>
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
              <span className="text-sm font-bold font-sans">{correctCount} corretas</span>
            </div>
            <span className="text-sm text-secondary font-body">
              {current + 1} / {questions.length}
            </span>
          </div>
        </div>

        {/* Progress dots */}
        <div className="flex items-center gap-1.5 mb-3">
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
        <p className="text-[11px] text-secondary font-body mb-8 text-right">{quiz.title}</p>

        {/* Question card */}
        <div className="card p-8 mb-5 animate-scale-in">
          <div className="flex items-center gap-3 mb-6">
            <div className="w-9 h-9 bg-primary rounded-lg flex items-center justify-center text-white font-bold text-sm font-sans flex-shrink-0">
              {current + 1}
            </div>
            <span className="text-label-md uppercase tracking-wider text-secondary font-sans">Questão</span>
            {q.points > 1 && (
              <span className="ml-auto text-[11px] text-secondary font-body">{q.points} pontos</span>
            )}
          </div>
          <h2 className="text-headline-lg font-bold text-text font-sans leading-snug mb-7">{q.statement}</h2>

          <div className="flex flex-col gap-2.5">
            {q.options.map((opt, idx) => {
              const isSelected = answeredState?.optionId === opt.id
              const isCorrectSelected = isSelected && answeredState?.isCorrect
              const isWrongSelected = isSelected && !answeredState?.isCorrect

              let classes = 'w-full text-left p-4 rounded-button border-2 text-sm font-semibold font-sans transition-all duration-200 flex items-center gap-3 '

              if (!answeredState && !answering) {
                classes += 'border-outline-variant/40 hover:border-primary/50 hover:bg-primary/4 cursor-pointer'
              } else if (!answeredState && answering) {
                classes += 'border-outline-variant/25 text-text/50 cursor-not-allowed'
              } else if (isCorrectSelected) {
                classes += 'border-success bg-success/8 text-success'
              } else if (isWrongSelected) {
                classes += 'border-error bg-error/8 text-error'
              } else {
                classes += 'border-outline-variant/25 text-text/35 cursor-not-allowed'
              }

              return (
                <button
                  key={opt.id}
                  className={classes}
                  onClick={() => handleSelect(opt.id)}
                  disabled={!!answeredState || answering}
                >
                  <span className={`w-7 h-7 rounded-full flex items-center justify-center text-xs font-bold flex-shrink-0 border-2 transition-all duration-200 ${
                    !answeredState ? 'border-current' :
                    isCorrectSelected ? 'bg-success text-white border-success' :
                    isWrongSelected ? 'bg-error text-white border-error' :
                    'border-current opacity-40'
                  }`}>
                    {isCorrectSelected ? (
                      <span className="material-symbols-outlined text-[14px]"
                        style={{ fontVariationSettings: "'FILL' 1" }}>check</span>
                    ) : isWrongSelected ? (
                      <span className="material-symbols-outlined text-[14px]"
                        style={{ fontVariationSettings: "'FILL' 1" }}>close</span>
                    ) : (
                      OPTION_LETTERS[idx]
                    )}
                  </span>
                  <span className="flex-1">{opt.text}</span>
                </button>
              )
            })}
          </div>

          {answering && (
            <div className="mt-5 flex items-center justify-center gap-2 text-secondary">
              <span className="w-4 h-4 border-2 border-current border-t-transparent rounded-full animate-spin" />
              <span className="text-sm font-body">A verificar resposta...</span>
            </div>
          )}

          {answeredState && (
            <div className={`mt-5 p-3 rounded-xl flex items-start gap-3 animate-fade-in ${
              answeredState.isCorrect
                ? 'bg-success/8 border border-success/20'
                : 'bg-error/8 border border-error/20'
            }`}>
              <span className={`material-symbols-outlined text-[20px] mt-0.5 flex-shrink-0 ${answeredState.isCorrect ? 'text-success' : 'text-error'}`}
                style={{ fontVariationSettings: "'FILL' 1" }}>
                {answeredState.isCorrect ? 'check_circle' : 'info'}
              </span>
              <div>
                <p className={`text-sm font-bold font-sans ${answeredState.isCorrect ? 'text-success' : 'text-error'}`}>
                  {answeredState.isCorrect ? 'Correto!' : 'Resposta incorreta.'}
                </p>
                {answeredState.isCorrect && answeredState.pointsEarned > 0 && (
                  <p className="text-xs text-success/80 font-body mt-0.5">+{answeredState.pointsEarned} {answeredState.pointsEarned === 1 ? 'ponto' : 'pontos'}</p>
                )}
                {q.explanation && (
                  <p className={`text-xs font-body mt-1 leading-relaxed ${answeredState.isCorrect ? 'text-success/80' : 'text-error/80'}`}>
                    {q.explanation}
                  </p>
                )}
              </div>
            </div>
          )}

          {answerError && (
            <div className="mt-4 alert-error rounded-xl">
              <span className="material-symbols-outlined text-error text-[16px]">error_outline</span>
              <p className="text-sm text-error font-body">{answerError}</p>
            </div>
          )}
        </div>

        {answeredState && (
          <div className="flex justify-end">
            <button onClick={handleNext} disabled={submitting} className="btn-primary">
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
