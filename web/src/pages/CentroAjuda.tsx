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
      <div className="page-content-narrow animate-fade-in">
        <div className="mb-10">
          <h1 className="text-display-web font-extrabold text-text font-sans tracking-tight mb-2">Como podemos ajudar?</h1>
          <p className="text-body-lg text-secondary font-reading leading-relaxed">
            Encontre respostas às perguntas mais frequentes ou contacte-nos diretamente.
          </p>
        </div>

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
              className="card-interactive p-6 flex flex-col items-center gap-2"
            >
              <span className="material-symbols-outlined text-primary text-3xl">{item.icon}</span>
              <span className="text-sm font-semibold text-text font-sans">{item.label}</span>
            </button>
          ))}
        </div>

        {/* FAQ */}
        <h2 className="text-headline-lg font-bold text-text font-sans mb-6">Perguntas Frequentes</h2>
        <div className="space-y-3">
          {faqs.map((faq, i) => (
            <div key={i} className="card overflow-hidden">
              <button
                onClick={() => setOpen(open === i ? null : i)}
                className="w-full flex justify-between items-center p-6 text-left font-bold text-text hover:bg-surface-container-low transition-colors font-sans"
              >
                {faq.q}
                <span className={`material-symbols-outlined transition-transform text-outline ${open === i ? 'rotate-180' : ''}`}>expand_more</span>
              </button>
              {open === i && (
                <div className="px-6 pb-6 text-base text-secondary font-reading border-t border-outline-variant/30 pt-4">{faq.a}</div>
              )}
            </div>
          ))}
        </div>

        {/* Contact */}
        <div className="mt-12 bg-primary rounded-card p-8 text-white text-center">
          <h3 className="text-2xl font-bold mb-2 font-sans">Ainda tem dúvidas?</h3>
          <p className="text-white/80 mb-6 font-body">A nossa equipa está disponível para ajudar.</p>
          <button
            onClick={() => navigate('/forum/novo-topico')}
            className="btn-white"
          >
            Contactar Suporte
          </button>
        </div>
      </div>
    </AppShell>
  )
}
