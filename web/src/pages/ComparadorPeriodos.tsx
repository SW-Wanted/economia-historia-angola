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
      <div className="px-10 py-8 max-w-[1160px] mx-auto">
        <div className="mb-8">
          <h2 className="text-[40px] font-extrabold text-[#1c1b1b] mb-2">Comparador de Períodos Económicos</h2>
          <p className="text-base text-[#5d5f5d]" style={{ fontFamily: 'Merriweather, serif' }}>
            Compare indicadores económicos entre diferentes períodos da história de Angola.
          </p>
        </div>

        {/* Period selectors */}
        <div className="grid grid-cols-2 gap-6 mb-8">
          {[{ label: 'Período A', value: periodA, set: setPeriodA, color: 'border-[#8B1A1A]' },
            { label: 'Período B', value: periodB, set: setPeriodB, color: 'border-[#5d5f5d]' }].map((p) => (
            <div key={p.label}>
              <label className="text-sm font-bold text-[#1c1b1b] mb-2 block">{p.label}</label>
              <select value={p.value} onChange={(e) => p.set(e.target.value)}
                className={`w-full bg-white border-2 ${p.color} rounded-xl p-4 focus:outline-none text-sm font-semibold text-[#1c1b1b]`}>
                {periods.map((per) => <option key={per}>{per}</option>)}
              </select>
            </div>
          ))}
        </div>

        {/* Comparison table */}
        <div className="bg-white rounded-xl border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] overflow-hidden mb-8">
          <div className="grid grid-cols-3 bg-[#f6f3f2] border-b border-[#e0bfbc]">
            <div className="p-4 text-xs font-bold text-[#5d5f5d] uppercase tracking-wider">Indicador</div>
            <div className="p-4 text-xs font-bold text-[#8B1A1A] uppercase tracking-wider border-l border-[#e0bfbc]">{periodA}</div>
            <div className="p-4 text-xs font-bold text-[#5d5f5d] uppercase tracking-wider border-l border-[#e0bfbc]">{periodB}</div>
          </div>
          {[
            { label: 'PIB Estimado', keyA: 'gdp' as const, keyB: 'gdp' as const },
            { label: 'Principais Exportações', keyA: 'exports' as const, keyB: 'exports' as const },
            { label: 'População', keyA: 'population' as const, keyB: 'population' as const },
            { label: 'Setor Principal', keyA: 'mainSector' as const, keyB: 'mainSector' as const },
          ].map((row) => (
            <div key={row.label} className="grid grid-cols-3 border-b border-[#e0bfbc] last:border-0">
              <div className="p-4 text-sm font-semibold text-[#1c1b1b]">{row.label}</div>
              <div className="p-4 text-sm text-[#5d5f5d] border-l border-[#e0bfbc]" style={{ fontFamily: 'Merriweather, serif' }}>{a[row.keyA]}</div>
              <div className="p-4 text-sm text-[#5d5f5d] border-l border-[#e0bfbc]" style={{ fontFamily: 'Merriweather, serif' }}>{b[row.keyB]}</div>
            </div>
          ))}
        </div>

        {/* Related content */}
        <div className="flex gap-4">
          <button onClick={() => navigate('/explorar')}
            className="flex items-center gap-2 bg-[#8B1A1A] text-white px-6 py-3 rounded-full text-sm font-semibold hover:opacity-90 transition-all">
            <span className="material-symbols-outlined text-[18px]">explore</span>
            Explorar Conteúdos
          </button>
          <button onClick={() => navigate('/mapa')}
            className="flex items-center gap-2 border border-[#e0bfbc] text-[#1c1b1b] px-6 py-3 rounded-full text-sm font-semibold hover:bg-[#f6f3f2] transition-all">
            <span className="material-symbols-outlined text-[18px]">map</span>
            Ver no Mapa
          </button>
        </div>
      </div>
    </AppShell>
  )
}
