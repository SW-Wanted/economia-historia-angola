import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

export default function SubmeterTopico() {
  const navigate = useNavigate()

  return (
    <AppShell title="Novo Tópico" showSearch={false}>
      <div className="px-10 py-16 max-w-[800px] mx-auto">
        <button
          onClick={() => navigate('/forum')}
          className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors mb-8 text-sm font-semibold"
        >
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Fórum
        </button>

        <div className="bg-white rounded-xl p-10 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)]">
          <h1 className="text-[32px] font-bold text-[#1c1b1b] mb-2">Submeter Novo Tópico</h1>
          <p className="text-base text-[#5d5f5d] mb-8" style={{ fontFamily: 'Merriweather, serif' }}>
            Partilhe a sua investigação ou inicie um debate com a comunidade.
          </p>

          <form className="space-y-6" onSubmit={(e) => { e.preventDefault(); navigate('/forum') }}>
            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Título do Tópico</label>
              <input
                type="text"
                placeholder="Ex: O impacto do café na economia do Huambo..."
                className="w-full bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg p-4 focus:ring-1 focus:ring-[#8B1A1A] outline-none transition-all"
                style={{ fontFamily: 'Merriweather, serif' }}
              />
            </div>

            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Categoria</label>
              <select className="w-full bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg p-4 focus:ring-1 focus:ring-[#8B1A1A] outline-none transition-all text-[#1c1b1b]">
                <option value="">Selecione uma categoria</option>
                <option>Microtextos</option>
                <option>Economia Colonial</option>
                <option>Pós-Independência</option>
                <option>Arquivos Históricos</option>
                <option>Jindungo</option>
              </select>
            </div>

            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Conteúdo</label>
              <textarea
                rows={8}
                placeholder="Desenvolva o seu tópico aqui. Seja específico e fundamentado nas fontes..."
                className="w-full bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg p-4 focus:ring-1 focus:ring-[#8B1A1A] outline-none transition-all resize-none"
                style={{ fontFamily: 'Merriweather, serif' }}
              />
            </div>

            <div className="flex gap-4 pt-4">
              <button
                type="button"
                onClick={() => navigate('/forum')}
                className="flex-1 border border-[#8B1A1A] text-[#8B1A1A] text-sm font-semibold py-4 rounded-full hover:bg-[#f0eded] transition-colors"
              >
                Cancelar
              </button>
              <button
                type="submit"
                className="flex-1 bg-[#8B1A1A] text-white text-sm font-semibold py-4 rounded-full hover:opacity-90 transition-all active:scale-95 flex items-center justify-center gap-2"
              >
                Publicar Tópico
                <span className="material-symbols-outlined text-[18px]">send</span>
              </button>
            </div>
          </form>
        </div>
      </div>
    </AppShell>
  )
}
