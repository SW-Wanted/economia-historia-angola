import { createContext, useContext, useState, useCallback, type ReactNode } from 'react'

/**
 * Draft dos campos exclusivos da candidatura de Escritor.
 * Estes dados pertencem à WriterApplication — nunca à entidade User.
 * Mapeiam directamente para CreateWriterApplicationDto do backend.
 */
export interface WriterApplicationDraft {
  biography: string
  academicBackground: string
  institution: string
  specialization: string
  researchExperience: string
  economicHistoryAreas: string
  languages: string
  interestTopics: string
  previousPublications?: string
  portfolio?: string
}

/**
 * Estado do fluxo de cadastro, partilhado entre as etapas.
 * Mantido apenas em memória (nunca em storage) — a palavra-passe não é
 * persistida e um refresh reinicia o fluxo de forma segura.
 */
export interface RegistrationState {
  name: string
  email: string
  password: string
  /** Indica intenção de submeter candidatura a Escritor. O utilizador continua sempre USER. */
  wantsWriter: boolean
  /** Categorias de interesse (CSV) — dados do User, para personalização. */
  interests: string
  /** Motivação livre — dado do User. */
  motivation: string
  /** Campos exclusivos da candidatura; só preenchido quando wantsWriter é true. */
  writer: WriterApplicationDraft | null
}

const INITIAL_STATE: RegistrationState = {
  name: '',
  email: '',
  password: '',
  wantsWriter: false,
  interests: '',
  motivation: '',
  writer: null,
}

interface RegistrationContextValue {
  data: RegistrationState
  patch: (partial: Partial<RegistrationState>) => void
  reset: () => void
}

const RegistrationContext = createContext<RegistrationContextValue | null>(null)

export function RegistrationProvider({ children }: { children: ReactNode }) {
  const [data, setData] = useState<RegistrationState>(INITIAL_STATE)

  const patch = useCallback((partial: Partial<RegistrationState>) => {
    setData((prev) => ({ ...prev, ...partial }))
  }, [])

  const reset = useCallback(() => setData(INITIAL_STATE), [])

  return (
    <RegistrationContext.Provider value={{ data, patch, reset }}>
      {children}
    </RegistrationContext.Provider>
  )
}

export function useRegistration(): RegistrationContextValue {
  const ctx = useContext(RegistrationContext)
  if (!ctx) throw new Error('useRegistration must be used within RegistrationProvider')
  return ctx
}
