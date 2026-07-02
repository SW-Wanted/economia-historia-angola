import EhCard from './EhCard'

interface EmptyStateProps {
  icon: string
  title: string
  message: string
  action?: { label: string; onClick: () => void }
}

export default function EmptyState({ icon, title, message, action }: EmptyStateProps) {
  return (
    <EhCard padding="p-10">
      <div className="flex flex-col items-center text-center gap-3">
        <span
          className="material-symbols-outlined text-primary"
          style={{ fontSize: '48px' }}
        >
          {icon}
        </span>
        <h3 className="text-title-lg font-sans font-bold text-text">{title}</h3>
        <p className="text-body-md font-body text-secondary">{message}</p>
        {action && (
          <button
            onClick={action.onClick}
            className="mt-1 text-sm font-semibold text-primary font-sans hover:text-primary-dark transition-colors duration-150"
          >
            {action.label} →
          </button>
        )}
      </div>
    </EhCard>
  )
}
