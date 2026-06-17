import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const lines = [
  { name: 'Caminho de Ferro de Benguela (CFB)', from: 'Benguela', to: 'Luau (fronteira com RDC)', length: '1,344 km', built: '1903–1929', status: 'Reabilitado (2015)' },
  { name: 'Caminho de Ferro de Luanda (CFL)', from: 'Luanda', to: 'Malanje', length: '424 km', built: '1886–1909', status: 'Operacional' },
  { name: 'Caminho de Ferro de Moçâmedes (CFM)', from: 'Namibe', to: 'Menongue', length: '756 km', built: '1905–1961', status: 'Parcialmente operacional' },
]

export default function MapaCaminhosHist() {
  const navigate = useNavigate()

  return (
    <AppShell title="Caminhos de Ferro Históricos" showSearch={false}>
      <div className="px-10 py-8 max-w-[1160px] mx-auto">
        <button onClick={() => navigate('/mapa')}
          className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors mb-8 text-sm font-semibold">
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Mapa
        </button>

        <div className="mb-8">
          <h2 className="text-[40px] font-extrabold text-[#1c1b1b] mb-2">Caminhos de Ferro Históricos</h2>
          <p className="text-lg text-[#5d5f5d] max-w-2xl" style={{ fontFamily: 'Merriweather, serif' }}>
            A rede ferroviária angolana foi um dos pilares da economia colonial, ligando o interior ao litoral para escoamento de recursos.
          </p>
        </div>

        {/* Map placeholder */}
        <div className="bg-white rounded-xl border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] mb-8 overflow-hidden">
          <div className="h-80 bg-[#f6f3f2] flex items-center justify-center relative">
            <svg viewBox="0 0 400 500" className="w-full h-full max-h-[300px] opacity-15" fill="none" stroke="#8B1A1A" strokeWidth="2">
              <path d="M180,40 L220,60 L260,50 L300,80 L320,140 L280,220 L260,300 L220,360 L160,340 L100,300 L80,240 L60,180 L80,100 L140,60 Z" />
              {/* Railway lines */}
              <path d="M100,300 L200,200 L300,150" stroke="#8B1A1A" strokeWidth="3" strokeDasharray="8,4" />
              <path d="M180,40 L180,200 L160,340" stroke="#5d5f5d" strokeWidth="3" strokeDasharray="8,4" />
              <path d="M80,240 L180,280 L260,300" stroke="#8c716e" strokeWidth="3" strokeDasharray="8,4" />
            </svg>
            <div className="absolute inset-0 flex flex-col items-center justify-center">
              <span className="material-symbols-outlined text-[#8B1A1A]/20" style={{ fontSize: '60px' }}>train</span>
              <p className="text-base font-semibold text-[#5d5f5d] mt-2">Mapa das Linhas Ferroviárias</p>
            </div>
          </div>
          <div className="p-4 border-t border-[#e0bfbc] flex gap-6 text-xs">
            <span className="flex items-center gap-2"><span className="w-8 h-0.5 bg-[#8B1A1A] inline-block" style={{ borderTop: '2px dashed #8B1A1A' }} />CFB</span>
            <span className="flex items-center gap-2"><span className="w-8 h-0.5 bg-[#5d5f5d] inline-block" style={{ borderTop: '2px dashed #5d5f5d' }} />CFL</span>
            <span className="flex items-center gap-2"><span className="w-8 h-0.5 bg-[#8c716e] inline-block" style={{ borderTop: '2px dashed #8c716e' }} />CFM</span>
          </div>
        </div>

        {/* Lines detail */}
        <div className="space-y-4 mb-8">
          {lines.map((line) => (
            <div key={line.name} className="bg-white rounded-xl p-6 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)]">
              <div className="flex items-start justify-between mb-4">
                <div>
                  <h3 className="text-xl font-bold text-[#1c1b1b] mb-1">{line.name}</h3>
                  <p className="text-sm text-[#5d5f5d]">{line.from} → {line.to}</p>
                </div>
                <span className={`text-xs font-semibold px-3 py-1 rounded-full ${line.status === 'Operacional' ? 'bg-green-100 text-green-800' : line.status.includes('Reabilitado') ? 'bg-blue-100 text-blue-800' : 'bg-amber-100 text-amber-800'}`}>
                  {line.status}
                </span>
              </div>
              <div className="grid grid-cols-3 gap-4">
                {[
                  { label: 'Extensão', value: line.length },
                  { label: 'Construção', value: line.built },
                  { label: 'Estado', value: line.status },
                ].map((d) => (
                  <div key={d.label} className="bg-[#f6f3f2] rounded-lg p-3">
                    <p className="text-xs text-[#5d5f5d] uppercase tracking-wider mb-1">{d.label}</p>
                    <p className="text-sm font-semibold text-[#1c1b1b]">{d.value}</p>
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>

        <button onClick={() => navigate('/leitura/microtexto')}
          className="flex items-center gap-2 bg-[#8B1A1A] text-white px-6 py-3 rounded-full text-sm font-semibold hover:opacity-90 transition-all">
          <span className="material-symbols-outlined text-[18px]">article</span>
          Ler artigo sobre o CFB
        </button>
      </div>
    </AppShell>
  )
}
