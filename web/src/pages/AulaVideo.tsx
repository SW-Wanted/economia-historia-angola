import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

export default function AulaVideo() {
  const navigate = useNavigate()

  return (
    <AppShell title="Aula em Vídeo" showSearch={false}>
      <div className="px-10 py-8 max-w-[900px] mx-auto">
        <button onClick={() => navigate('/explorar')}
          className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors mb-8 text-sm font-semibold">
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Arquivo
        </button>

        <div className="flex items-center gap-3 mb-4">
          <span className="bg-[#8B1A1A]/10 text-[#8B1A1A] px-3 py-1 rounded-full text-xs font-semibold flex items-center gap-1">
            <span className="material-symbols-outlined text-[14px]">play_circle</span>
            Aula em Vídeo
          </span>
          <span className="text-xs text-[#5d5f5d]">45 min</span>
        </div>

        <h1 className="text-[36px] font-extrabold text-[#1c1b1b] mb-4 leading-tight">
          Economia de Luanda Colonial: Das Feitorias ao Século XX
        </h1>

        {/* Video player placeholder */}
        <div className="bg-[#1c1b1b] rounded-xl aspect-video flex items-center justify-center mb-8 relative overflow-hidden">
          <div className="absolute inset-0 bg-gradient-to-br from-[#8B1A1A]/20 to-transparent" />
          <button className="w-20 h-20 bg-white/20 backdrop-blur-sm rounded-full flex items-center justify-center hover:bg-white/30 transition-colors z-10">
            <span className="material-symbols-outlined text-white" style={{ fontSize: '48px', fontVariationSettings: "'FILL' 1" }}>play_arrow</span>
          </button>
          <div className="absolute bottom-4 left-4 right-4 flex items-center gap-3">
            <div className="flex-grow bg-white/20 h-1 rounded-full">
              <div className="bg-[#8B1A1A] h-1 rounded-full w-0" />
            </div>
            <span className="text-white text-xs">0:00 / 45:00</span>
          </div>
        </div>

        <div className="bg-white rounded-xl p-6 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] mb-6">
          <h2 className="text-xl font-bold text-[#1c1b1b] mb-3">Sobre esta Aula</h2>
          <p className="text-base text-[#5d5f5d] leading-relaxed" style={{ fontFamily: 'Merriweather, serif' }}>
            Nesta aula, exploramos a evolução económica de Luanda desde as primeiras feitorias portuguesas até ao início do século XX. Analisamos como o comércio de escravos, marfim e borracha moldou a estrutura urbana e económica da cidade.
          </p>
        </div>

        <div className="flex gap-4">
          <button onClick={() => navigate('/forum/detalhe')}
            className="flex items-center gap-2 border border-[#e0bfbc] text-[#1c1b1b] px-6 py-3 rounded-full text-sm font-semibold hover:bg-[#f6f3f2] transition-all">
            <span className="material-symbols-outlined text-[18px]">forum</span>
            Discutir
          </button>
          <button onClick={() => navigate('/explorar')}
            className="flex items-center gap-2 bg-[#8B1A1A] text-white px-6 py-3 rounded-full text-sm font-semibold hover:opacity-90 transition-all">
            <span className="material-symbols-outlined text-[18px]">explore</span>
            Mais Conteúdos
          </button>
        </div>
      </div>
    </AppShell>
  )
}
