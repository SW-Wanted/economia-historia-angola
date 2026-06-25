import { Navigate } from 'react-router-dom'
import { useAuth, hasPermission } from '../contexts/AuthContext'
import type { ReactNode } from 'react'

interface Props {
  children: ReactNode
  /** At least one of these permissions must be present */
  permissions: string[]
  /** Where to redirect on failure. Defaults to /dashboard */
  redirectTo?: string
}

export default function PermissionRoute({ children, permissions, redirectTo = '/dashboard' }: Props) {
  const { user, isLoading } = useAuth()

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-[#F2F2F0]">
        <div className="w-8 h-8 border-2 border-[#8B1A1A] border-t-transparent rounded-full animate-spin" />
      </div>
    )
  }

  if (!user) return <Navigate to="/login" replace />

  if (!hasPermission(user, ...permissions)) {
    return <Navigate to={redirectTo} replace />
  }

  return <>{children}</>
}
