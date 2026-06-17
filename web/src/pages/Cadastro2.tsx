import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'

export default function Cadastro2() {
  const navigate = useNavigate()
  const { register } = useAuth()
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  useEffect(() => {
    if (!sessionStorage.getItem('reg_name') || !sessionStorage.getItem('reg_email')) {
      navigate('/cadastro')
    }
  }, [navigate])

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError('')
    if (password.length < 8) {
      setError('A palavra-passe deve ter pelo menos 8 caracteres.')
      return
    }
    const name = sessionStorage.getItem('reg_name') ?? ''
    const email = sessionStorage.getItem('reg_email') ?? ''
    setLoading(true)
    try {
      await register({ name, email, password })
      sessionStorage.removeItem('reg_name')
      sessionStorage.removeItem('reg_email')
      navigate('/cadastro/3')
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : 'Erro ao criar conta. Tente novamente.'
      setError(msg)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-6 font-sans" style={{ backgroundColor: '#F2F2F0' }}>
      <div className="mb-8 flex flex-col items-center text-center">
        <h2 className="text-2xl font-bold text-[#8B1A1A] mb-1">Economia com História</h2>
        <p className="text-xs text-[#5d5f5d] tracking-widest uppercase">Angola</p>
      </div>

      <main className="w-full max-w-[480px] bg-white rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.04)] border border-[#e0bfbc]/30 overflow-hidden">
        <div className="h-1.5 w-full bg-[#f0eded] flex">
          <div className="h-full bg-[#8B1A1A] transition-all duration-500" style={{ width: '66.66%' }} />
        </div>

        <div className="p-10 flex flex-col gap-8">
          <header className="flex flex-col gap-2">
            <span className="text-xs font-bold text-[#8B1A1A]">Passo 2 de 3</span>
            <h1 className="text-[32px] font-bold text-[#1c1b1b]">Perfil de Investigador</h1>
            <p className="text-base text-[#5d5f5d] font-serif">
              Diga-nos um pouco mais sobre si para personalizar a sua experiência.
            </p>
          </header>

          <form className="flex flex-col gap-4" onSubmit={handleSubmit}>
            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Área de interesse</label>
              <select className="w-full bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg p-4 focus:ring-1 focus:ring-[#8B1A1A] outline-none transition-all text-[#1c1b1b]">
                <option value="">Selecione a sua área</option>
                <option>História Económica</option>
                <option>Economia Colonial</option>
                <option>Pós-Independência</option>
                <option>Economia Contemporânea</option>
              </select>
            </div>
            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Perfil</label>
              <select className="w-full bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg p-4 focus:ring-1 focus:ring-[#8B1A1A] outline-none transition-all text-[#1c1b1b]">
                <option value="">Selecione o seu perfil</option>
                <option>Estudante</option>
                <option>Académico / Investigador</option>
                <option>Jornalista</option>
                <option>Curioso / Entusiasta</option>
              </select>
            </div>
            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Palavra-passe</label>
              <div className="relative">
                <span className="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-[#5d5f5d] text-[20px]">lock</span>
                <input
                  type="password"
                  placeholder="Mínimo 8 caracteres"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  minLength={8}
                  className="w-full pl-12 pr-4 py-4 bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg focus:ring-1 focus:ring-[#8B1A1A] outline-none transition-all"
                />
              </div>
            </div>

            {error && (
              <p className="text-xs text-red-700 bg-red-50 border border-red-200 rounded-lg px-3 py-2 font-sans">{error}</p>
            )}

            <div className="mt-2 flex gap-4">
              <button
                type="button"
                onClick={() => navigate('/cadastro')}
                className="flex-1 border border-[#8B1A1A] text-[#8B1A1A] text-sm font-semibold py-4 rounded-full hover:bg-[#f0eded] transition-colors"
              >
                Voltar
              </button>
              <button
                type="submit"
                disabled={loading}
                className="flex-1 bg-[#8B1A1A] text-white text-sm font-semibold py-4 rounded-full hover:opacity-90 transition-colors active:scale-95 disabled:opacity-60 disabled:cursor-not-allowed flex items-center justify-center gap-2"
              >
                {loading ? (
                  <>
                    <span className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                    A criar conta...
                  </>
                ) : 'Continuar'}
              </button>
            </div>
          </form>
        </div>
      </main>
    </div>
  )
}
