import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as nodemailer from 'nodemailer';
import type { Transporter } from 'nodemailer';

/// Envio de email transacional. Usa SMTP quando configurado (SMTP_HOST/USER/…).
/// Quando não há SMTP, [isConfigured] devolve `false` — nesse caso a app expõe
/// o token de recuperação diretamente na resposta (fluxo de desenvolvimento),
/// para que o fluxo continue funcional sem servidor de email.
@Injectable()
export class MailService {
  private readonly logger = new Logger(MailService.name);
  private transporter?: Transporter;

  constructor(private readonly config: ConfigService) {}

  /// Só se considera configurado quando há host E credenciais. Assim, um host
  /// preenchido mas sem SMTP_USER/SMTP_PASSWORD (ex.: `.env` com o bloco Brevo
  /// por completar) não tenta enviar — o fluxo de dev devolve o token na
  /// resposta em vez de falhar silenciosamente numa autenticação vazia.
  get isConfigured(): boolean {
    return Boolean(
      this.config.get<string>('mail.host') &&
        this.config.get<string>('mail.user') &&
        this.config.get<string>('mail.password'),
    );
  }

  private getTransporter(): Transporter | undefined {
    if (!this.isConfigured) return undefined;
    if (!this.transporter) {
      const user = this.config.get<string>('mail.user');
      const pass = this.config.get<string>('mail.password');
      this.transporter = nodemailer.createTransport({
        host: this.config.get<string>('mail.host'),
        port: this.config.get<number>('mail.port', 587),
        secure: this.config.get<boolean>('mail.secure', false),
        auth: user && pass ? { user, pass } : undefined,
      });
    }
    return this.transporter;
  }

  /// Envia o email de recuperação de senha. Best-effort: uma falha de envio é
  /// registada mas não interrompe o fluxo (a resposta continua neutra, e em dev
  /// o token vem na resposta de qualquer forma).
  async sendPasswordReset(to: string, resetUrl: string, token: string): Promise<boolean> {
    const transporter = this.getTransporter();
    if (!transporter) return false;

    const from = this.config.get<string>('mail.from');
    try {
      await transporter.sendMail({
        from,
        to,
        subject: 'Recuperação de senha — Economia com História',
        text:
          `Recebemos um pedido para redefinir a sua senha.\n\n` +
          `Abra o link seguinte para escolher uma nova senha (válido por 1 hora):\n${resetUrl}\n\n` +
          `Ou introduza este código na app: ${token}\n\n` +
          `Se não foi você, ignore este email — a sua senha permanece inalterada.`,
        html:
          `<p>Recebemos um pedido para redefinir a sua senha.</p>` +
          `<p><a href="${resetUrl}">Clique aqui para escolher uma nova senha</a> (válido por 1 hora).</p>` +
          `<p>Ou introduza este código na app: <b>${token}</b></p>` +
          `<p style="color:#666">Se não foi você, ignore este email — a sua senha permanece inalterada.</p>`,
      });
      return true;
    } catch (error) {
      this.logger.warn(`Falha ao enviar email de recuperação para ${to}: ${(error as Error).message}`);
      return false;
    }
  }
}
