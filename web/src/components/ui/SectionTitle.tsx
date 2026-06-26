import { ReactNode } from 'react'

interface SectionTitleProps {
  children: ReactNode
  action?: ReactNode
}

export default function SectionTitle({ children, action }: SectionTitleProps) {
  return (
    <div className="flex items-center justify-between mb-3">
      <h2 className="text-title-lg font-sans font-bold text-text">{children}</h2>
      {action && <div>{action}</div>}
    </div>
  )
}
