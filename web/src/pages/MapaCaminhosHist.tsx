import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const lines = [
  { name: 'Caminho de Ferro de Benguela (CFB)', from: 'Benguela', to: 'Luau (fronteira com RDC)', length: '1,344 km', built: '1903–1929', status: 'Reabilitado (2015)' },
  { name: 'Caminho de Ferro de Luanda (CFL)', from: 'Luanda', to: 'Malanje', length: '424 km', built: '1886–1909', status: 'Operacional' },
  { name: 'Caminho de Ferro de Moçâmedes (CFM)', from: 'Namibe', to: 'Menongue', length: '756 km', built: '1905–1961', status: 'Parcialmente operacional' },
]

function statusColor(status: string): string {
  if (status === 'Operacional') return 'bg-success/10 text-success'
  if (status.includes('Reabilitado')) return 'bg-navy/10 text-navy'
  return 'bg-warning/10 text-warning'
}

export default function MapaCaminhosHist() {
  const navigate = useNavigate()

  return (
    <AppShell title="Caminhos de Ferro Históricos" showSearch={false}>
      <div className="page-content animate-fade-in">
        <button
          onClick={() => navigate('/mapa')}
          className="flex items-center gap-2 text-secondary hover:text-primary transition-colors mb-8 text-sm font-semibold font-sans"
        >
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Mapa
        </button>

        <div className="mb-8">
          <h2 className="text-display-web font-extrabold text-text font-sans tracking-tight mb-2">Caminhos de Ferro Históricos</h2>
          <p className="text-lg text-secondary max-w-2xl font-reading">
            A rede ferroviária angolana foi um dos pilares da economia colonial, ligando o interior ao litoral para escoamento de recursos.
          </p>
        </div>

        {/* Map placeholder */}
        <div className="bg-surface rounded-card border border-outline-variant/45 shadow-card mb-8 overflow-hidden">
          <div className="h-80 bg-surface-container-low flex items-center justify-center relative">
            <svg viewBox="0 0 400 500" className="w-full h-full max-h-[300px] opacity-15" fill="none" stroke="#8B1A1A" strokeWidth="2">
              <path d="M180,40 L220,60 L260,50 L300,80 L320,140 L280,220 L260,300 L220,360 L160,340 L100,300 L80,240 L60,180 L80,100 L140,60 Z" />
              <path d="M100,300 L200,200 L300,150" stroke="#8B1A1A" strokeWidth="3" strokeDasharray="8,4" />
              <path d="M180,40 L180,200 L160,340" stroke="#5d5f5d" strokeWidth="3" strokeDasharray="8,4" />
              <path d="M80,240 L180,280 L260,300" stroke="#8c716e" strokeWidth="3" strokeDasharray="8,4" />
            </svg>
            <div className="absolute inset-0 flex flex-col items-center justify-center">
              <span className="material-symbols-outlined text-primary/20" style={{ fontSize: '60px' }}>train</span>
              <p className="text-base font-semibold text-secondary mt-2 font-sans">Mapa das Linhas Ferroviárias</p>
            </div>
          </div>
          <div className="p-4 border-t border-outline-variant/45 flex gap-6 text-xs font-body text-secondary">
            <span className="flex items-center gap-2"><span className="w-8 h-0 border-t-2 border-dashed border-primary inline-block" />CFB</span>
            <span className="flex items-center gap-2"><span className="w-8 h-0 border-t-2 border-dashed border-secondary inline-block" />CFL</span>
            <span className="flex items-center gap-2"><span className="w-8 h-0 border-t-2 border-dashed border-text-muted inline-block" />CFM</span>
          </div>
        </div>

        {/* Lines detail */}
        <div className="space-y-4 mb-8">
          {lines.map((line) => (
            <div key={line.name} className="card p-6">
              <div className="flex items-start justify-between mb-4">
                <div>
                  <h3 className="text-xl font-bold text-text mb-1 font-sans">{line.name}</h3>
                  <p className="text-sm text-secondary font-body">{line.from} → {line.to}</p>
                </div>
                <span className={`text-xs font-semibold px-3 py-1 rounded-full font-sans ${statusColor(line.status)}`}>
                  {line.status}
                </span>
              </div>
              <div className="grid grid-cols-3 gap-4">
                {[
                  { label: 'Extensão', value: line.length },
                  { label: 'Construção', value: line.built },
                  { label: 'Estado', value: line.status },
                ].map((d) => (
                  <div key={d.label} className="bg-surface-container-low rounded-button p-3">
                    <p className="text-label-md text-text-muted uppercase tracking-wider mb-1 font-sans">{d.label}</p>
                    <p className="text-sm font-semibold text-text font-sans">{d.value}</p>
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>

        <button
          onClick={() => navigate('/leitura/microtexto')}
          className="btn-primary"
        >
          <span className="material-symbols-outlined text-[18px]">article</span>
          Ler artigo sobre o CFB
        </button>
      </div>
    </AppShell>
  )
}
