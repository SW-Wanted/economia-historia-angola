import { useState, useEffect, useRef } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import { useRegistration } from '../contexts/RegistrationContext'
import {
  writerApplicationService,
  type CreateWriterApplicationDto,
} from '../services/api/writer-application.service'
import { ApiError } from '../services/api/client'
import { getErrorMessage } from '../utils/errors'
import CadastroStepper from '../components/CadastroStepper'

const INTEREST_AREAS = [
  'História Económica',
  'Economia Colonial',
  'Economia Africana',
  'Desenvolvimento Económico',
  'Comércio Internacional',
  'Políticas Públicas',
  'Agricultura',
  'Recursos Naturais',
  'Industrialização',
  'Finanças',
  'Empreendedorismo',
  'História de Angola',
]

const LANGUAGE_OPTIONS = [
  { code: 'PT', label: 'Português' },
  { code: 'EN', label: 'Inglês' },
  { code: 'FR', label: 'Francês' },
  { code: 'ES', label: 'Espanhol' },
]

const MAX_MOTIVATION = 500

export default function Cadastro2() {
  const navigate = useNavigate()
  const { register } = useAuth()
  const { data, reset } = useRegistration()

  const isWriter = data.wantsWriter

  const [selectedAreas, setSelectedAreas] = useState<string[]>(
    data.interests ? data.interests.split(',').filter(Boolean) : [],
  )
  const [motivation, setMotivation] = useState(data.motivation)
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  // Multi-select dropdown
  const [isDropdownOpen, setIsDropdownOpen] = useState(false)
  const [searchQuery, setSearchQuery] = useState('')
  const dropdownRef = useRef<HTMLDivElement>(null)
  const searchInputRef = useRef<HTMLInputElement>(null)

  // Campos exclusivos da candidatura de Escritor (pertencem à WriterApplication)
  const [biography, setBiography] = useState(data.writer?.biography ?? '')
  const [academicBackground, setAcademicBackground] = useState(data.writer?.academicBackground ?? '')
  const [institution, setInstitution] = useState(data.writer?.institution ?? '')
  const [specialization, setSpecialization] = useState(data.writer?.specialization ?? '')
  const [researchExperience, setResearchExperience] = useState(data.writer?.researchExperience ?? '')
  const [economicHistoryAreas, setEconomicHistoryAreas] = useState(data.writer?.economicHistoryAreas ?? '')
  const [interestTopics, setInterestTopics] = useState(data.writer?.interestTopics ?? '')
  const [selectedLanguages, setSelectedLanguages] = useState<string[]>(
    data.writer?.languages ? data.writer.languages.split(',').filter(Boolean) : [],
  )
  const [previousPublications, setPreviousPublications] = useState(data.writer?.previousPublications ?? '')
  const [portfolio, setPortfolio] = useState(data.writer?.portfolio ?? '')

  // Evita que a guarda de fluxo dispare depois de o registo iniciar (o reset()
  // limpa o contexto e esvaziaria email/password momentaneamente).
  const submittingRef = useRef(false)

  // Guarda de fluxo: sem dados da etapa 1, regressa ao início.
  useEffect(() => {
    if (submittingRef.current) return
    if (!data.email || !data.password) {
      navigate('/cadastro')
    }
  }, [data.email, data.password, navigate])

  // Fechar dropdown ao clicar fora ou pressionar Escape
  useEffect(() => {
    if (!isDropdownOpen) return
    function onClickOutside(e: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(e.target as Node)) {
        setIsDropdownOpen(false)
        setSearchQuery('')
      }
    }
    function onKeyDown(e: KeyboardEvent) {
      if (e.key === 'Escape') {
        setIsDropdownOpen(false)
        setSearchQuery('')
      }
    }
    document.addEventListener('mousedown', onClickOutside)
    document.addEventListener('keydown', onKeyDown)
    return () => {
      document.removeEventListener('mousedown', onClickOutside)
      document.removeEventListener('keydown', onKeyDown)
    }
  }, [isDropdownOpen])

  // Focar input de pesquisa quando dropdown abre
  useEffect(() => {
    if (isDropdownOpen) {
      const raf = requestAnimationFrame(() => searchInputRef.current?.focus())
      return () => cancelAnimationFrame(raf)
    }
  }, [isDropdownOpen])

  const availableAreas = INTEREST_AREAS.filter((a) => !selectedAreas.includes(a))
  const filteredAreas = searchQuery.trim()
    ? availableAreas.filter((a) => a.toLowerCase().includes(searchQuery.toLowerCase()))
    : availableAreas

  function selectArea(area: string) {
    if (!selectedAreas.includes(area)) {
      setSelectedAreas((prev) => [...prev, area])
      setSearchQuery('')
    }
  }

  function removeArea(area: string) {
    setSelectedAreas((prev) => prev.filter((a) => a !== area))
  }

  function toggleLanguage(code: string) {
    setSelectedLanguages((prev) =>
      prev.includes(code) ? prev.filter((l) => l !== code) : [...prev, code]
    )
  }

  function validateWriterFields(): string | null {
    if (!biography.trim()) return 'Por favor, escreva a sua biografia.'
    if (!academicBackground.trim()) return 'Por favor, indique a sua formação académica.'
    if (!institution.trim()) return 'Por favor, indique a instituição de formação.'
    if (!specialization.trim()) return 'Por favor, indique a sua área de especialização.'
    if (!researchExperience.trim()) return 'Por favor, descreva a sua experiência em investigação.'
    if (!economicHistoryAreas.trim()) return 'Por favor, indique as áreas da História Económica.'
    if (!interestTopics.trim()) return 'Por favor, indique os tópicos de interesse.'
    if (selectedLanguages.length === 0) return 'Por favor, selecione pelo menos um idioma de trabalho.'
    return null
  }

  /**
   * Etapa final do cadastro.
   * 1. Cria sempre um utilizador USER via POST /auth/register (auto-autentica).
   * 2. Se o Switch estiver activo, submete automaticamente a candidatura de
   *    Escritor via POST /writer-applications, que fica com estado PENDING no backend.
   * @param skipInterests salta os interesses opcionais (apenas para não-escritores).
   */
  async function handleSubmit(skipInterests: boolean) {
    setError('')

    if (isWriter) {
      const writerError = validateWriterFields()
      if (writerError) { setError(writerError); return }
    }

    const interests = skipInterests ? '' : selectedAreas.join(',')
    const motivationValue = skipInterests ? '' : motivation.trim()

    submittingRef.current = true
    setLoading(true)
    try {
      // 1. Criar a conta (utilizador USER) — auto-autentica via tokens.
      await register({
        name: data.name,
        email: data.email,
        password: data.password,
        ...(interests ? { interests } : {}),
        ...(motivationValue ? { motivation: motivationValue } : {}),
      })

      // 2. Submeter candidatura de Escritor, se aplicável.
      let writerApplied = false
      if (isWriter) {
        const dto: CreateWriterApplicationDto = {
          fullName: data.name,
          biography: biography.trim(),
          academicBackground: academicBackground.trim(),
          institution: institution.trim(),
          specialization: specialization.trim(),
          researchExperience: researchExperience.trim(),
          economicHistoryAreas: economicHistoryAreas.trim(),
          languages: selectedLanguages.join(','),
          interestTopics: interestTopics.trim(),
          ...(previousPublications.trim() ? { previousPublications: previousPublications.trim() } : {}),
          ...(portfolio.trim() ? { portfolio: portfolio.trim() } : {}),
        }
        try {
          await writerApplicationService.apply(dto)
          writerApplied = true
        } catch {
          writerApplied = false
        }
      }

      // Passar o resultado para a tela de confirmação e limpar o estado do fluxo.
      sessionStorage.setItem('reg_writer_applied', writerApplied ? 'true' : 'false')
      sessionStorage.setItem('reg_wanted_writer', isWriter ? 'true' : 'false')
      reset()

      navigate('/cadastro/sucesso')
    } catch (err: unknown) {
      // 409 no registo = email já registado (mensagem específica e acionável).
      if (err instanceof ApiError && err.statusCode === 409) {
        setError('Este email já está registado. Inicie sessão ou utilize outro email.')
      } else {
        setError(getErrorMessage(err))
      }
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex flex-col items-center py-8 px-6 font-body bg-background">
      {/* Logo */}
      <div className="mb-7 flex flex-col items-center text-center">
        <div className="w-12 h-12 rounded-card bg-surface-container flex items-center justify-center mb-3">
          <span
            className="material-symbols-outlined text-primary"
            style={{ fontSize: '22px', fontVariationSettings: "'FILL' 1" }}
          >
            account_balance
          </span>
        </div>
        <h2 className="text-base font-bold text-primary font-sans tracking-tight">Economia com História</h2>
        <p className="text-[10px] text-outline tracking-[0.12em] uppercase font-sans mt-0.5">Angola</p>
      </div>

      {/* Card sem overflow-hidden para o dropdown poder ultrapassar os limites */}
      <main className="w-full max-w-[520px] bg-surface rounded-card shadow-card border border-outline-variant/45">
        {/* Barra de progresso isolada com overflow-hidden próprio */}
        <div className="h-0.5 bg-surface-container-high rounded-t-card overflow-hidden">
          <div className="h-full bg-primary transition-all duration-700 ease-out" style={{ width: '100%' }} />
        </div>

        {/* Stepper */}
        <div className="px-8 pt-6 pb-5">
          <CadastroStepper currentStep={2} />
        </div>

        <div className="h-px mx-8 bg-outline-variant/25" />

        <div className="px-8 py-7 flex flex-col gap-6">
          {/* Header */}
          <header>
            <h1 className="text-headline-md font-bold text-text font-sans tracking-tight">
              Personalize a sua experiência
            </h1>
            <p className="text-body-sm font-body text-secondary mt-1.5 leading-relaxed">
              Estas informações ajudam-nos a recomendar conteúdos mais relevantes para si.
            </p>
          </header>

          {/* ── Multi-Select de Categorias ── */}
          <div className="flex flex-col gap-3">
            <div className="flex flex-col gap-1.5">
              <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">
                Categorias de Interesse{' '}
                <span className="text-outline normal-case tracking-normal font-body">(opcional)</span>
              </label>

              <div ref={dropdownRef} className="relative">
                {/* Trigger */}
                <button
                  type="button"
                  onClick={() => setIsDropdownOpen((v) => !v)}
                  aria-haspopup="listbox"
                  aria-expanded={isDropdownOpen}
                  className={[
                    'w-full input flex items-center justify-between gap-2 text-left cursor-pointer',
                    isDropdownOpen
                      ? 'border-primary ring-2 ring-primary/10 bg-white'
                      : 'hover:border-outline/60',
                  ].join(' ')}
                >
                  <span
                    className={
                      selectedAreas.length > 0
                        ? 'text-text text-sm font-body'
                        : 'text-outline/55 text-sm font-body'
                    }
                  >
                    {selectedAreas.length > 0
                      ? `${selectedAreas.length} ${
                          selectedAreas.length === 1
                            ? 'categoria selecionada'
                            : 'categorias selecionadas'
                        }`
                      : 'Selecione as suas áreas de interesse'}
                  </span>
                  <span
                    className={[
                      'material-symbols-outlined text-[18px] text-outline flex-shrink-0 transition-transform duration-200',
                      isDropdownOpen ? 'rotate-180' : '',
                    ].join(' ')}
                  >
                    expand_more
                  </span>
                </button>

                {/* Dropdown panel */}
                {isDropdownOpen && (
                  <div
                    role="listbox"
                    aria-multiselectable="true"
                    className="absolute top-[calc(100%+4px)] left-0 right-0 z-50 bg-surface border border-outline-variant/50 rounded-card shadow-card overflow-hidden animate-scale-in"
                  >
                    {/* Pesquisa */}
                    <div className="p-2 border-b border-outline-variant/20">
                      <div className="relative">
                        <span className="material-symbols-outlined absolute left-2.5 top-1/2 -translate-y-1/2 text-outline text-[16px]">
                          search
                        </span>
                        <input
                          ref={searchInputRef}
                          type="text"
                          placeholder="Pesquisar categoria..."
                          value={searchQuery}
                          onChange={(e) => setSearchQuery(e.target.value)}
                          className="w-full pl-8 pr-3 py-2 text-sm text-text font-body bg-surface-container-low/70 rounded-button border-0 outline-none placeholder:text-outline/50"
                        />
                      </div>
                    </div>

                    {/* Lista de opções */}
                    <div className="max-h-44 overflow-y-auto py-1">
                      {filteredAreas.length > 0 ? (
                        filteredAreas.map((area) => (
                          <button
                            key={area}
                            type="button"
                            role="option"
                            aria-selected={false}
                            onClick={() => selectArea(area)}
                            className="w-full flex items-center gap-2.5 px-3.5 py-2.5 text-sm text-text font-body text-left hover:bg-surface-container-low transition-colors duration-100"
                          >
                            <span className="material-symbols-outlined text-primary/45 text-[15px] flex-shrink-0">
                              add_circle
                            </span>
                            {area}
                          </button>
                        ))
                      ) : availableAreas.length === 0 ? (
                        <div className="px-4 py-5 flex flex-col items-center gap-1.5">
                          <span
                            className="material-symbols-outlined text-outline text-[22px]"
                            style={{ fontVariationSettings: "'FILL' 1" }}
                          >
                            check_circle
                          </span>
                          <p className="text-sm text-outline font-body">Todas as categorias selecionadas</p>
                        </div>
                      ) : (
                        <p className="px-4 py-5 text-sm text-outline font-body text-center">
                          Sem resultados para &ldquo;{searchQuery}&rdquo;
                        </p>
                      )}
                    </div>
                  </div>
                )}
              </div>
            </div>

            {/* Chips das categorias selecionadas */}
            {selectedAreas.length > 0 && (
              <div className="animate-fade-in">
                <p className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em] mb-2">
                  Selecionadas
                </p>
                <div className="flex flex-wrap gap-2">
                  {selectedAreas.map((area) => (
                    <div
                      key={area}
                      className="inline-flex items-center gap-1.5 bg-primary/[0.09] text-primary border border-primary/25 px-3 py-1.5 rounded-full text-xs font-semibold font-sans animate-scale-in"
                    >
                      {area}
                      <button
                        type="button"
                        onClick={() => removeArea(area)}
                        className="text-primary/55 hover:text-primary transition-colors ml-0.5"
                        aria-label={`Remover ${area}`}
                      >
                        <span className="material-symbols-outlined" style={{ fontSize: '12px' }}>
                          close
                        </span>
                      </button>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>

          {/* ── Motivação ── */}
          <div className="flex flex-col gap-1.5">
            <div className="flex items-baseline justify-between gap-2">
              <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">
                Motivação{' '}
                <span className="text-outline normal-case tracking-normal font-body">(opcional)</span>
              </label>
              {motivation.length > 0 && (
                <span className="text-[11px] text-outline font-body flex-shrink-0 tabular-nums animate-fade-in">
                  {motivation.length}/{MAX_MOTIVATION}
                </span>
              )}
            </div>
            <textarea
              placeholder="Conte-nos o que o motivou a aderir à aplicação..."
              value={motivation}
              onChange={(e) => setMotivation(e.target.value.slice(0, MAX_MOTIVATION))}
              rows={4}
              className="input resize-none"
            />
          </div>

          {/* ── Candidatura de Escritor (revelação progressiva) ── */}
          {isWriter && (
            <div className="flex flex-col gap-6 animate-slide-up">
              <div className="flex items-center gap-3">
                <div className="flex-1 h-px bg-outline-variant/40" />
                <div className="flex items-center gap-1.5 bg-primary/[0.07] border border-primary/20 rounded-full px-3 py-1">
                  <span
                    className="material-symbols-outlined text-primary"
                    style={{ fontSize: '14px', fontVariationSettings: "'FILL' 1" }}
                  >
                    edit_note
                  </span>
                  <span className="text-label-md text-primary font-sans uppercase tracking-wider">
                    Candidatura a Escritor
                  </span>
                </div>
                <div className="flex-1 h-px bg-outline-variant/40" />
              </div>

              {/* Sobre si */}
              <div className="flex flex-col gap-4">
                <h3 className="text-label-lg font-sans text-text-muted uppercase tracking-[0.06em]">
                  Sobre si
                </h3>

                <div className="flex flex-col gap-1.5">
                  <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">
                    Biografia
                  </label>
                  <textarea
                    placeholder="Apresente-se: quem é, o que faz, qual o seu percurso..."
                    value={biography}
                    onChange={(e) => setBiography(e.target.value)}
                    rows={3}
                    className="input resize-none"
                  />
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <div className="flex flex-col gap-1.5">
                    <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">
                      Formação Académica
                    </label>
                    <input
                      type="text"
                      placeholder="Ex: Mestrado em História"
                      value={academicBackground}
                      onChange={(e) => setAcademicBackground(e.target.value)}
                      className="input"
                    />
                  </div>
                  <div className="flex flex-col gap-1.5">
                    <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">
                      Instituição
                    </label>
                    <input
                      type="text"
                      placeholder="Ex: Universidade Agostinho Neto"
                      value={institution}
                      onChange={(e) => setInstitution(e.target.value)}
                      className="input"
                    />
                  </div>
                </div>

                <div className="flex flex-col gap-1.5">
                  <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">
                    Área de Especialização
                  </label>
                  <input
                    type="text"
                    placeholder="Ex: Economia Colonial Portuguesa, Petróleo e Desenvolvimento..."
                    value={specialization}
                    onChange={(e) => setSpecialization(e.target.value)}
                    className="input"
                  />
                </div>
              </div>

              {/* Experiência */}
              <div className="flex flex-col gap-4">
                <h3 className="text-label-lg font-sans text-text-muted uppercase tracking-[0.06em]">
                  Experiência
                </h3>

                <div className="flex flex-col gap-1.5">
                  <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">
                    Experiência em Investigação
                  </label>
                  <textarea
                    placeholder="Descreva os seus projetos, pesquisas ou actividades académicas relevantes..."
                    value={researchExperience}
                    onChange={(e) => setResearchExperience(e.target.value)}
                    rows={3}
                    className="input resize-none"
                  />
                </div>

                <div className="flex flex-col gap-1.5">
                  <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">
                    Publicações Anteriores{' '}
                    <span className="text-outline normal-case tracking-normal font-body">(opcional)</span>
                  </label>
                  <textarea
                    placeholder="Artigos, livros, teses ou outros trabalhos publicados..."
                    value={previousPublications}
                    onChange={(e) => setPreviousPublications(e.target.value)}
                    rows={2}
                    className="input resize-none"
                  />
                </div>
              </div>

              {/* Áreas e Tópicos */}
              <div className="flex flex-col gap-4">
                <h3 className="text-label-lg font-sans text-text-muted uppercase tracking-[0.06em]">
                  Áreas e Tópicos
                </h3>

                <div className="flex flex-col gap-1.5">
                  <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">
                    Áreas da História Económica
                  </label>
                  <input
                    type="text"
                    placeholder="Ex: Economia Colonial, Comércio Atlântico, Petróleo e Desenvolvimento"
                    value={economicHistoryAreas}
                    onChange={(e) => setEconomicHistoryAreas(e.target.value)}
                    className="input"
                  />
                  <p className="text-xs text-outline font-body">Separe múltiplas áreas por vírgula.</p>
                </div>

                <div className="flex flex-col gap-1.5">
                  <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">
                    Tópicos de Interesse
                  </label>
                  <input
                    type="text"
                    placeholder="Ex: Escravatura, Independência, Reformas Económicas, Industrialização"
                    value={interestTopics}
                    onChange={(e) => setInterestTopics(e.target.value)}
                    className="input"
                  />
                  <p className="text-xs text-outline font-body">Separe múltiplos tópicos por vírgula.</p>
                </div>
              </div>

              {/* Idiomas */}
              <div className="flex flex-col gap-3">
                <h3 className="text-label-lg font-sans text-text-muted uppercase tracking-[0.06em]">
                  Idiomas de Trabalho
                </h3>
                <div className="grid grid-cols-2 gap-2">
                  {LANGUAGE_OPTIONS.map(({ code, label }) => {
                    const checked = selectedLanguages.includes(code)
                    return (
                      <button
                        key={code}
                        type="button"
                        onClick={() => toggleLanguage(code)}
                        className={[
                          'flex items-center gap-2.5 px-4 py-3 rounded-button border text-sm font-sans font-medium transition-all duration-150 active:scale-[0.98]',
                          checked
                            ? 'bg-primary/[0.08] border-primary/40 text-primary'
                            : 'bg-surface border-outline-variant/60 text-secondary hover:border-primary/30 hover:bg-primary/[0.04]',
                        ].join(' ')}
                      >
                        <span
                          className={[
                            'w-4 h-4 rounded flex-shrink-0 border transition-all flex items-center justify-center',
                            checked ? 'bg-primary border-primary' : 'border-outline/50',
                          ].join(' ')}
                        >
                          {checked && (
                            <span
                              className="material-symbols-outlined text-white"
                              style={{ fontSize: '11px', fontVariationSettings: "'FILL' 1" }}
                            >
                              check
                            </span>
                          )}
                        </span>
                        {label}
                        <span className="ml-auto text-[10px] font-bold text-outline/70 font-sans tracking-wider">
                          {code}
                        </span>
                      </button>
                    )
                  })}
                </div>
              </div>

              {/* Portefólio */}
              <div className="flex flex-col gap-3">
                <h3 className="text-label-lg font-sans text-text-muted uppercase tracking-[0.06em]">
                  Referências{' '}
                  <span className="text-outline normal-case tracking-normal font-body">(opcional)</span>
                </h3>
                <div className="flex flex-col gap-1.5">
                  <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">
                    Portefólio ou Website
                  </label>
                  <div className="relative">
                    <span className="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-outline text-[18px]">
                      link
                    </span>
                    <input
                      type="url"
                      placeholder="https://..."
                      value={portfolio}
                      onChange={(e) => setPortfolio(e.target.value)}
                      className="input pl-10"
                    />
                  </div>
                </div>
              </div>

              {/* Aviso de candidatura */}
              <div className="flex items-start gap-2.5 p-3.5 bg-surface-container-low border border-outline-variant/40 rounded-card">
                <span
                  className="material-symbols-outlined text-secondary flex-shrink-0 mt-0.5"
                  style={{ fontSize: '16px' }}
                >
                  schedule
                </span>
                <p className="text-xs text-secondary font-body leading-relaxed">
                  A candidatura ficará com estado <strong>Pendente</strong> até ser analisada pela
                  administração. Será notificado quando houver uma decisão.
                </p>
              </div>
            </div>
          )}

          {error && (
            <div className="alert-error">
              <span
                className="material-symbols-outlined text-error text-[18px] flex-shrink-0 mt-0.5"
                style={{ fontVariationSettings: "'FILL' 1" }}
              >
                error
              </span>
              <p className="text-sm text-error font-body">{error}</p>
            </div>
          )}

          {/* Botões de navegação */}
          <div className="flex items-center gap-3 pt-1">
            <button
              type="button"
              onClick={() => navigate('/cadastro')}
              disabled={loading}
              className="btn-secondary flex-shrink-0 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              Voltar
            </button>

            <div className="flex-1" />

            {!isWriter && (
              <button
                type="button"
                onClick={() => handleSubmit(true)}
                disabled={loading}
                className="text-secondary text-sm font-semibold font-sans hover:text-text active:text-primary transition-colors duration-150 px-2 py-1.5 rounded focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary/30 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                Saltar
              </button>
            )}

            <button
              type="button"
              onClick={() => handleSubmit(false)}
              disabled={loading}
              className="btn-primary disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? (
                <span className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
              ) : isWriter ? (
                <>
                  Criar Conta e Candidatar
                  <span className="material-symbols-outlined text-[18px]">arrow_forward</span>
                </>
              ) : (
                <>
                  Criar Conta
                  <span className="material-symbols-outlined text-[18px]">arrow_forward</span>
                </>
              )}
            </button>
          </div>
        </div>
      </main>
    </div>
  )
}
