import { useState } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { api } from '../services/api/client'
import { reportsService } from '../services/api/reports.service'
import { useAuth } from '../contexts/AuthContext'
import type { Topic } from '../services/types/api.types'
import { getErrorMessage } from '../utils/errors'

function timeAgo(dateStr: string): string {
  const diff = Date.now() - new Date(dateStr).getTime()
  const mins = Math.floor(diff / 60000)
  if (mins < 60) return `Há ${mins} min`
  const hours = Math.floor(mins / 60)
  if (hours < 24) return `Há ${hours}h`
  return `Há ${Math.floor(hours / 24)} dia${Math.floor(hours / 24) > 1 ? 's' : ''}`
}

function AuthorAvatar({ name, size = 'md' }: { name: string; size?: 'sm' | 'md' | 'lg' }) {
  const initials = name.split(' ').map((n) => n[0]).slice(0, 2).join('').toUpperCase()
  const hue = name.split('').reduce((acc, c) => acc + c.charCodeAt(0), 0) % 360
  const sizeClass = size === 'sm' ? 'w-8 h-8 text-[10px]' : size === 'lg' ? 'w-12 h-12 text-sm' : 'w-10 h-10 text-[11px]'
  return (
    <div
      className={`${sizeClass} rounded-full flex items-center justify-center flex-shrink-0 text-white font-bold font-sans`}
      style={{ background: `hsl(${hue}, 35%, 45%)` }}
    >
      {initials}
    </div>
  )
}

