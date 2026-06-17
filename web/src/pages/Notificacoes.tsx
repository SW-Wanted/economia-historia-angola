import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const notifications = [
  { icon: 'forum', title: 'Nova resposta no seu tópico', desc: 'Dr. Paulo Vunge respondeu ao seu tópico "Fontes primárias para o século XVIII"', time: 'Há 5 min', unread: true, route: '/forum/detalhe' },
  { icon: 'thumb_up', title: 'O seu comentário foi destacado', desc: 'O seu comentário sobre o Kwanza recebeu 15 votos positivos', time: 'Há 1 hora', unread: true, route: '/forum/detalhe' },
  { icon: 'workspace_premium', title: 'Medalha desbloqueada!', desc: 'Conquistou a medalha "Leitor Voraz" por ler 100 artigos', time: 'Há 2 horas', unread: false, route: '/perfil' },
  { icon: 'quiz', title: 'Novo quiz disponível', desc: 'Quiz da semana: "A Evolução da Moeda Colonial no Século XIX"', time: 'Há 1 dia', unread: false, route: '/quiz' },
  { icon: 'article', title: 'Novo Microtexto publicado', desc: 'Auto-suficiência Alimentar: O paradoxo da abundância angolana', time: 'Há 2 dias', unread: false, route: '/leitura/microtexto' },
]

export default function Notificacoes() {
  const navigate = useNavigate()

  return (
    <AppShell title="Notificações" showSearch={false}>
      <div className="px-10 py-10 max-w-[760px] mx-auto">
        <div className="flex items-center justify-between mb-8">
          <h2 className="text-[32px] font-bold text-[#1c1b1b] font-sans tracking-tight">Notificações</h2>
          <button className="text-sm font-semibold text-[#8B1A1A] hover:text-[#7a1616] transition-colors duration-150 font-sans">
            Marcar todas como lidas
          </button>
        </div>

        <div className="flex flex-col gap-2.5">
          {notifications.map((n) => (
            <div
              key={n.title}
              onClick={() => navigate(n.route)}
              className={`bg-white rounded-xl p-4 border transition-all duration-200 cursor-pointer flex items-start gap-3.5 group hover:shadow-card-hover hover:-translate-y-0.5 ${
                n.unread ? 'border-[#8B1A1A]/20 bg-[#fff8f7]' : 'border-[#ebe5e4]'
              }`}
            >
              <div className={`w-9 h-9 rounded-lg flex items-center justify-center flex-shrink-0 ${n.unread ? 'bg-[#8B1A1A] text-white' : 'bg-[#f0eded] text-[#5d5f5d]'}`}>
                <span className="material-symbols-outlined text-[18px]">{n.icon}</span>
              </div>
              <div className="flex-grow min-w-0">
                <div className="flex items-start justify-between gap-4">
                  <h3 className={`text-sm font-bold font-sans ${n.unread ? 'text-[#8B1A1A]' : 'text-[#1c1b1b]'}`}>{n.title}</h3>
                  <span className="text-[10px] text-[#b8a5a3] whitespace-nowrap font-sans">{n.time}</span>
                </div>
                <p className="text-xs text-[#5d5f5d] mt-1 font-serif leading-relaxed">{n.desc}</p>
              </div>
              {n.unread && <div className="w-1.5 h-1.5 bg-[#8B1A1A] rounded-full mt-2 flex-shrink-0" />}
            </div>
          ))}
        </div>
      </div>
    </AppShell>
  )
}
