import { useMemo, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { quizService, type CreateQuizQuestionDto } from '../services/api/quiz.service'
import { slugify } from '../services/api/forum.service'
import { getErrorMessage } from '../utils/errors'

const blankQuestion = (): CreateQuizQuestionDto => ({
  statement: '',
  explanation: '',
  points: 1,
  options: [
    { text: '', isCorrect: true },
    { text: '', isCorrect: false },
    { text: '', isCorrect: false },
    { text: '', isCorrect: false },
  ],
})

export default function CriarQuiz() {
  const navigate = useNavigate()
  const [mode, setMode] = useState<'manual' | 'ai'>('manual')
  const [title, setTitle] = useState('')
  const [description, setDescription] = useState('')
  const [visibility, setVisibility] = useState<'PUBLIC' | 'AUTHENTICATED' | 'PRIVATE'>('PUBLIC')
  const [isWeekly, setIsWeekly] = useState(false)
  const [aiContext, setAiContext] = useState('')
  const [aiCategory, setAiCategory] = useState('')
  const [aiDifficulty, setAiDifficulty] = useState('Médio')
  const [aiCount, setAiCount] = useState(5)
  const [questions, setQuestions] = useState<CreateQuizQuestionDto[]>([blankQuestion()])
  const [loading, setLoading] = useState(false)
  const [generating, setGenerating] = useState(false)
  const [error, setError] = useState('')

  const validQuestionCount = useMemo(
    () => questions.filter((q) => q.statement.trim() && q.options.filter((o) => o.text.trim()).length >= 2).length,
    [questions],
  )

  function updateQuestion(index: number, patch: Partial<CreateQuizQuestionDto>) {
    setQuestions((prev) => prev.map((q, i) => (i === index ? { ...q, ...patch } : q)))
  }

  function updateOption(questionIndex: number, optionIndex: number, text: string) {
    setQuestions((prev) =>
      prev.map((q, qi) =>
        qi === questionIndex
          ? { ...q, options: q.options.map((o, oi) => (oi === optionIndex ? { ...o, text } : o)) }
          : q,
      ),
    )
  }

  function markCorrect(questionIndex: number, optionIndex: number) {
    setQuestions((prev) =>
      prev.map((q, qi) =>
        qi === questionIndex
          ? { ...q, options: q.options.map((o, oi) => ({ ...o, isCorrect: oi === optionIndex })) }
          : q,
      ),
    )
  }

  async function generateWithAi() {
    setError('')
    if (!title.trim()) { setError('Indique um título/tema antes de gerar com IA.'); return }
    setGenerating(true)
    try {
      const res = await quizService.generate({
        title: title.trim(),
        category: aiCategory.trim() || undefined,
        context: aiContext.trim() || description.trim() || undefined,
        count: aiCount,
        difficulty: aiDifficulty,
      })
      setQuestions(res.questions.length ? res.questions : [blankQuestion()])
      setMode('manual')
    } catch (err) {
      setError(getErrorMessage(err))
    } finally {
      setGenerating(false)
    }
  }

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    setError('')
    if (!title.trim()) { setError('O título é obrigatório.'); return }
    if (validQuestionCount === 0) { setError('Adicione pelo menos uma pergunta válida.'); return }

    const cleaned = questions
      .map((q) => ({
        ...q,
        statement: q.statement.trim(),
        explanation: q.explanation?.trim() || undefined,
        points: q.points ?? 1,
        options: q.options.filter((o) => o.text.trim()).map((o) => ({ text: o.text.trim(), isCorrect: o.isCorrect })),
      }))
      .filter((q) => q.statement && q.options.length >= 2 && q.options.filter((o) => o.isCorrect).length === 1)

    setLoading(true)
    try {
      await quizService.create({
        title: title.trim(),
        slug: `${slugify(title.trim())}-${Date.now().toString(36)}`,
        description: description.trim() || undefined,
        visibility,
        isWeekly,
        questions: cleaned,
      })
      navigate('/quiz')
    } catch (err) {
      setError(getErrorMessage(err))
    } finally {
      setLoading(false)
    }
  }

  return (
    <AppShell title="Criar Quiz" showSearch={false}>
      <div className="page-content-narrow animate-fade-in">
        <button onClick={() => navigate('/quiz')} className="flex items-center gap-2 text-secondary hover:text-primary transition-colors mb-8 text-sm font-semibold font-sans">
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar aos Quizzes
        </button>

        <form onSubmit={submit} className="card p-8 space-y-6">
          <div>
            <h1 className="text-headline-md font-bold text-text font-sans mb-2">Criar Quiz</h1>
            <p className="text-body-md text-secondary font-body">Monte manualmente ou gere perguntas com Gemini e edite antes de publicar.</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-label-lg text-text-muted font-sans mb-1.5">Título / Tema</label>
              <input value={title} onChange={(e) => setTitle(e.target.value)} className="input" required />
            </div>
            <div>
              <label className="block text-label-lg text-text-muted font-sans mb-1.5">Visibilidade</label>
              <select value={visibility} onChange={(e) => setVisibility(e.target.value as typeof visibility)} className="input">
                <option value="PUBLIC">Público</option>
                <option value="AUTHENTICATED">Autenticados</option>
                <option value="PRIVATE">Privado</option>
              </select>
            </div>
          </div>

          <div>
            <label className="block text-label-lg text-text-muted font-sans mb-1.5">Descrição</label>
            <textarea value={description} onChange={(e) => setDescription(e.target.value)} rows={3} className="input resize-none" />
          </div>

          <label className="inline-flex items-center gap-2 text-sm font-semibold text-text font-sans">
            <input type="checkbox" checked={isWeekly} onChange={(e) => setIsWeekly(e.target.checked)} className="accent-primary" />
            Marcar como Quiz da Semana
          </label>

          <div className="flex gap-2">
            <button type="button" onClick={() => setMode('manual')} className={mode === 'manual' ? 'filter-chip-active' : 'filter-chip-inactive'}>Manual</button>
            <button type="button" onClick={() => setMode('ai')} className={mode === 'ai' ? 'filter-chip-active' : 'filter-chip-inactive'}>Gerar com IA</button>
          </div>

          {mode === 'ai' && (
            <div className="rounded-card border border-primary/20 bg-primary/5 p-5 space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <input value={aiCategory} onChange={(e) => setAiCategory(e.target.value)} placeholder="Categoria (opcional)" className="input" />
                <select value={aiDifficulty} onChange={(e) => setAiDifficulty(e.target.value)} className="input">
                  <option>Fácil</option>
                  <option>Médio</option>
                  <option>Difícil</option>
                </select>
                <input type="number" min={1} max={10} value={aiCount} onChange={(e) => setAiCount(Number(e.target.value))} className="input" />
              </div>
              <textarea value={aiContext} onChange={(e) => setAiContext(e.target.value)} rows={4} placeholder="Contexto de apoio para a Gemini..." className="input resize-none" />
              <button type="button" onClick={generateWithAi} disabled={generating} className="btn-primary">
                {generating ? 'A gerar...' : 'Gerar Perguntas'}
                <span className="material-symbols-outlined text-[18px]">auto_awesome</span>
              </button>
            </div>
          )}

          <div className="space-y-5">
            {questions.map((q, qi) => (
              <div key={qi} className="rounded-card border border-outline-variant/35 p-5 space-y-4">
                <div className="flex items-center justify-between gap-3">
                  <p className="text-sm font-bold text-text font-sans">Pergunta {qi + 1}</p>
                  {questions.length > 1 && (
                    <button type="button" onClick={() => setQuestions((prev) => prev.filter((_, i) => i !== qi))} className="text-error text-sm font-semibold">Remover</button>
                  )}
                </div>
                <input value={q.statement} onChange={(e) => updateQuestion(qi, { statement: e.target.value })} placeholder="Enunciado" className="input" />
                <input value={q.explanation ?? ''} onChange={(e) => updateQuestion(qi, { explanation: e.target.value })} placeholder="Explicação (opcional)" className="input" />
                <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                  {q.options.map((o, oi) => (
                    <label key={oi} className="flex items-center gap-2">
                      <input type="radio" name={`correct-${qi}`} checked={!!o.isCorrect} onChange={() => markCorrect(qi, oi)} className="accent-primary" />
                      <input value={o.text} onChange={(e) => updateOption(qi, oi, e.target.value)} placeholder={`Opção ${oi + 1}`} className="input" />
                    </label>
                  ))}
                </div>
              </div>
            ))}
            <button type="button" onClick={() => setQuestions((prev) => [...prev, blankQuestion()])} className="btn-secondary">
              <span className="material-symbols-outlined text-[18px]">add</span>
              Adicionar Pergunta
            </button>
          </div>

          {error && <div className="alert-error rounded-button"><p className="text-sm text-error font-body">{error}</p></div>}

          <div className="flex gap-3 pt-2">
            <button type="button" onClick={() => navigate('/quiz')} className="btn-ghost">Cancelar</button>
            <button type="submit" disabled={loading} className="btn-primary">
              {loading ? 'A publicar...' : 'Publicar Quiz'}
            </button>
          </div>
        </form>
      </div>
    </AppShell>
  )
}
