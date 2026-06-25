import { useState, useEffect } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'

export default function Login() {
  const navigate = useNavigate()
  const location = useLocation()
  const { login, isAuthenticated } = useAuth()

  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [oauthInfo, setOauthInfo] = useState('')

  const from = (location.state as { from?: { pathname: string } } | null)?.from?.pathname ?? '/dashboard'

  useEffect(() => {
    if (isAuthenticated) navigate(from, { replace: true })
  }, [isAuthenticated, navigate, from])

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError('')
    if (!email.trim() || !password) {
      setError('Preencha o email e a palavra-passe.')
      return
    }
    setLoading(true)
    try {
      await login({ email: email.trim(), password })
      navigate(from, { replace: true })
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : 'Erro ao iniciar sessão. Tente novamente.'
      setError(msg)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center relative overflow-hidden font-sans" style={{ backgroundColor: '#F2F2F0' }}>
      <div className="absolute inset-0 opacity-[0.035]" style={{ backgroundImage: 'radial-gradient(#8B1A1A 0.5px, transparent 0.5px)', backgroundSize: '20px 20px' }} />

      <main className="w-full max-w-[440px] px-4 z-10">
        <div className="bg-white rounded-2xl shadow-lg border border-[#ebe5e4] px-8 py-10 flex flex-col items-center">
          {/* Logo */}
          <div className="mb-7 flex flex-col items-center gap-2">
            <div className="w-12 h-12 rounded-xl bg-[#fff5f4] flex items-center justify-center">
              <span className="material-symbols-outlined text-[#8B1A1A]" style={{ fontSize: '28px', fontVariationSettings: "'FILL' 1" }}>account_balance</span>
            </div>
            <div className="text-center">
              <h1 className="font-bold text-[#8B1A1A] text-base tracking-tight font-sans">Economia com História</h1>
              <p className="text-[10px] text-[#8c716e] uppercase tracking-[0.12em] font-sans mt-0.5">Angola</p>
            </div>
          </div>

          <div className="text-center mb-7">
            <h2 className="text-2xl font-bold text-[#1c1b1b] font-sans tracking-tight">Aceda à sua conta</h2>
            <p className="text-sm text-[#5d5f5d] mt-1.5 font-serif">Aceda à sua conta para continuar a ler.</p>
          </div>

          <form className="w-full space-y-4" onSubmit={handleSubmit}>
            <div className="space-y-1.5">
              <label className="block text-xs font-semibold text-[#58413f] font-sans uppercase tracking-[0.05em]">Email</label>
              <div className="relative">
                <span className="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-[#b8a5a3] text-[18px] pointer-events-none">mail</span>
                <input
                  type="email"
                  placeholder="nome@exemplo.com"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  className="w-full pl-10 pr-4 py-2.5 bg-[#f8f5f4] rounded-lg border border-[#e8e0de] focus:bg-white focus:border-[#8B1A1A] focus:ring-2 focus:ring-[#8B1A1A]/10 outline-none transition-all duration-150 text-sm font-serif placeholder:text-[#c4b5b3]"
                />
              </div>
            </div>

            <div className="space-y-1.5">
              <label className="block text-xs font-semibold text-[#58413f] font-sans uppercase tracking-[0.05em]">Palavra-passe</label>
              <div className="relative">
                <span className="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-[#b8a5a3] text-[18px] pointer-events-none">lock</span>
                <input
                  type="password"
                  placeholder="••••••••"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  className="w-full pl-10 pr-12 py-2.5 bg-[#f8f5f4] rounded-lg border border-[#e8e0de] focus:bg-white focus:border-[#8B1A1A] focus:ring-2 focus:ring-[#8B1A1A]/10 outline-none transition-all duration-150 text-sm"
                />
              </div>
            </div>

            {error && (
              <p className="text-xs text-red-700 bg-red-50 border border-red-200 rounded-lg px-3 py-2 font-sans">
                {error}
              </p>
            )}

            <div className="flex items-center justify-between py-1">
              <label className="flex items-center gap-2 cursor-pointer">
                <input type="checkbox" className="w-4 h-4 rounded border-[#e0bfbc] accent-[#8B1A1A]" />
                <span className="text-sm text-[#5d5f5d]">Lembrar-me</span>
              </label>
              <button
                type="button"
                onClick={() => navigate('/recuperar-senha')}
                className="text-sm text-[#8B1A1A] hover:text-[#6e1515] font-semibold font-sans transition-colors duration-150"
              >
                Esqueceu a senha?
              </button>
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-[#8B1A1A] text-white text-sm font-semibold py-3 rounded-full hover:bg-[#7a1616] hover:shadow-md active:scale-[0.99] transition-all duration-150 font-sans mt-1 disabled:opacity-60 disabled:cursor-not-allowed flex items-center justify-center gap-2"
            >
              {loading ? (
                <>
                  <span className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                  A entrar...
                </>
              ) : 'Entrar'}
            </button>
          </form>

          <div className="w-full flex items-center gap-3 my-6">
            <div className="h-px flex-grow bg-[#ebe5e4]" />
            <span className="text-[11px] text-[#b8a5a3] uppercase tracking-[0.1em] font-sans whitespace-nowrap">ou aceder com</span>
            <div className="h-px flex-grow bg-[#ebe5e4]" />
          </div>

          <div className="w-full flex flex-col gap-2 mb-7">
            <div className="flex gap-3">
              <button
                onClick={() => setOauthInfo('O acesso via Google ainda não está disponível. Por favor, utilize o email e palavra-passe.')}
                className="flex-1 flex items-center justify-center gap-2 py-2.5 border border-[#e8e0de] rounded-lg text-sm font-semibold text-[#8c716e] hover:bg-[#f8f5f4] hover:border-[#d4c5c3] transition-all duration-150 font-sans opacity-60 cursor-not-allowed"
              >
                <span className="material-symbols-outlined text-[18px] text-[#5d5f5d]">language</span>
                Google
              </button>
              <button
                onClick={() => setOauthInfo('O acesso via LinkedIn ainda não está disponível. Por favor, utilize o email e palavra-passe.')}
                className="flex-1 flex items-center justify-center gap-2 py-2.5 border border-[#e8e0de] rounded-lg text-sm font-semibold text-[#8c716e] hover:bg-[#f8f5f4] hover:border-[#d4c5c3] transition-all duration-150 font-sans opacity-60 cursor-not-allowed"
              >
                <span className="material-symbols-outlined text-[18px] text-[#5d5f5d]">work</span>
                LinkedIn
              </button>
            </div>
            {oauthInfo && (
              <p className="text-xs text-[#8c716e] bg-[#f8f5f4] border border-[#e8e0de] rounded-lg px-3 py-2 text-center font-sans">{oauthInfo}</p>
            )}
          </div>

          <div className="text-center pt-5 border-t border-[#ebe5e4] w-full">
            <p className="text-sm text-[#5d5f5d] font-serif">
              Não tem conta?{' '}
              <button onClick={() => navigate('/cadastro')} className="text-[#8B1A1A] font-bold hover:text-[#6e1515] transition-colors duration-150 font-sans ml-1">
                Criar conta grátis
              </button>
            </p>
          </div>
        </div>

        <div className="mt-6 flex justify-center gap-6">
          {['Sobre', 'Termos', 'Privacidade', 'Contacto'].map((l) => (
            <button key={l} onClick={() => navigate('/ajuda')} className="text-xs text-[#b8a5a3] hover:text-[#8B1A1A] transition-colors duration-150 font-sans">
              {l}
            </button>
          ))}
        </div>
      </main>
    </div>
  )
}
