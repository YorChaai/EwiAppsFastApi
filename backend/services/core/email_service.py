"""Email and one-time-password helpers independent of a web framework."""

import logging
import secrets
import smtplib
import ssl
from dataclasses import dataclass
from email.message import EmailMessage

from config import Config

logger = logging.getLogger(__name__)


@dataclass
class Message:
    subject: str
    recipients: list[str]
    body: str = ""


class _MailSender:
    def send(self, message: Message) -> None:
        if not Config.MAIL_USERNAME:
            raise RuntimeError("Email is not configured")
        email = EmailMessage()
        email["Subject"] = message.subject
        email["From"] = Config.MAIL_DEFAULT_SENDER or Config.MAIL_USERNAME
        email["To"] = ", ".join(message.recipients)
        email.set_content(message.body)
        with smtplib.SMTP(Config.MAIL_SERVER, Config.MAIL_PORT, timeout=20) as smtp:
            if Config.MAIL_USE_TLS:
                smtp.starttls(context=ssl.create_default_context())
            smtp.login(Config.MAIL_USERNAME, Config.MAIL_PASSWORD or "")
            smtp.send_message(email)


mail = _MailSender()


def init_mail(_app=None) -> None:
    """Compatibility hook; mail is configured directly from environment settings."""


def generate_otp(length: int = 6) -> str:
    if length < 1:
        raise ValueError("OTP length must be positive")
    return "".join(str(secrets.randbelow(10)) for _ in range(length))


def send_reset_password_otp(email: str, user, otp: str) -> dict:
    username = Config.MAIL_USERNAME
    if not username:
        logger.warning("Email is not configured; password reset OTP for %s: %s", email, otp)
        return {"message": "Mode testing aktif. Hubungi administrator untuk kode OTP."}

    message = EmailMessage()
    message["Subject"] = "Kode Reset Password ExspanApp"
    message["From"] = Config.MAIL_DEFAULT_SENDER or username
    message["To"] = email
    message.set_content(
        f"Halo {user.full_name},\n\n"
        f"Kode OTP Anda untuk reset password adalah: {otp}\n\n"
        "Kode ini akan kadaluarsa dalam 10 menit. Jika Anda tidak meminta reset "
        "password, abaikan email ini."
    )

    try:
        with smtplib.SMTP(Config.MAIL_SERVER, Config.MAIL_PORT, timeout=20) as smtp:
            if Config.MAIL_USE_TLS:
                smtp.starttls(context=ssl.create_default_context())
            smtp.login(username, Config.MAIL_PASSWORD or "")
            smtp.send_message(message)
        return {"message": "Kode OTP telah dikirim ke email Anda."}
    except (OSError, smtplib.SMTPException):
        logger.exception("Failed to send password reset email")
        return {"message": "Email gagal dikirim. Hubungi administrator."}
