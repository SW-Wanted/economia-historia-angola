import { ReactNode } from 'react'

interface EhCardProps {
  children: ReactNode
  onClick?: () => void
  className?: string
  color?: 'surface' | 'primary' | 'surface-low' | 'surface-container'
  padding?: string
}

export default function EhCard({
  children,
  onClick,
  className = '',
  color = 'surface',
  padding = 'p-4',
}: EhCardProps) {
  const colorClasses = {
    surface: 'bg-surface',
    primary: 'bg-primary',
    'surface-low': 'bg-surface-low',
    'surface-container': 'bg-surface-container',
  }

  const interactive = onClick
    ? 'hover:shadow-card-hover hover:-translate-y-0.5 cursor-pointer'
    : ''

  return (
    <div
      role={onClick ? 'button' : undefined}
      tabIndex={onClick ? 0 : undefined}
      onClick={onClick}
      onKeyDown={onClick ? (e) => e.key === 'Enter' && onClick() : undefined}
      className={`rounded-card border border-outline-variant/45 shadow-card transition-all duration-200
        ${colorClasses[color]} ${padding} ${interactive} ${className}`}
    >
      {children}
    </div>
  )
}
