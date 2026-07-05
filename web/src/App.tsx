import { AuthProvider } from './contexts/AuthContext'
import { AuthGateProvider } from './contexts/AuthGateContext'
import { RegistrationProvider } from './contexts/RegistrationContext'
import AppRoutes from './routes/AppRoutes'

export default function App() {
  return (
    <AuthProvider>
      <AuthGateProvider>
        <RegistrationProvider>
          <AppRoutes />
        </RegistrationProvider>
      </AuthGateProvider>
    </AuthProvider>
  )
}
