import { api } from './client'

/**
 * Fluxo de upload de médias (presigned URL → Supabase Storage).
 *
 * 1. POST /uploads/presign (autenticado) → { uploadUrl, assetId, key, expiresIn }
 * 2. PUT dos bytes do ficheiro directamente para `uploadUrl` (Supabase Storage).
 * 3. Construir a URL pública a partir da `key` + VITE_PUBLIC_ASSET_URL.
 *
 * Toda a lógica de armazenamento pertence ao backend/Supabase. A Web apenas
 * seleciona, valida, envia e acompanha o progresso.
 */

interface PresignResponse {
  uploadUrl: string
  assetId: string
  key: string
  expiresIn: number
}

export interface UploadResult {
  assetId: string
  key: string
  /** URL pública resolvível para pré-visualização e persistência no DTO. */
  publicUrl: string
}

export interface UploadOptions {
  /** Callback de progresso (0–100). Só disparado quando o total é conhecido. */
  onProgress?: (percent: number) => void
  /** Permite cancelar o upload em curso. */
  signal?: AbortSignal
}

/** Erro de upload com mensagem já amigável para o utilizador final. */
export class UploadError extends Error {
  constructor(message: string) {
    super(message)
    this.name = 'UploadError'
  }
}

// ── Regras de validação (alinhadas com o limite de 500 MB do backend) ──
export const MAX_IMAGE_BYTES = 5 * 1024 * 1024 // 5 MB
export const MAX_DOCUMENT_BYTES = 15 * 1024 * 1024 // 15 MB
export const MAX_VIDEO_BYTES = 200 * 1024 * 1024 // 200 MB
export const MAX_AUDIO_BYTES = 50 * 1024 * 1024 // 50 MB

export const IMAGE_MIME_TYPES = ['image/jpeg', 'image/png', 'image/webp', 'image/gif']
export const DOCUMENT_MIME_TYPES = [
  'application/pdf',
  'application/msword',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
]
export const VIDEO_MIME_TYPES = ['video/mp4', 'video/webm', 'video/ogg', 'video/quicktime']
export const AUDIO_MIME_TYPES = ['audio/mpeg', 'audio/mp4', 'audio/ogg', 'audio/wav', 'audio/webm']

export interface FileConstraints {
  accept: string[]
  maxBytes: number
}

export const IMAGE_CONSTRAINTS: FileConstraints = {
  accept: IMAGE_MIME_TYPES,
  maxBytes: MAX_IMAGE_BYTES,
}

export const DOCUMENT_CONSTRAINTS: FileConstraints = {
  accept: DOCUMENT_MIME_TYPES,
  maxBytes: MAX_DOCUMENT_BYTES,
}

export const VIDEO_CONSTRAINTS: FileConstraints = {
  accept: VIDEO_MIME_TYPES,
  maxBytes: MAX_VIDEO_BYTES,
}

export const AUDIO_CONSTRAINTS: FileConstraints = {
  accept: AUDIO_MIME_TYPES,
  maxBytes: MAX_AUDIO_BYTES,
}

export function formatFileSize(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(0)} KB`
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`
}

/**
 * Valida um ficheiro contra as restrições dadas.
 * @returns mensagem de erro amigável, ou `null` se o ficheiro for válido.
 */
export function validateFile(file: File, constraints: FileConstraints): string | null {
  if (file.size === 0) {
    return 'O ficheiro está vazio ou corrompido. Selecione outro ficheiro.'
  }
  if (constraints.accept.length > 0 && !constraints.accept.includes(file.type)) {
    return 'Formato não suportado. Verifique os formatos aceites e tente novamente.'
  }
  if (file.size > constraints.maxBytes) {
    return `O ficheiro é demasiado grande (máximo ${formatFileSize(constraints.maxBytes)}).`
  }
  return null
}

function resolvePublicUrl(key: string): string {
  const base = (import.meta.env.VITE_PUBLIC_ASSET_URL ?? '').replace(/\/$/, '')
  const cleanKey = key.replace(/^\//, '')
  return base ? `${base}/${cleanKey}` : cleanKey
}

/** Faz o PUT dos bytes para o Supabase via XHR (progresso + cancelamento). */
function putToStorage(uploadUrl: string, file: File, options: UploadOptions): Promise<void> {
  return new Promise<void>((resolve, reject) => {
    const xhr = new XMLHttpRequest()
    xhr.open('PUT', uploadUrl, true)
    xhr.setRequestHeader('Content-Type', file.type)
    // A URL assinada expira em 900s; um envio que ultrapasse isto nunca terá
    // sucesso. 2 min cobre folgadamente os limites (imagem 5 MB / doc 15 MB).
    xhr.timeout = 120_000

    xhr.upload.onprogress = (event) => {
      if (event.lengthComputable && options.onProgress) {
        options.onProgress(Math.round((event.loaded / event.total) * 100))
      }
    }

    xhr.onload = () => {
      if (xhr.status >= 200 && xhr.status < 300) {
        resolve()
      } else {
        reject(new UploadError('Falha ao enviar o ficheiro para o armazenamento. Tente novamente.'))
      }
    }

    xhr.onerror = () =>
      reject(new UploadError('Não foi possível ligar ao armazenamento. Verifique a sua ligação.'))
    xhr.ontimeout = () =>
      reject(new UploadError('O envio demorou demasiado. Tente novamente.'))
    xhr.onabort = () => reject(new DOMException('Upload cancelado', 'AbortError'))

    if (options.signal) {
      if (options.signal.aborted) {
        xhr.abort()
        return
      }
      options.signal.addEventListener('abort', () => xhr.abort(), { once: true })
    }

    xhr.send(file)
  })
}

export const uploadService = {
  /** Pede uma URL assinada ao backend. Requer autenticação. */
  presign: (file: File) =>
    api.post<PresignResponse>('/uploads/presign', {
      filename: file.name,
      mimeType: file.type,
      sizeBytes: file.size,
    }),

  /**
   * Executa o fluxo completo: presign → PUT → URL pública.
   * Lança `UploadError` (mensagem amigável) ou `AbortError` (cancelamento).
   */
  async upload(file: File, options: UploadOptions = {}): Promise<UploadResult> {
    let presigned: PresignResponse
    try {
      presigned = await this.presign(file)
    } catch {
      throw new UploadError('Não foi possível preparar o envio do ficheiro. Tente novamente.')
    }

    await putToStorage(presigned.uploadUrl, file, options)

    return {
      assetId: presigned.assetId,
      key: presigned.key,
      publicUrl: resolvePublicUrl(presigned.key),
    }
  },
}
