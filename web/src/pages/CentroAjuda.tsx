import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const faqs = [
  { q: 'O conteúdo é totalmente gratuito?', a: 'Sim, atualmente todos os nossos Microtextos, Textos Jindungo e Mapas são de acesso livre mediante a criação de uma conta gratuita.' },
  { q: 'Quem escreve os textos da plataforma?', a: 'Nossa equipa editorial é liderada pelo Prof. António Gaspar e conta com contributos de especialistas nas áreas de História e Economia de Angola.' },
  { q: 'Posso contribuir com o meu próprio arquivo?', a: 'Com certeza! Temos uma secção de submissões onde pode enviar documentos históricos ou fotos que serão avaliados pela nossa curadoria.' },
  { q: 'Como funciona o Mapa Económico Interativo?', a: 'O mapa permite selecionar diferentes décadas para ver como a malha industrial e as rotas comerciais se alteraram ao longo do tempo.' },
  { q: 'Haverá uma aplicação móvel em breve?', a: 'Sim, a nossa aplicação para Android e iOS está em fase beta e será lançada oficialmente no segundo semestre de 2026.' },
]

export default function CentroAjuda() {
  const navigate = useNavigate()
  const [open, setOpen] = useState<number | null>(0)

  return (
    <AppShell title="Centro de Ajuda" searchPlaceholder="Pesquisar ajuda...">
      <div className="px-10 py-16 max-w-[800px] mx-auto">
        <h1 className="text-[40px] font-extrabold text-[#1c1b1b] mb-2">Como podemos ajudar?</h1>
        <p className="text-lg text-[#5d5f5d] mb-12" style={{ fontFamily: 'Merriweather, serif' }}>
          Encontre respostas às perguntas mais frequentes ou contacte-nos diretamente.
        </p>

        {/* Quick links */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-12">
          {[
            { icon: 'account_circle', label: 'Conta', route: '/perfil' },
            { icon: 'library_books', label: 'Conteúdos', route: '/explorar' },
            { icon: 'quiz', label: 'Quizzes', route: '/quiz' },
            { icon: 'forum', label: 'Fórum', route: '/forum' },
          ].map((item) => (
            <button
              key={item.label}
              onClick={() => navigate(item.route)}
              className="bg-white rounded-xl p-6 border border-[#e0bfbc] hover:border-[#8B1A1A] hover:shadow-md transition-all flex flex-col items-center gap-2"
            >
              <span className="material-symbols-outlined text-[#8B1A1A] text-3xl">{item.icon}</span>
              <span className="text-sm font-semibold text-[#1c1b1b]">{item.label}</span>
            </button>
          ))}
        </div>

        {/* FAQ */}
        <h2 className="text-2xl font-bold text-[#1c1b1b] mb-6">Perguntas Frequentes</h2>
        <div className="space-y-3">
          {faqs.map((faq, i) => (
            <div key={i} className="bg-white rounded-xl border border-[#e0bfbc] overflow-hidden shadow-[0px_4px_20px_rgba(0,0,0,0.04)]">
              <button
                onClick={() => setOpen(open === i ? null : i)}
                className="w-full flex justify-between items-center p-6 text-left font-bold text-[#1c1b1b] hover:bg-[#f6f3f2] transition-colors"
              >
                {faq.q}
                <span className={`material-symbols-outlined transition-transform ${open === i ? 'rotate-180' : ''}`}>expand_more</span>
              </button>
              {open === i && (
                <div className="px-6 pb-6 text-base text-[#5d5f5d]" style={{ fontFamily: 'Merriweather, serif' }}>{faq.a}</div>
              )}
            </div>
          ))}
        </div>

        {/* Contact */}
        <div className="mt-12 bg-[#8B1A1A] rounded-xl p-8 text-white text-center">
          <h3 className="text-2xl font-bold mb-2">Ainda tem dúvidas?</h3>
          <p className="text-white/80 mb-6" style={{ fontFamily: 'Merriweather, serif' }}>A nossa equipa está disponível para ajudar.</p>
          <button onClick={() => navigate('/forum/novo-topico')} className="bg-white text-[#8B1A1A] px-8 py-3 rounded-full text-sm font-bold hover:shadow-lg transition-all">
            Contactar Suporte
          </button>
        </div>
      </div>
    </AppShell>
  )
}
