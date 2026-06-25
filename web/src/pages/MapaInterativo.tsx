import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const provinces = [
  'Luanda', 'Benguela', 'Huambo', 'Bié', 'Malanje', 'Lunda Norte',
  'Lunda Sul', 'Moxico', 'Cuando Cubango', 'Cunene', 'Namibe',
  'Huíla', 'Kwanza Sul', 'Kwanza Norte', 'Uíge', 'Zaire', 'Cabinda',
]

const PROVINCE_ARTICLE_COUNT: Record<string, number> = {
  'Luanda': 24, 'Benguela': 15, 'Huambo': 12, 'Bié': 8, 'Malanje': 7,
  'Lunda Norte': 18, 'Lunda Sul': 14, 'Moxico': 6, 'Cuando Cubango': 5,
  'Cunene': 4, 'Namibe': 9, 'Huíla': 11, 'Kwanza Sul': 10,
  'Kwanza Norte': 7, 'Uíge': 8, 'Zaire': 6, 'Cabinda': 13,
}

const eras = ['Pré-Colonial', 'Era Colonial (1575–1975)', 'Pós-Independência (1975–2002)', 'Era Contemporânea (2002–)']

export default function MapaInterativo() {
  const navigate = useNavigate()
  const [activeEra, setActiveEra] = useState('Era Colonial (1575–1975)')
  const [hoveredProvince, setHoveredProvince] = useState<string | null>(null)

  return (
    <AppShell title="Mapa Económico" searchPlaceholder="Pesquisar províncias ou rotas...">
      <div className="px-10 py-16 max-w-[1160px] mx-auto">
        <div className="mb-8">
          <h2 className="text-[48px] font-extrabold mb-4 leading-tight text-[#1c1b1b]">Mapa Económico de Angola</h2>
          <p className="text-lg text-[#5d5f5d] max-w-2xl" style={{ fontFamily: 'Merriweather, serif' }}>
            Visualize a evolução das províncias, desde as primeiras feitorias até aos atuais pólos de desenvolvimento industrial.
          </p>
        </div>

        {/* Era selector */}
        <div className="flex flex-wrap gap-3 mb-8">
          {eras.map((era) => (
            <button
              key={era}
              onClick={() => setActiveEra(era)}
              className={`px-6 py-2 rounded-full text-sm font-semibold transition-all ${
                activeEra === era
                  ? 'bg-[#8B1A1A] text-white'
                  : 'bg-white border border-[#e0bfbc] text-[#1c1b1b] hover:border-[#8B1A1A] hover:text-[#8B1A1A]'
              }`}
            >
              {era}
            </button>
          ))}
        </div>

        {/* Map placeholder */}
        <div className="relative bg-white rounded-xl overflow-hidden shadow-[0px_4px_20px_rgba(0,0,0,0.04)] border border-[#e0bfbc] mb-8">
          <div className="aspect-video bg-[#f6f3f2] flex items-center justify-center relative">
            <svg viewBox="0 0 400 500" className="w-full h-full max-h-[500px] opacity-20" fill="none" stroke="#8B1A1A" strokeWidth="2">
              <path d="M180,40 L220,60 L260,50 L300,80 L320,140 L280,220 L260,300 L220,360 L160,340 L100,300 L80,240 L60,180 L80,100 L140,60 Z" />
            </svg>
            <div className="absolute inset-0 flex flex-col items-center justify-center">
              <span className="material-symbols-outlined text-[#8B1A1A]/30" style={{ fontSize: '80px' }}>map</span>
              <p className="text-2xl font-bold text-[#5d5f5d] mt-4">Mapa Interativo — {activeEra}</p>
              <p className="text-base text-[#5d5f5d]/60 mt-2">Clique numa província abaixo para explorar</p>
            </div>
          </div>
        </div>

        {/* Featured layer */}
        <div className="mb-8">
          <button
            onClick={() => navigate('/mapa/caminhos-ferro')}
            className="w-full bg-white rounded-xl p-6 border border-[#e0bfbc] hover:border-[#8B1A1A] hover:shadow-md transition-all text-left flex items-center gap-6 group"
          >
            <div className="w-14 h-14 bg-[#8B1A1A]/10 rounded-xl flex items-center justify-center flex-shrink-0 group-hover:bg-[#8B1A1A] transition-colors">
              <span className="material-symbols-outlined text-[#8B1A1A] text-3xl group-hover:text-white transition-colors">train</span>
            </div>
            <div className="flex-grow">
              <h3 className="text-xl font-bold text-[#1c1b1b] group-hover:text-[#8B1A1A] transition-colors">Caminhos de Ferro Históricos</h3>
              <p className="text-sm text-[#5d5f5d]" style={{ fontFamily: 'Merriweather, serif' }}>
                Explore a rede ferroviária colonial que ligava o interior ao litoral para escoamento de recursos.
              </p>
            </div>
            <span className="material-symbols-outlined text-[#5d5f5d] group-hover:text-[#8B1A1A] transition-colors">arrow_forward</span>
          </button>
        </div>

        {/* Province grid */}
        <section>
          <h3 className="text-2xl font-bold text-[#1c1b1b] mb-6">Conteúdos por Província</h3>
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
            {provinces.map((province) => (
              <button
                key={province}
                onClick={() => navigate('/conteudos/provincia', { state: { province } })}
                onMouseEnter={() => setHoveredProvince(province)}
                onMouseLeave={() => setHoveredProvince(null)}
                className={`bg-white p-4 rounded-xl border transition-all cursor-pointer text-left group ${
                  hoveredProvince === province
                    ? 'border-[#8B1A1A] shadow-md -translate-y-0.5'
                    : 'border-[#e0bfbc] hover:border-[#8B1A1A] hover:shadow-md hover:-translate-y-0.5'
                }`}
              >
                <div className="flex items-center gap-3 mb-2">
                  <div className={`w-8 h-8 rounded-lg flex items-center justify-center transition-colors ${hoveredProvince === province ? 'bg-[#8B1A1A] text-white' : 'bg-[#8B1A1A]/10 text-[#8B1A1A] group-hover:bg-[#8B1A1A] group-hover:text-white'}`}>
                    <span className="material-symbols-outlined text-sm">location_on</span>
                  </div>
                  <span className={`font-semibold text-base transition-colors ${hoveredProvince === province ? 'text-[#8B1A1A]' : 'text-[#1c1b1b] group-hover:text-[#8B1A1A]'}`}>
                    {province}
                  </span>
                </div>
                <p className="text-xs text-[#5d5f5d]">{PROVINCE_ARTICLE_COUNT[province] ?? 5} artigos</p>
              </button>
            ))}
          </div>
        </section>
      </div>
    </AppShell>
  )
}
