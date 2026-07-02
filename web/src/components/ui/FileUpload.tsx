import { useEffect, useRef, useState } from 'react'
import {
  uploadService,
  validateFile,
  formatFileSize,
  UploadError,
  type FileConstraints,
  type UploadResult,
} from '../../services/api/upload.service'

interface BaseProps {
  id: string
  label: string
  hint?: string
  constraints: FileConstraints
  variant?: 'image' | 'document'
  /** URL pública já existente (ex.: avatar actual), mostrada como estado inicial. */
  existingUrl?: string | null
  disabled?: boolean
}

/**
 * Modo imediato: o componente faz o upload (presign → PUT) e devolve o resultado.
 * Requer que o utilizador esteja autenticado.
 */
interface ImmediateProps extends BaseProps {
  onUploaded: (result: UploadResult | null) => void
  onFileChange?: never
}

/**
 * Modo diferido: o componente apenas valida e pré-visualiza; o upload é feito
 * pelo componente-pai mais tarde (ex.: candidatura, onde a autenticação só
 * acontece no momento da submissão).
 */
interface DeferredProps extends BaseProps {
  onFileChange: (file: File | null) => void
  onUploaded?: never
}

type FileUploadProps = ImmediateProps | DeferredProps

export default function FileUpload(props: FileUploadProps) {
  const { id, label, hint, constraints, variant = 'image', existingUrl, disabled } = props
  const inputRef = useRef<HTMLInputElement>(null)
  const abortRef = useRef<AbortController | null>(null)

  const [file, setFile] = useState<File | null>(null)
  const [previewUrl, setPreviewUrl] = useState<string | null>(null)
  const [uploading, setUploading] = useState(false)
  const [progress, setProgress] = useState(0)
  const [error, setError] = useState('')
  const [done, setDone] = useState(false)
  const [dragOver, setDragOver] = useState(false)

  // Liberta o object URL de pré-visualização ao trocar/desmontar.
  useEffect(() => {
    return () => {
      if (previewUrl) URL.revokeObjectURL(previewUrl)
    }
  }, [previewUrl])

  const acceptAttr = constraints.accept.join(',')
  const showImagePreview = variant === 'image' && (previewUrl || (!file && existingUrl))
  const displayedImage = previewUrl ?? existingUrl ?? null

  function reset() {
    if (previewUrl) URL.revokeObjectURL(previewUrl)
    setFile(null)
    setPreviewUrl(null)
    setProgress(0)
    setDone(false)
    setError('')
    if (inputRef.current) inputRef.current.value = ''
  }

  async function handleFile(selected: File) {
    setError('')
    const validationError = validateFile(selected, constraints)
    if (validationError) {
      setError(validationError)
      return
    }

    // Pré-visualização local imediata.
    if (previewUrl) URL.revokeObjectURL(previewUrl)
    setPreviewUrl(URL.createObjectURL(selected))
    setFile(selected)
    setDone(false)

    if ('onFileChange' in props && props.onFileChange) {
      // Modo diferido — apenas notifica o pai.
      props.onFileChange(selected)
      return
    }

    // Modo imediato — faz o upload agora.
    const controller = new AbortController()
    abortRef.current = controller
    setUploading(true)
    setProgress(0)
    try {
      const result = await uploadService.upload(selected, {
        signal: controller.signal,
        onProgress: setProgress,
      })
      setDone(true)
      ;(props as ImmediateProps).onUploaded(result)
    } catch (err) {
      if (err instanceof DOMException && err.name === 'AbortError') {
        reset()
      } else {
        setError(err instanceof UploadError ? err.message : 'Falha no envio. Tente novamente.')
        if (previewUrl) URL.revokeObjectURL(previewUrl)
        setPreviewUrl(null)
        setFile(null)
      }
    } finally {
      setUploading(false)
      abortRef.current = null
    }
  }

  function onInputChange(e: React.ChangeEvent<HTMLInputElement>) {
    const selected = e.target.files?.[0]
    if (selected) void handleFile(selected)
  }

  function onDrop(e: React.DragEvent) {
    e.preventDefault()
    setDragOver(false)
    if (disabled || uploading) return
    const selected = e.dataTransfer.files?.[0]
    if (selected) void handleFile(selected)
  }

  function cancelUpload() {
    abortRef.current?.abort()
  }

  function removeFile() {
    reset()
    if ('onFileChange' in props && props.onFileChange) props.onFileChange(null)
    else (props as ImmediateProps).onUploaded?.(null)
  }

  const hasSelection = Boolean(file) || Boolean(existingUrl)

  return (
    <div className="flex flex-col gap-1.5">
      <label htmlFor={id} className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">
        {label}
      </label>

      <input
        ref={inputRef}
        id={id}
        type="file"
        accept={acceptAttr}
        onChange={onInputChange}
        disabled={disabled || uploading}
        className="sr-only"
      />

      {!hasSelection ? (
        // ── Zona de seleção (vazia) ──
        <button
          type="button"
          onClick={() => inputRef.current?.click()}
          onDragOver={(e) => { e.preventDefault(); setDragOver(true) }}
          onDragLeave={() => setDragOver(false)}
          onDrop={onDrop}
          disabled={disabled}
          className={[
            'flex flex-col items-center justify-center gap-2 w-full rounded-card border border-dashed px-4 py-6 text-center transition-colors duration-150',
            dragOver
              ? 'border-primary bg-primary/[0.05]'
              : 'border-outline-variant/60 hover:border-primary/40 hover:bg-surface-container-low/50',
            disabled ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer',
          ].join(' ')}
        >
          <span className="material-symbols-outlined text-primary/60 text-[26px]">
            {variant === 'image' ? 'add_photo_alternate' : 'upload_file'}
          </span>
          <span className="text-sm font-semibold text-text font-sans">
            Clique ou arraste um ficheiro
          </span>
          {hint && <span className="text-xs text-outline font-body">{hint}</span>}
        </button>
      ) : (
        // ── Pré-visualização (imagem ou documento) ──
        <div className="rounded-card border border-outline-variant/50 p-3 bg-surface-container-low/40">
          <div className="flex items-center gap-3">
            {showImagePreview && displayedImage ? (
              <img
                src={displayedImage}
                alt={file?.name ?? 'Pré-visualização'}
                className="w-14 h-14 rounded-xl object-cover flex-shrink-0 bg-surface-container"
              />
            ) : (
              <div className="w-14 h-14 rounded-xl bg-primary/8 flex items-center justify-center flex-shrink-0">
                <span className="material-symbols-outlined text-primary text-[24px]">
                  {variant === 'image' ? 'image' : 'description'}
                </span>
              </div>
            )}

            <div className="flex-1 min-w-0">
              <p className="text-sm font-semibold text-text font-sans truncate">
                {file?.name ?? 'Ficheiro atual'}
              </p>
              {file && (
                <p className="text-xs text-secondary font-body">{formatFileSize(file.size)}</p>
              )}

              {uploading ? (
                <div className="mt-2 flex items-center gap-2">
                  <div className="flex-1 h-1.5 bg-surface-container rounded-full overflow-hidden">
                    <div
                      className="h-full bg-primary transition-all duration-150"
                      style={{ width: `${progress}%` }}
                    />
                  </div>
                  <span className="text-[11px] text-secondary font-body tabular-nums w-9 text-right">
                    {progress}%
                  </span>
                </div>
              ) : done ? (
                <p className="mt-1 text-xs text-success font-body flex items-center gap-1">
                  <span className="material-symbols-outlined text-[13px]"
                    style={{ fontVariationSettings: "'FILL' 1" }}>check_circle</span>
                  Enviado
                </p>
              ) : null}
            </div>

            {uploading ? (
              <button
                type="button"
                onClick={cancelUpload}
                className="text-secondary hover:text-error transition-colors flex-shrink-0 p-1"
                aria-label="Cancelar envio"
                title="Cancelar envio"
              >
                <span className="material-symbols-outlined text-[20px]">close</span>
              </button>
            ) : (
              <button
                type="button"
                onClick={removeFile}
                disabled={disabled}
                className="text-secondary hover:text-error transition-colors flex-shrink-0 p-1 disabled:opacity-50"
                aria-label="Remover ficheiro"
                title="Remover ficheiro"
              >
                <span className="material-symbols-outlined text-[20px]">delete</span>
              </button>
            )}
          </div>

          {!uploading && (
            <button
              type="button"
              onClick={() => inputRef.current?.click()}
              disabled={disabled}
              className="mt-2 text-xs font-semibold text-primary hover:text-primary-dark font-sans disabled:opacity-50"
            >
              Trocar ficheiro
            </button>
          )}
        </div>
      )}

      {error && (
        <p className="text-xs text-error font-body flex items-center gap-1 mt-0.5">
          <span className="material-symbols-outlined text-[13px]">error_outline</span>
          {error}
        </p>
      )}
    </div>
  )
}
