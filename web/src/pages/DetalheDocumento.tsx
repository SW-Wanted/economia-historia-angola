import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

export default function DetalheDocumento() {
  const navigate = useNavigate()
  const [saved, setSaved] = useState(false)

  return (
    <AppShell title="Arquivo Digital" showSearch={false}>
      <div className="px-10 py-8 max-w-[900px] mx-auto">
        <button onClick={() => navigate('/explorar')}
          className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors mb-8 text-sm font-semibold">
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Arquivo
        </button>

        {/* Document header */}
        <div className="bg-white rounded-xl p-8 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] mb-6">
          <div className="flex items-start gap-6">
            <div className="w-20 h-24 bg-[#8B1A1A] rounded-lg flex items-center justify-center flex-shrink-0">
              <span className="material-symbols-outlined text-white text-4xl">description</span>
            </div>
            <div className="flex-grow">
              <div className="flex items-center gap-3 mb-3">
                <span className="bg-[#8B1A1A]/10 text-[#8B1A1A] px-3 py-1 rounded-full text-xs font-semibold">Documento Histórico</span>
                <span className="text-xs text-[#5d5f5d]">1891</span>
              </div>
              <h1 className="text-[32px] font-bold text-[#1c1b1b] mb-3">Tratado de Comércio de 1891</h1>
              <p className="text-base text-[#5d5f5d] mb-4" style={{ fontFamily: 'Merriweather, serif' }}>
                Documento original que redefiniu as taxas alfandegárias de Luanda e estabeleceu as bases do comércio colonial no final do século XIX.
              </p>
              <div className="flex flex-wrap gap-4 text-xs text-[#5d5f5d]">
                <span className="flex items-center gap-1"><span className="material-symbols-outlined text-[14px]">calendar_today</span>1891</span>
                <span className="flex items-center gap-1"><span className="material-symbols-outlined text-[14px]">location_on</span>Luanda, Angola</span>
                <span className="flex items-center gap-1"><span className="material-symbols-outlined text-[14px]">folder</span>Arquivo Histórico Nacional</span>
                <span className="flex items-center gap-1"><span className="material-symbols-outlined text-[14px]">translate</span>Português</span>
              </div>
            </div>
          </div>

          <div className="flex gap-3 mt-6 pt-6 border-t border-[#e0bfbc]">
            <button className="flex items-center gap-2 bg-[#8B1A1A] text-white px-6 py-3 rounded-full text-sm font-semibold hover:opacity-90 transition-all">
              <span className="material-symbols-outlined text-[18px]">download</span>
              Descarregar PDF
            </button>
            <button onClick={() => setSaved(!saved)} className={`flex items-center gap-2 border px-6 py-3 rounded-full text-sm font-semibold transition-all ${saved ? 'border-[#8B1A1A] text-[#8B1A1A] bg-[#8B1A1A]/5' : 'border-[#e0bfbc] text-[#1c1b1b] hover:bg-[#f6f3f2]'}`}>
              <span className="material-symbols-outlined text-[18px]" style={saved ? { fontVariationSettings: "'FILL' 1" } : undefined}>bookmark</span>
              {saved ? 'Guardado' : 'Guardar'}
            </button>
            <button onClick={() => navigate('/forum/detalhe')}
              className="flex items-center gap-2 border border-[#e0bfbc] text-[#1c1b1b] px-6 py-3 rounded-full text-sm font-semibold hover:bg-[#f6f3f2] transition-all">
              <span className="material-symbols-outlined text-[18px]">forum</span>
              Discutir
            </button>
          </div>
        </div>

        {/* Document preview */}
        <div className="bg-white rounded-xl border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] mb-6">
          <div className="p-6 border-b border-[#e0bfbc] flex items-center justify-between">
            <h2 className="text-xl font-bold text-[#1c1b1b]">Pré-visualização do Documento</h2>
            <span className="text-xs text-[#5d5f5d]">Página 1 de 12</span>
          </div>
          <div className="p-8 bg-[#f6f3f2] min-h-[400px] flex items-center justify-center">
            <div className="bg-white w-full max-w-[600px] p-12 shadow-lg rounded" style={{ fontFamily: 'Merriweather, serif' }}>
              <div className="text-center mb-8">
                <p className="text-xs text-[#5d5f5d] uppercase tracking-widest mb-2">Governo Geral da Província de Angola</p>
                <h2 className="text-2xl font-bold text-[#1c1b1b] mb-1">TRATADO DE COMÉRCIO</h2>
                <p className="text-sm text-[#5d5f5d]">Entre o Governo Português e as Casas Comerciais de Luanda</p>
                <p className="text-sm text-[#5d5f5d]">Anno de 1891</p>
              </div>
              <div className="border-t border-[#e0bfbc] pt-6 space-y-4 text-sm text-[#5d5f5d] leading-relaxed">
                <p>Artigo I.º — Ficam estabelecidas as seguintes taxas alfandegárias para os produtos de importação e exportação pela barra do porto de Luanda...</p>
                <p>Artigo II.º — Os produtos de origem angolana, nomeadamente café, borracha e marfim, beneficiarão de taxas preferenciais conforme o disposto no presente tratado...</p>
                <p className="italic opacity-60">[ Documento continua... ]</p>
              </div>
            </div>
          </div>
        </div>

        {/* Related documents */}
        <div>
          <h3 className="text-2xl font-bold text-[#1c1b1b] mb-4">Documentos Relacionados</h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {[
              'Regulamento Alfandegário de 1885',
              'Acordo Comercial Luso-Britânico de 1898',
            ].map((doc) => (
              <button key={doc} onClick={() => navigate('/documento/detalhe')}
                className="bg-white rounded-xl p-4 border border-[#e0bfbc] hover:border-[#8B1A1A] hover:shadow-md transition-all text-left flex items-center gap-4 group">
                <div className="w-10 h-12 bg-[#8B1A1A]/10 rounded flex items-center justify-center flex-shrink-0">
                  <span className="material-symbols-outlined text-[#8B1A1A] text-sm">description</span>
                </div>
                <span className="text-sm font-semibold text-[#1c1b1b] group-hover:text-[#8B1A1A] transition-colors">{doc}</span>
              </button>
            ))}
          </div>
        </div>
      </div>
    </AppShell>
  )
}
