import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const steps = [
  { icon: 'person_add', title: 'Criar Conta', desc: 'Registe-se gratuitamente para aceder a todos os conteúdos.', route: '/cadastro', cta: 'Criar Conta' },
  { icon: 'explore', title: 'Explorar Conteúdos', desc: 'Navegue pelos Microtextos, Textos Jindungo e Arquivo Digital.', route: '/explorar', cta: 'Explorar' },
  { icon: 'map', title: 'Usar o Mapa', desc: 'Visualize a evolução económica de Angola por província e período.', route: '/mapa', cta: 'Abrir Mapa' },
  { icon: 'quiz', title: 'Fazer Quizzes', desc: 'Teste os seus conhecimentos com quizzes temáticos.', route: '/quiz', cta: 'Ver Quizzes' },
  { icon: 'forum', title: 'Participar no Fórum', desc: 'Debata temas com outros investigadores e especialistas.', route: '/forum', cta: 'Ir ao Fórum' },
]

export default function GuiaRapido() {
  const navigate = useNavigate()

  return (
    <AppShell title="Guia Rápido" showSearch={false}>
      <div className="px-10 py-8 max-w-[900px] mx-auto">
        <div className="mb-10">
          <h2 className="text-[40px] font-extrabold text-text mb-2 font-sans tracking-tight">Guia Rápido</h2>
          <p className="text-lg text-secondary font-reading">
            Tudo o que precisa de saber para começar a explorar a história económica de Angola.
          </p>
        </div>

        {/* Steps */}
        <div className="space-y-4 mb-12">
          {steps.map((step, i) => (
            <div key={step.title} className="bg-surface rounded-card p-6 border border-outline-variant/45 shadow-card flex items-center gap-6">
              <div className="w-12 h-12 bg-primary rounded-full flex items-center justify-center text-white font-bold text-lg font-sans flex-shrink-0">
                {i + 1}
              </div>
              <div className="flex-grow">
                <div className="flex items-center gap-3 mb-1">
                  <span className="material-symbols-outlined text-primary text-xl">{step.icon}</span>
                  <h3 className="text-xl font-bold text-text font-sans">{step.title}</h3>
                </div>
                <p className="text-base text-secondary font-reading">{step.desc}</p>
              </div>
              <button
                onClick={() => navigate(step.route)}
                className="bg-primary text-white px-[18px] py-[14px] rounded-button text-sm font-semibold font-sans hover:bg-primary-dark hover:shadow-md transition-all whitespace-nowrap flex-shrink-0 uppercase tracking-wide active:scale-[0.98]"
              >
                {step.cta}
              </button>
            </div>
          ))}
        </div>

        {/* Tips */}
        <div className="bg-surface-warm border border-primary/20 rounded-card p-8">
          <h3 className="text-xl font-bold text-text mb-4 flex items-center gap-2 font-sans">
            <span className="material-symbols-outlined text-primary">lightbulb</span>
            Dicas Úteis
          </h3>
          <ul className="space-y-3">
            {[
              'Use o Mapa Económico para contextualizar geograficamente os artigos que lê.',
              'Os Textos Jindungo são análises mais profundas — reserve mais tempo para os ler.',
              'Guarde artigos nos Favoritos para retomar a leitura mais tarde.',
              'Participe no Fórum para enriquecer a sua compreensão com outras perspectivas.',
            ].map((tip) => (
              <li key={tip} className="flex items-start gap-3 text-sm text-secondary font-reading">
                <span className="material-symbols-outlined text-primary text-[16px] mt-0.5 flex-shrink-0">check_circle</span>
                {tip}
              </li>
            ))}
          </ul>
        </div>
      </div>
    </AppShell>
  )
}
