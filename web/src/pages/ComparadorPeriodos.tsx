import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const periods = ['Pré-Colonial (até 1575)', 'Colonial (1575–1975)', 'Pós-Independência (1975–2002)', 'Contemporâneo (2002–)']

const data: Record<string, { gdp: string; exports: string; population: string; mainSector: string }> = {
  'Pré-Colonial (até 1575)': { gdp: 'N/A', exports: 'Marfim, Escravos', population: '~2M', mainSector: 'Agricultura de subsistência' },
  'Colonial (1575–1975)': { gdp: 'Controlado por Portugal', exports: 'Café, Diamantes, Petróleo', population: '~5M', mainSector: 'Extração de recursos' },
  'Pós-Independência (1975–2002)': { gdp: 'Instável (guerra civil)', exports: 'Petróleo, Diamantes', population: '~12M', mainSector: 'Petróleo' },
  'Contemporâneo (2002–)': { gdp: '$75B (2023)', exports: 'Petróleo, Diamantes, Café', population: '~35M', mainSector: 'Petróleo e Diversificação' },
}

export default function ComparadorPeriodos() {
  const navigate = useNavigate()
  const [periodA, setPeriodA] = useState(periods[1])
  const [periodB, setPeriodB] = useState(periods[3])

  const a = data[periodA]
  const b = data[periodB]

  return (
    <AppShell title="Comparador de Períodos" showSearch={false}>
      <div className="page-content animate-fade-in">
        <div className="mb-8">
          <h2 className="text-display-web font-extrabold text-text font-sans tracking-tight mb-2">Comparador de Períodos Económicos</h2>
          <p className="text-body-md font-body text-secondary">
            Compare indicadores económicos entre diferentes períodos da história de Angola.
          </p>
        </div>

        {/* Period selectors */}
        <div className="grid grid-cols-2 gap-6 mb-8">
          {[
            { label: 'Período A', value: periodA, set: setPeriodA, border: 'border-primary' },
            { label: 'Período B', value: periodB, set: setPeriodB, border: 'border-secondary' },
          ].map((p) => (
            <div key={p.label}>
              <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em] mb-2 block">{p.label}</label>
              <select
                value={p.value}
                onChange={(e) => p.set(e.target.value)}
                className={`w-full bg-surface border-2 ${p.border} rounded-card p-4 focus:outline-none text-sm font-semibold text-text font-sans`}
              >
                {periods.map((per) => <option key={per}>{per}</option>)}
              </select>
            </div>
          ))}
        </div>

        {/* Comparison table */}
        <div className="bg-surface rounded-card border border-outline-variant/45 shadow-card overflow-hidden mb-8">
          <div className="grid grid-cols-3 bg-surface-container-low border-b border-outline-variant/45">
            <div className="p-4 text-label-md font-bold text-text-muted uppercase tracking-wider font-sans">Indicador</div>
            <div className="p-4 text-label-md font-bold text-primary uppercase tracking-wider border-l border-outline-variant/45 font-sans">{periodA}</div>
            <div className="p-4 text-label-md font-bold text-secondary uppercase tracking-wider border-l border-outline-variant/45 font-sans">{periodB}</div>
          </div>
          {[
            { label: 'PIB Estimado', keyA: 'gdp' as const, keyB: 'gdp' as const },
            { label: 'Principais Exportações', keyA: 'exports' as const, keyB: 'exports' as const },
            { label: 'População', keyA: 'population' as const, keyB: 'population' as const },
            { label: 'Setor Principal', keyA: 'mainSector' as const, keyB: 'mainSector' as const },
          ].map((row) => (
            <div key={row.label} className="grid grid-cols-3 border-b border-outline-variant/30 last:border-0">
              <div className="p-4 text-sm font-semibold text-text font-sans">{row.label}</div>
              <div className="p-4 text-sm text-secondary border-l border-outline-variant/30 font-body">{a[row.keyA]}</div>
              <div className="p-4 text-sm text-secondary border-l border-outline-variant/30 font-body">{b[row.keyB]}</div>
            </div>
          ))}
        </div>

        {/* Related content */}
        <div className="flex gap-4">
          <button
            onClick={() => navigate('/explorar')}
            className="btn-primary"
          >
            <span className="material-symbols-outlined text-[18px]">explore</span>
            Explorar Conteúdos
          </button>
          <button onClick={() => navigate('/mapa')} className="btn-secondary">
            <span className="material-symbols-outlined text-[18px]">map</span>
            Ver no Mapa
          </button>
        </div>
      </div>
    </AppShell>
  )
}
