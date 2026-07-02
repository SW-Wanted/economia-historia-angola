import { ReactNode } from 'react'

interface SectionTitleProps {
  children: ReactNode
  action?: ReactNode
}

/**
 * Espelha o widget SectionTitle da app Mobile: barra vertical em primary
 * (4×24, cantos arredondados) + título em titleLarge com cor primary,
 * e uma acção opcional alinhada à direita.
 */
export default function SectionTitle({ children, action }: SectionTitleProps) {
  return (
    <div className="flex items-center gap-2.5 mb-3">
      <span className="w-1 h-6 rounded-full bg-primary flex-shrink-0" aria-hidden="true" />
      <h2 className="flex-1 text-title-lg font-sans font-bold text-primary">{children}</h2>
      {action && <div className="flex-shrink-0">{action}</div>}
    </div>
  )
}
