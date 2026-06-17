import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { authService } from '../services/api/auth.service'

export default function RecuperarSenha() {
  const navigate = useNavigate()
  const [email, setEmail] = useState('')
  const [loading, setLoading] = useState(false)
  const [sent, setSent] = useState(false)
  const [error, setError] = useState('')

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError('')
    if (!email.trim()) { setError('Por favor, introduza o seu email.'); return }
    setLoading(true)
    try {
      await authService.forgotPassword(email.trim())
      setSent(true)
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : 'Erro ao enviar instruções. Tente novamente.'
      setError(msg)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center p-6 font-sans relative" style={{ backgroundColor: '#F2F2F0' }}>
      <div className="absolute inset-0 opacity-5 pointer-events-none" style={{ backgroundImage: 'radial-gradient(#8B1A1A 0.5px, transparent 0.5px)', backgroundSize: '24px 24px' }} />

      <main className="w-full max-w-[480px] z-10">
        <div className="flex flex-col items-center mb-8 text-center">
          <span className="material-symbols-outlined text-[#8B1A1A] mb-4" style={{ fontSize: '48px', fontVariationSettings: "'FILL' 1" }}>history_edu</span>
          <h1 className="text-2xl font-bold text-[#8B1A1A] tracking-tight">Economia com História</h1>
          <p className="text-xs text-[#5d5f5d] uppercase tracking-widest mt-1">Angola</p>
        </div>

        <div className="bg-white rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.04)] p-10 border border-[#e0bfbc]/30">
          {sent ? (
            <div className="flex flex-col items-center text-center gap-5 py-4">
              <div className="w-14 h-14 rounded-full bg-green-50 flex items-center justify-center">
                <span className="material-symbols-outlined text-green-600 text-[32px]">mark_email_read</span>
              </div>
              <div>
                <h2 className="text-2xl font-bold text-[#1c1b1b] mb-2">Email Enviado</h2>
                <p className="text-sm text-[#5d5f5d] font-serif leading-relaxed">
                  Se o endereço <strong>{email}</strong> estiver registado, receberá instruções de recuperação em breve.
                </p>
              </div>
              <button
                onClick={() => navigate('/login')}
                className="mt-2 text-sm font-bold text-[#8B1A1A] hover:text-[#6e1515] transition-colors font-sans"
              >
                Voltar para o Login
              </button>
            </div>
          ) : (
            <>
              <div className="mb-8">
                <h2 className="text-[32px] font-bold text-[#1c1b1b] mb-2">Recuperar Senha</h2>
                <p className="text-base text-[#5d5f5d] font-serif">
                  Introduza o seu e-mail para receber as instruções de recuperação.
                </p>
              </div>

              <form className="space-y-4" onSubmit={handleSubmit}>
                <div className="flex flex-col gap-2">
                  <label className="text-sm font-semibold text-[#58413f]">Email</label>
                  <div className="relative">
                    <span className="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-[#5d5f5d] text-[20px]">mail</span>
                    <input
                      type="email"
                      placeholder="exemplo@email.com"
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      required
                      className="w-full pl-12 pr-4 py-4 bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg focus:ring-2 focus:ring-[#8B1A1A] focus:border-transparent outline-none transition-all font-serif"
                    />
                  </div>
                </div>

                {error && (
                  <p className="text-xs text-red-700 bg-red-50 border border-red-200 rounded-lg px-3 py-2 font-sans">{error}</p>
                )}

                <button
                  type="submit"
                  disabled={loading}
                  className="w-full bg-[#8B1A1A] text-white text-xl font-semibold py-4 rounded-full hover:opacity-90 transition-all active:scale-[0.98] mt-4 flex items-center justify-center gap-2 disabled:opacity-60 disabled:cursor-not-allowed"
                >
                  {loading ? (
                    <>
                      <span className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin" />
                      A enviar...
                    </>
                  ) : (
                    <>
                      Enviar Instruções
                      <span className="material-symbols-outlined text-[20px]">arrow_forward</span>
                    </>
                  )}
                </button>
              </form>

              <div className="mt-8 text-center pt-4 border-t border-[#e0bfbc]/20">
                <button
                  onClick={() => navigate('/login')}
                  className="inline-flex items-center gap-2 text-sm font-bold text-[#8B1A1A] hover:text-[#8b1a1a]/80 transition-colors group"
                >
                  <span className="material-symbols-outlined text-[18px] group-hover:-translate-x-1 transition-transform">arrow_back</span>
                  Voltar para o Login
                </button>
              </div>
            </>
          )}
        </div>

        <footer className="mt-16 text-center">
          <p className="text-xs text-[#c6c7c5]">© 2026 Economia com História – Angola. Todos os direitos reservados.</p>
        </footer>
      </main>
    </div>
  )
}
