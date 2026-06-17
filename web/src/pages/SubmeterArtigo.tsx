import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

export default function SubmeterArtigo() {
  const navigate = useNavigate()

  return (
    <AppShell title="Submeter Artigo" showSearch={false}>
      <div className="px-10 py-8 max-w-[800px] mx-auto">
        <button onClick={() => navigate('/gestao/conteudos')}
          className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors mb-8 text-sm font-semibold">
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar à Gestão
        </button>

        <div className="bg-white rounded-xl p-10 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)]">
          <h1 className="text-[32px] font-bold text-[#1c1b1b] mb-2">Submeter Novo Artigo</h1>
          <p className="text-base text-[#5d5f5d] mb-8" style={{ fontFamily: 'Merriweather, serif' }}>
            Contribua com o seu conhecimento para o arquivo histórico de Angola.
          </p>

          <form className="space-y-6" onSubmit={(e) => { e.preventDefault(); navigate('/confirmacao/publicacao') }}>
            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Tipo de Conteúdo</label>
              <div className="flex gap-3">
                {['Microtexto', 'Jindungo', 'Documento de Arquivo'].map((type) => (
                  <label key={type} className="flex items-center gap-2 cursor-pointer">
                    <input type="radio" name="type" value={type} defaultChecked={type === 'Microtexto'}
                      className="text-[#8B1A1A]" />
                    <span className="text-sm font-semibold text-[#1c1b1b]">{type}</span>
                  </label>
                ))}
              </div>
            </div>

            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Título</label>
              <input type="text" placeholder="Título do artigo..."
                className="w-full bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg p-4 focus:ring-1 focus:ring-[#8B1A1A] outline-none transition-all"
                style={{ fontFamily: 'Merriweather, serif' }} />
            </div>

            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Categoria</label>
              <select className="w-full bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg p-4 focus:ring-1 focus:ring-[#8B1A1A] outline-none transition-all text-[#1c1b1b]">
                <option>Selecione uma categoria</option>
                <option>Era Colonial</option>
                <option>Pós-Independência</option>
                <option>Comércio Atlântico</option>
                <option>Economia Contemporânea</option>
              </select>
            </div>

            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Conteúdo</label>
              <textarea rows={10} placeholder="Escreva o conteúdo do artigo aqui..."
                className="w-full bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg p-4 focus:ring-1 focus:ring-[#8B1A1A] outline-none transition-all resize-none"
                style={{ fontFamily: 'Merriweather, serif' }} />
            </div>

            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Fontes e Referências</label>
              <textarea rows={3} placeholder="Liste as fontes utilizadas..."
                className="w-full bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg p-4 focus:ring-1 focus:ring-[#8B1A1A] outline-none transition-all resize-none"
                style={{ fontFamily: 'Merriweather, serif' }} />
            </div>

            <div className="flex gap-4 pt-4">
              <button type="button" onClick={() => navigate('/gestao/conteudos')}
                className="flex-1 border border-[#8B1A1A] text-[#8B1A1A] text-sm font-semibold py-4 rounded-full hover:bg-[#f0eded] transition-colors">
                Guardar Rascunho
              </button>
              <button type="submit"
                className="flex-1 bg-[#8B1A1A] text-white text-sm font-semibold py-4 rounded-full hover:opacity-90 transition-all active:scale-95 flex items-center justify-center gap-2">
                Submeter para Revisão
                <span className="material-symbols-outlined text-[18px]">send</span>
              </button>
            </div>
          </form>
        </div>
      </div>
    </AppShell>
  )
}
