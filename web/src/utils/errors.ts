import { ApiError } from '../services/api/client'

export function getErrorMessage(err: unknown): string {
  if (err instanceof ApiError) {
    switch (err.statusCode) {
      case 400:
        return 'Dados inválidos. Verifique os campos e tente novamente.'
      case 401:
        return 'Sessão expirada. Por favor, inicie sessão novamente.'
      case 403:
        return 'Não tem permissão para realizar esta ação.'
      case 404:
        return 'O recurso solicitado não foi encontrado.'
      case 409:
        return 'Este conteúdo já existe. Verifique os dados e tente novamente.'
      case 422:
        return 'Os dados enviados são inválidos. Corrija os campos assinalados.'
      case 429:
        return 'Demasiadas tentativas. Aguarde uns momentos e tente novamente.'
      case 500:
      case 502:
      case 503:
        return 'O servidor encontrou um problema. Tente novamente mais tarde.'
      default:
        return 'Ocorreu um erro inesperado. Tente novamente.'
    }
  }

  if (err instanceof Error) {
    const msg = err.message.toLowerCase()
    if (
      msg.includes('failed to fetch') ||
      msg.includes('networkerror') ||
      msg.includes('econnrefused') ||
      msg.includes('network request failed')
    ) {
      return 'Não foi possível ligar ao servidor. Verifique a sua ligação à internet.'
    }
    if (msg.includes('timeout') || msg.includes('aborted')) {
      return 'O pedido demorou demasiado. Tente novamente.'
    }
  }

  return 'Ocorreu um erro inesperado. Tente novamente.'
}
