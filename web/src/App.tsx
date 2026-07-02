import { AuthProvider } from './contexts/AuthContext'
import { RegistrationProvider } from './contexts/RegistrationContext'
import AppRoutes from './routes/AppRoutes'

export default function App() {
  return (
    <AuthProvider>
      <RegistrationProvider>
        <AppRoutes />
      </RegistrationProvider>
    </AuthProvider>
  )
}
