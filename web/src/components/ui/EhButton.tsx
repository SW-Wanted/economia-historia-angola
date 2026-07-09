import { ReactNode } from 'react'

interface EhButtonProps {
  children: ReactNode
  onClick?: () => void
  type?: 'button' | 'submit' | 'reset'
  variant?: 'primary' | 'secondary' | 'inverted'
  fullWidth?: boolean
  disabled?: boolean
  loading?: boolean
  className?: string
  icon?: string
}

export default function EhButton({
  children,
  onClick,
  type = 'button',
  variant = 'primary',
  fullWidth = false,
  disabled = false,
  loading = false,
  className = '',
  icon,
}: EhButtonProps) {
  const base = `inline-flex items-center justify-center gap-2 font-sans font-semibold text-sm
    uppercase tracking-wide px-[18px] py-[14px] rounded-button
    active:scale-[0.98] transition-all duration-150
    disabled:opacity-60 disabled:cursor-not-allowed ${fullWidth ? 'w-full' : ''}`

  const variants = {
    primary: 'bg-primary text-white hover:bg-primary-dark hover:shadow-md',
    secondary: 'bg-transparent text-primary border border-primary hover:bg-surface-low',
    inverted: 'bg-white text-primary hover:shadow-md',
  }

  return (
    <button
      type={type}
      onClick={onClick}
      disabled={disabled || loading}
      className={`${base} ${variants[variant]} ${className}`}
    >
      {loading ? (
        <>
          <span className="w-4 h-4 border-2 border-current border-t-transparent rounded-full animate-spin" />
          {children}
        </>
      ) : (
        <>
          {icon && <span className="material-symbols-outlined text-[18px]">{icon}</span>}
          {children}
        </>
      )}
    </button>
  )
}
