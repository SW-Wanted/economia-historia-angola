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
      <div className="page-content animate-fade-in">
        <div className="mb-8">
          <h2 className="text-display-web font-extrabold text-text font-sans tracking-tight mb-3">Mapa Económico de Angola</h2>
          <p className="text-lg text-secondary max-w-2xl font-reading">
            Visualize a evolução das províncias, desde as primeiras feitorias até aos atuais pólos de desenvolvimento industrial.
          </p>
        </div>

        {/* Era selector */}
        <div className="flex flex-wrap gap-3 mb-8">
          {eras.map((era) => (
            <button
              key={era}
              onClick={() => setActiveEra(era)}
              className={`px-6 py-2 rounded-full text-sm font-semibold font-sans transition-all ${
                activeEra === era
                  ? 'bg-primary text-white'
                  : 'bg-surface border border-outline-variant/45 text-text hover:border-primary/40 hover:text-primary'
              }`}
            >
              {era}
            </button>
          ))}
        </div>

        {/* Map placeholder */}
        <div className="relative bg-surface rounded-card overflow-hidden shadow-card border border-outline-variant/45 mb-8">
          <div className="aspect-video bg-surface-container-low flex items-center justify-center relative">
            <svg viewBox="0 0 400 500" className="w-full h-full max-h-[500px] opacity-20" fill="none" stroke="#8B1A1A" strokeWidth="2">
              <path d="M180,40 L220,60 L260,50 L300,80 L320,140 L280,220 L260,300 L220,360 L160,340 L100,300 L80,240 L60,180 L80,100 L140,60 Z" />
            </svg>
            <div className="absolute inset-0 flex flex-col items-center justify-center">
              <span className="material-symbols-outlined text-primary/30" style={{ fontSize: '80px' }}>map</span>
              <p className="text-2xl font-bold text-secondary mt-4 font-sans">{activeEra}</p>
              <p className="text-base text-outline mt-2 font-body">Clique numa província abaixo para explorar</p>
            </div>
          </div>
        </div>

        {/* Featured layer */}
        <div className="mb-8">
          <button
            onClick={() => navigate('/mapa/caminhos-ferro')}
            className="w-full bg-surface rounded-card p-6 border border-outline-variant/45 hover:border-primary/40 hover:shadow-md transition-all text-left flex items-center gap-6 group"
          >
            <div className="w-14 h-14 bg-surface-container rounded-xl flex items-center justify-center flex-shrink-0 group-hover:bg-primary transition-colors">
              <span className="material-symbols-outlined text-primary text-3xl group-hover:text-white transition-colors">train</span>
            </div>
            <div className="flex-grow">
              <h3 className="text-xl font-bold text-text group-hover:text-primary transition-colors font-sans">Caminhos de Ferro Históricos</h3>
              <p className="text-sm text-secondary font-body">
                Explore a rede ferroviária colonial que ligava o interior ao litoral para escoamento de recursos.
              </p>
            </div>
            <span className="material-symbols-outlined text-secondary group-hover:text-primary transition-colors">arrow_forward</span>
          </button>
        </div>

        {/* Province grid */}
        <section>
          <h3 className="text-headline-lg font-bold text-text font-sans mb-6">Conteúdos por Província</h3>
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
            {provinces.map((province) => (
              <button
                key={province}
                onClick={() => navigate('/conteudos/provincia', { state: { province } })}
                onMouseEnter={() => setHoveredProvince(province)}
                onMouseLeave={() => setHoveredProvince(null)}
                className={`bg-surface p-4 rounded-card border transition-all cursor-pointer text-left group ${
                  hoveredProvince === province
                    ? 'border-primary shadow-md -translate-y-0.5'
                    : 'border-outline-variant/45 hover:border-primary/40 hover:shadow-md hover:-translate-y-0.5'
                }`}
              >
                <div className="flex items-center gap-3 mb-2">
                  <div className={`w-8 h-8 rounded-lg flex items-center justify-center transition-colors ${hoveredProvince === province ? 'bg-primary text-white' : 'bg-surface-container text-primary group-hover:bg-primary group-hover:text-white'}`}>
                    <span className="material-symbols-outlined text-sm">location_on</span>
                  </div>
                  <span className={`font-semibold text-base font-sans transition-colors ${hoveredProvince === province ? 'text-primary' : 'text-text group-hover:text-primary'}`}>
                    {province}
                  </span>
                </div>
                <p className="text-xs text-secondary font-body">{PROVINCE_ARTICLE_COUNT[province] ?? 5} artigos</p>
              </button>
            ))}
          </div>
        </section>
      </div>
    </AppShell>
  )
}
