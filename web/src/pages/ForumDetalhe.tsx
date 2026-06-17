import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const replies = [
  { author: 'Dr. Paulo Vunge', role: 'Historiador Sénior', time: 'Há 1 hora', text: 'Excelente análise. A transição monetária de 1977 foi de facto um momento crucial. O Kwanza substituiu o Escudo numa altura em que a economia estava a ser reestruturada segundo um modelo socialista, o que criou tensões significativas nas relações comerciais internacionais.', likes: 12 },
  { author: 'Maria Conceição', role: 'Investigadora', time: 'Há 3 horas', text: 'Concordo com os pontos levantados. Gostaria de acrescentar que a desvalorização progressiva do Kwanza nos anos seguintes teve impactos profundos na capacidade de importação do país, especialmente de bens essenciais.', likes: 8 },
  { author: 'Carlos Tchípia', role: 'Investigador Sénior', time: 'Há 5 horas', text: 'Tenho documentos primários sobre este período que podem enriquecer esta discussão. Vou partilhar na secção de arquivo em breve.', likes: 15 },
]

export default function ForumDetalhe() {
  const navigate = useNavigate()

  return (
    <AppShell title="Fórum" searchPlaceholder="Pesquisar no fórum...">
      <div className="px-10 py-16 max-w-[1160px] mx-auto">
        {/* Back */}
        <button
          onClick={() => navigate('/forum')}
          className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors mb-8 text-sm font-semibold"
        >
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Fórum
        </button>

        {/* Topic header */}
        <div className="bg-white rounded-xl p-8 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] mb-8">
          <div className="flex items-center gap-3 mb-4">
            <span className="px-2 py-0.5 bg-[#8B1A1A]/10 text-[#8B1A1A] rounded text-[10px] font-bold uppercase tracking-wider">Microtextos</span>
            <span className="text-[#5d5f5d] text-xs">Há 2 horas</span>
          </div>
          <h1 className="text-[32px] font-bold text-[#1c1b1b] mb-4">O impacto da moeda Kwanza na transição econômica de 1977</h1>
          <p className="text-lg text-[#5d5f5d] leading-relaxed mb-6" style={{ fontFamily: 'Merriweather, serif' }}>
            Uma análise profunda sobre a substituição do Escudo pelo Kwanza e como isso moldou as primeiras relações comerciais internacionais da Angola independente. A decisão de criar uma moeda nacional própria foi simultaneamente um ato de soberania e um desafio económico de enorme magnitude.
          </p>
          <div className="flex items-center gap-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-full bg-[#eae7e7] flex items-center justify-center">
                <span className="material-symbols-outlined text-[#5d5f5d]">person</span>
              </div>
              <div>
                <span className="text-sm font-bold text-[#1c1b1b]">Emanuel dos Santos</span>
                <p className="text-xs text-[#5d5f5d]">Investigador</p>
              </div>
            </div>
            <div className="flex items-center gap-4 ml-auto text-[#5d5f5d]">
              <button className="flex items-center gap-1 hover:text-[#8B1A1A] transition-colors">
                <span className="material-symbols-outlined text-sm">thumb_up</span>
                <span className="text-xs">24</span>
              </button>
              <button className="flex items-center gap-1 hover:text-[#8B1A1A] transition-colors">
                <span className="material-symbols-outlined text-sm">share</span>
                <span className="text-xs">Partilhar</span>
              </button>
              <button className="flex items-center gap-1 hover:text-[#8B1A1A] transition-colors">
                <span className="material-symbols-outlined text-sm">bookmark</span>
                <span className="text-xs">Guardar</span>
              </button>
            </div>
          </div>
        </div>

        {/* Replies */}
        <div className="mb-8">
          <h2 className="text-2xl font-bold text-[#1c1b1b] mb-6">24 Respostas</h2>
          <div className="flex flex-col gap-4">
            {replies.map((reply) => (
              <div key={reply.author} className="bg-white rounded-xl p-6 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)]">
                <div className="flex items-start gap-4">
                  <div className="w-10 h-10 rounded-full bg-[#eae7e7] flex items-center justify-center flex-shrink-0">
                    <span className="material-symbols-outlined text-[#5d5f5d]">person</span>
                  </div>
                  <div className="flex-grow">
                    <div className="flex items-center gap-3 mb-2">
                      <span className="text-sm font-bold text-[#1c1b1b]">{reply.author}</span>
                      <span className="text-xs text-[#5d5f5d]">{reply.role}</span>
                      <span className="text-xs text-[#5d5f5d] ml-auto">{reply.time}</span>
                    </div>
                    <p className="text-base text-[#5d5f5d] leading-relaxed" style={{ fontFamily: 'Merriweather, serif' }}>{reply.text}</p>
                    <div className="flex items-center gap-4 mt-3">
                      <button className="flex items-center gap-1 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors text-xs">
                        <span className="material-symbols-outlined text-sm">thumb_up</span>
                        {reply.likes}
                      </button>
                      <button className="text-xs text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors">Responder</button>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Reply box */}
        <div className="bg-white rounded-xl p-6 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)]">
          <h3 className="text-xl font-bold text-[#1c1b1b] mb-4">Adicionar Resposta</h3>
          <textarea
            rows={4}
            placeholder="Partilhe a sua perspectiva sobre este tema..."
            className="w-full bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg p-4 focus:ring-1 focus:ring-[#8B1A1A] outline-none transition-all resize-none text-base"
            style={{ fontFamily: 'Merriweather, serif' }}
          />
          <div className="flex justify-end mt-4">
            <button
              onClick={() => navigate('/forum')}
              className="bg-[#8B1A1A] text-white px-8 py-3 rounded-full text-sm font-semibold hover:opacity-90 transition-all"
            >
              Publicar Resposta
            </button>
          </div>
        </div>
      </div>
    </AppShell>
  )
}
