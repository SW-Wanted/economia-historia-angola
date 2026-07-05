import { useAuth } from '../contexts/AuthContext'
import AuthRequired from './AuthRequired'
import type { ReactNode } from 'react'

export default function ProtectedRoute({ children }: { children: ReactNode }) {
  const { isAuthenticated, isLoading } = useAuth()

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-[#F2F2F0]">
        <div className="w-8 h-8 border-2 border-[#8B1A1A] border-t-transparent rounded-full animate-spin" />
      </div>
    )
  }

  // Visitante: em vez de redireccionar bruscamente para /login (o que poderia
  // parecer um erro), apresentamos um convite elegante para entrar ou criar
  // conta, mantendo o Sidebar de Visitante para continuar a explorar.
  if (!isAuthenticated) {
    return <AuthRequired />
  }

  return <>{children}</>
}