export default function ForumDetalhe() {
  const navigate = useNavigate()
  const location = useLocation()
  const { user } = useAuth()
  const topic = (location.state as { topic?: Topic } | null)?.topic ?? null

  const [replyBody, setReplyBody] = useState('')
  const [submitting, setSubmitting] = useState(false)
  const [replyError, setReplyError] = useState('')
  const [replySuccess, setReplySuccess] = useState(false)

  const [reportReason, setReportReason] = useState('')
  const [showReportForm, setShowReportForm] = useState(false)
  const [reportSubmitting, setReportSubmitting] = useState(false)
  const [reportDone, setReportDone] = useState(false)
  const [reportError, setReportError] = useState('')

  async function handleReport(e: React.FormEvent) {
    e.preventDefault()
    if (!topic || !reportReason.trim()) return
    setReportSubmitting(true)
    setReportError('')
    try {
      await reportsService.create({ reason: reportReason.trim(), topicId: topic.id })
      setReportDone(true)
      setShowReportForm(false)
      setReportReason('')
    } catch (err: unknown) {
      setReportError(getErrorMessage(err))
    } finally {
      setReportSubmitting(false)
    }
  }

  async function handleReply(e: React.FormEvent) {
    e.preventDefault()
    if (!replyBody.trim()) { setReplyError('A resposta não pode estar vazia.'); return }
    if (!topic) { setReplyError('Tópico não identificado.'); return }
    setSubmitting(true)
    setReplyError('')
    try {
      await api.post(`/forums/topics/${topic.id}/replies`, { body: replyBody.trim() })
      setReplyBody('')
      setReplySuccess(true)
    } catch (err: unknown) {
      setReplyError(getErrorMessage(err))
    } finally {
      setSubmitting(false)
    }
  }

  if (!topic) {
    return (
      <AppShell title="Fórum">
        <div className="page-content">
          <button onClick={() => navigate('/forum')} className="btn-ghost mb-6">
            <span className="material-symbols-outlined text-[18px]">arrow_back</span>
            Voltar ao Fórum
          </button>
          <div className="empty-state">
            <div className="w-14 h-14 rounded-2xl bg-surface-container flex items-center justify-center">
              <span className="material-symbols-outlined text-primary/40 text-[30px]">forum</span>
            </div>
            <p className="text-headline-md font-bold text-text font-sans">Tópico não encontrado</p>
            <p className="text-body-md text-secondary font-body">Volte ao fórum e selecione um tópico.</p>
            <button onClick={() => navigate('/forum')} className="btn-primary">Ir para o Fórum</button>
          </div>
        </div>
      </AppShell>
    )
  }

  const replies = topic._count?.replies ?? 0

  return (
    <AppShell title="Fórum">
      <div className="page-content animate-fade-in">
        <button
          onClick={() => navigate('/forum')}
          className="flex items-center gap-2 text-secondary hover:text-primary transition-colors duration-150 mb-8 text-sm font-semibold font-sans"
        >
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Fórum
        </button>

        <div className="grid grid-cols-12 gap-8">
          {/* Main column */}
          <div className="col-span-12 lg:col-span-8 flex flex-col gap-5">
            {/* Topic header */}
            <div className="card p-7">
              {/* Meta */}
              <div className="flex items-center gap-2.5 flex-wrap mb-5">
                {topic.category && <span className="badge-primary">{topic.category.name}</span>}
                <span className="text-[12px] text-secondary font-body flex items-center gap-1">
                  <span className="material-symbols-outlined text-[13px]">schedule</span>
                  {timeAgo(topic.createdAt)}
                </span>
                {topic.tags?.slice(0, 2).map((t) => (
                  <span key={t.tag.id} className="badge-outline">{t.tag.name}</span>
                ))}
              </div>

              {/* Title */}
              <h1 className="text-headline-xl font-bold text-text font-sans tracking-tight leading-snug mb-4">
                {topic.title}
              </h1>

              {/* Body */}
              <p className="text-body-lg text-secondary font-reading leading-relaxed mb-6">{topic.body}</p>

              {/* Author */}
              <div className="flex items-center gap-3 pt-5 border-t border-outline-variant/20">
                <AuthorAvatar name={topic.author.name} size="md" />
                <div>
                  <p className="text-sm font-bold text-text font-sans">{topic.author.name}</p>
                  <p className="text-[11px] text-secondary font-body">Investigador</p>
                </div>
                <div className="ml-auto flex items-center gap-3">
                  <div className="flex items-center gap-1.5 text-secondary">
                    <span className="material-symbols-outlined text-[16px]">chat_bubble_outline</span>
                    <span className="text-sm font-semibold font-sans">{replies}</span>
                  </div>
                  {user && !reportDone && (
                    <button
                      onClick={() => setShowReportForm((v) => !v)}
                      className="btn-icon text-secondary hover:text-error"
                      title="Denunciar tópico"
                    >
                      <span className="material-symbols-outlined text-[18px]">flag</span>
                    </button>
                  )}
                </div>
              </div>

              {/* Report form */}
              {reportDone && (
                <div className="alert-success rounded-xl mt-4">
                  <span className="material-symbols-outlined text-success text-[18px]"
                    style={{ fontVariationSettings: "'FILL' 1" }}>check_circle</span>
                  <p className="text-sm text-success font-body">Denúncia enviada. Obrigado pelo aviso.</p>
                </div>
              )}
              {showReportForm && !reportDone && (
                <form onSubmit={handleReport} className="mt-4 pt-4 border-t border-outline-variant/20 space-y-3">
                  <p className="text-sm font-bold text-text font-sans">Denunciar este tópico</p>
                  <textarea
                    rows={2}
                    placeholder="Descreva o motivo da denúncia..."
                    value={reportReason}
                    onChange={(e) => setReportReason(e.target.value)}
                    className="input resize-none text-sm w-full"
                  />
                  {reportError && <p className="text-xs text-error font-body">{reportError}</p>}
                  <div className="flex gap-2 justify-end">
                    <button type="button" onClick={() => setShowReportForm(false)} className="btn-ghost text-sm">
                      Cancelar
                    </button>
                    <button
                      type="submit"
                      disabled={reportSubmitting || !reportReason.trim()}
                      className="btn-secondary text-error border-error/40 hover:bg-error/5 text-sm disabled:opacity-50"
                    >
                      {reportSubmitting ? (
                        <span className="w-4 h-4 border-2 border-error/30 border-t-error rounded-full animate-spin" />
                      ) : (
                        <><span className="material-symbols-outlined text-[16px]">flag</span>Enviar Denúncia</>
                      )}
                    </button>
                  </div>
                </form>
              )}
            </div>

            {/* API info notice */}
            <div className="alert-info rounded-card">
              <span className="material-symbols-outlined text-primary text-[18px] flex-shrink-0 mt-0.5">info</span>
              <p className="text-body-md text-secondary font-body">
                O carregamento de respostas existentes requer um endpoint ainda não disponível. Pode submeter uma nova resposta abaixo.
              </p>
            </div>

            {/* Reply form */}
            <div className="card p-6">
              <h3 className="text-headline-md font-bold text-text font-sans mb-5">
                Adicionar Resposta
              </h3>
              {replySuccess ? (
                <div className="alert-success rounded-xl">
                  <span className="material-symbols-outlined text-success text-[20px]"
                    style={{ fontVariationSettings: "'FILL' 1" }}>check_circle</span>
                  <div>
                    <p className="text-sm font-bold text-success font-sans">Resposta publicada!</p>
                    <p className="text-body-md text-secondary font-body mt-0.5">
                      A sua resposta foi submetida com sucesso.
                    </p>
                  </div>
                </div>
              ) : (
                <form onSubmit={handleReply} className="space-y-4">
                  <div className="flex items-start gap-3">
                    <div className="w-9 h-9 rounded-full bg-surface-container border border-outline-variant/40 flex items-center justify-center flex-shrink-0 mt-1">
                      <span className="text-[10px] font-bold text-primary font-sans">Eu</span>
                    </div>
                    <textarea
                      rows={4}
                      placeholder="Partilhe a sua perspectiva sobre este tema..."
                      value={replyBody}
                      onChange={(e) => setReplyBody(e.target.value)}
                      className="flex-1 bg-background border border-outline-variant/50 rounded-xl p-4 focus:bg-surface focus:border-primary focus:ring-2 focus:ring-primary/8 outline-none transition-all duration-150 resize-none text-sm font-body text-text placeholder:text-outline/50 leading-relaxed"
                    />
                  </div>
                  {replyError && (
                    <div className="alert-error rounded-button">
                      <span className="material-symbols-outlined text-error text-[16px]">error_outline</span>
                      <p className="text-sm text-error font-body">{replyError}</p>
                    </div>
                  )}
                  <div className="flex justify-end">
                    <button type="submit" disabled={submitting} className="btn-primary">
                      {submitting ? (
                        <span className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                      ) : (
                        <>
                          <span className="material-symbols-outlined text-[18px]">send</span>
                          Publicar Resposta
                        </>
                      )}
                    </button>
                  </div>
                </form>
              )}
            </div>
          </div>

          {/* Sidebar */}
          <div className="col-span-12 lg:col-span-4 flex flex-col gap-4">
            {/* Topic stats */}
            <div className="card p-5">
              <h4 className="text-label-lg uppercase tracking-wider text-secondary font-sans mb-4">
                Sobre este Tópico
              </h4>
              <div className="space-y-3">
                <div className="flex items-center justify-between text-sm">
                  <span className="text-secondary font-body flex items-center gap-2">
                    <span className="material-symbols-outlined text-[16px]">chat_bubble_outline</span>
                    Respostas
                  </span>
                  <span className="font-bold text-text font-sans">{replies}</span>
                </div>
                <div className="flex items-center justify-between text-sm">
                  <span className="text-secondary font-body flex items-center gap-2">
                    <span className="material-symbols-outlined text-[16px]">schedule</span>
                    Publicado
                  </span>
                  <span className="font-semibold text-text font-sans">{timeAgo(topic.createdAt)}</span>
                </div>
                {topic.category && (
                  <div className="flex items-center justify-between text-sm">
                    <span className="text-secondary font-body flex items-center gap-2">
                      <span className="material-symbols-outlined text-[16px]">label</span>
                      Categoria
                    </span>
                    <span className="badge-primary">{topic.category.name}</span>
                  </div>
                )}
              </div>
            </div>

            {/* Back CTA */}
            <button
              onClick={() => navigate('/forum')}
              className="card p-4 text-left hover:shadow-card-hover hover:-translate-y-px hover:border-primary/20 transition-all duration-200 flex items-center gap-3"
            >
              <div className="w-9 h-9 rounded-xl bg-primary/8 flex items-center justify-center flex-shrink-0">
                <span className="material-symbols-outlined text-primary text-[18px]">forum</span>
              </div>
              <div>
                <p className="text-sm font-bold text-text font-sans">Ver todos os tópicos</p>
                <p className="text-[12px] text-secondary font-body">Voltar ao Fórum</p>
              </div>
              <span className="material-symbols-outlined text-outline/40 text-[18px] ml-auto">chevron_right</span>
            </button>
          </div>
        </div>
      </div>
    </AppShell>
  )
}
