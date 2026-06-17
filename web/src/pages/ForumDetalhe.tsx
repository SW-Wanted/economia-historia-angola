import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const replies = [
  { author: 'Dr. Paulo Vunge', role: 'Historiador Sénior', initials: 'PV', time: 'Há 1 hora', text: 'Excelente análise. A transição monetária de 1977 foi de facto um momento crucial. O Kwanza substituiu o Escudo numa altura em que a economia estava a ser reestruturada segundo um modelo socialista, o que criou tensões significativas nas relações comerciais internacionais.', likes: 12 },
  { author: 'Maria Conceição', role: 'Investigadora', initials: 'MC', time: 'Há 3 horas', text: 'Concordo com os pontos levantados. Gostaria de acrescentar que a desvalorização progressiva do Kwanza nos anos seguintes teve impactos profundos na capacidade de importação do país, especialmente de bens essenciais.', likes: 8 },
  { author: 'Carlos Tchípia', role: 'Investigador Sénior', initials: 'CT', time: 'Há 5 horas', text: 'Tenho documentos primários sobre este período que podem enriquecer esta discussão. Vou partilhar na secção de arquivo em breve.', likes: 15 },
]

export default function ForumDetalhe() {
  const navigate = useNavigate()

  return (
    <AppShell title="Fórum" searchPlaceholder="Pesquisar no fórum...">
      <div className="px-10 py-10 max-w-[1160px] mx-auto">
        {/* Back */}
        <button
          onClick={() => navigate('/forum')}
          className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors duration-150 mb-8 text-sm font-semibold font-sans"
        >
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Fórum
        </button>

        {/* Topic header */}
        <div className="bg-white rounded-xl p-7 border border-[#ebe5e4] shadow-card mb-6">
          <div className="flex items-center gap-2.5 mb-4">
            <span className="px-2 py-0.5 bg-[#fff5f4] text-[#8B1A1A] rounded text-[10px] font-bold uppercase tracking-[0.06em] font-sans">Microtextos</span>
            <span className="text-[#b8a5a3] text-xs">Há 2 horas</span>
          </div>
          <h1 className="text-[28px] font-bold text-[#1c1b1b] mb-4 font-sans tracking-tight leading-tight">O impacto da moeda Kwanza na transição econômica de 1977</h1>
          <p className="text-sm text-[#5d5f5d] leading-relaxed mb-6 font-serif">
            Uma análise profunda sobre a substituição do Escudo pelo Kwanza e como isso moldou as primeiras relações comerciais internacionais da Angola independente. A decisão de criar uma moeda nacional própria foi simultaneamente um ato de soberania e um desafio económico de enorme magnitude.
          </p>
          <div className="flex items-center gap-4 flex-wrap">
            <div className="flex items-center gap-2.5">
              <div className="w-9 h-9 rounded-full bg-gradient-to-br from-[#f0eded] to-[#e5e2e1] border border-[#ebe5e4] flex items-center justify-center flex-shrink-0">
                <span className="text-[10px] font-bold text-[#8B1A1A] font-sans">ES</span>
              </div>
              <div>
                <span className="text-sm font-bold text-[#1c1b1b] font-sans">Emanuel dos Santos</span>
                <p className="text-[10px] text-[#8c716e] font-sans">Investigador</p>
              </div>
            </div>
            <div className="flex items-center gap-3 ml-auto text-[#5d5f5d]">
              <button className="flex items-center gap-1.5 hover:text-[#8B1A1A] hover:bg-[#f0eded] px-2.5 py-1.5 rounded-lg transition-all duration-150 text-sm">
                <span className="material-symbols-outlined text-[16px]">thumb_up</span>
                <span className="text-xs font-sans font-semibold">24</span>
              </button>
              <button className="flex items-center gap-1.5 hover:text-[#8B1A1A] hover:bg-[#f0eded] px-2.5 py-1.5 rounded-lg transition-all duration-150 text-sm">
                <span className="material-symbols-outlined text-[16px]">share</span>
                <span className="text-xs font-sans font-semibold">Partilhar</span>
              </button>
              <button className="flex items-center gap-1.5 hover:text-[#8B1A1A] hover:bg-[#f0eded] px-2.5 py-1.5 rounded-lg transition-all duration-150 text-sm">
                <span className="material-symbols-outlined text-[16px]">bookmark</span>
                <span className="text-xs font-sans font-semibold">Guardar</span>
              </button>
            </div>
          </div>
        </div>

        {/* Replies */}
        <div className="mb-6">
          <h2 className="text-lg font-bold text-[#1c1b1b] mb-4 font-sans">24 Respostas</h2>
          <div className="flex flex-col gap-3">
            {replies.map((reply) => (
              <div key={reply.author} className="bg-white rounded-xl p-5 border border-[#ebe5e4] shadow-card">
                <div className="flex items-start gap-3.5">
                  <div className="w-9 h-9 rounded-full bg-gradient-to-br from-[#f0eded] to-[#e5e2e1] border border-[#ebe5e4] flex items-center justify-center flex-shrink-0">
                    <span className="text-[10px] font-bold text-[#8B1A1A] font-sans">{reply.initials}</span>
                  </div>
                  <div className="flex-grow min-w-0">
                    <div className="flex items-center gap-2.5 mb-2 flex-wrap">
                      <span className="text-sm font-bold text-[#1c1b1b] font-sans">{reply.author}</span>
                      <span className="text-xs text-[#8c716e] font-sans">{reply.role}</span>
                      <span className="text-[10px] text-[#b8a5a3] font-sans ml-auto">{reply.time}</span>
                    </div>
                    <p className="text-sm text-[#5d5f5d] leading-relaxed font-serif">{reply.text}</p>
                    <div className="flex items-center gap-4 mt-3">
                      <button className="flex items-center gap-1.5 text-[#5d5f5d] hover:text-[#8B1A1A] hover:bg-[#f0eded] px-2 py-1 rounded-lg transition-all duration-150 text-xs font-sans font-semibold">
                        <span className="material-symbols-outlined text-[15px]">thumb_up</span>
                        {reply.likes}
                      </button>
                      <button className="text-xs text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors duration-150 font-sans font-semibold">Responder</button>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Reply box */}
        <div className="bg-white rounded-xl p-6 border border-[#ebe5e4] shadow-card">
          <h3 className="text-base font-bold text-[#1c1b1b] mb-4 font-sans">Adicionar Resposta</h3>
          <textarea
            rows={4}
            placeholder="Partilhe a sua perspectiva sobre este tema..."
            className="w-full bg-[#f8f5f4] border border-[#ebe5e4] rounded-lg p-3.5 focus:bg-white focus:border-[#8B1A1A]/40 focus:ring-2 focus:ring-[#8B1A1A]/10 outline-none transition-all duration-150 resize-none text-sm font-serif placeholder:text-[#c4b5b3]"
          />
          <div className="flex justify-end mt-3">
            <button
              onClick={() => navigate('/forum')}
              className="bg-[#8B1A1A] text-white px-6 py-2.5 rounded-full text-sm font-semibold font-sans hover:bg-[#7a1616] hover:shadow-md active:scale-[0.98] transition-all duration-150"
            >
              Publicar Resposta
            </button>
          </div>
        </div>
      </div>
    </AppShell>
  )
}
