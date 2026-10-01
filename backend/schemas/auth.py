from typing import Optional

from pydantic import BaseModel


class LoginSchema(BaseModel):
    username: str
    password: str


class RegisterSchema(BaseModel):
    username: str
    password: str
    full_name: str
    email: Optional[str] = None
    google_id: Optional[str] = None
    phone_number: Optional[str] = "-"
    workplace: Optional[str] = "-"
    role: Optional[str] = "staff"
    company_access: Optional[list[str]] = None


class ForgotPasswordSchema(BaseModel):
    email: str


class ResetPasswordSchema(BaseModel):
    email: str
    otp: str
    new_password: str


class GoogleLoginSchema(BaseModel):
    id_token: str


class ProfileUpdateSchema(BaseModel):
    full_name: Optional[str] = None
    phone_number: Optional[str] = None
    workplace: Optional[str] = None
    current_password: Optional[str] = None
    new_password: Optional[str] = None


class CreateUserSchema(BaseModel):
    username: str
    password: str
    full_name: str
    phone_number: Optional[str] = "-"
    workplace: Optional[str] = "-"
    role: Optional[str] = "staff"
    company_access: Optional[list[str]] = None


class UpdateUserSchema(BaseModel):
    full_name: Optional[str] = None
    phone_number: Optional[str] = None
    workplace: Optional[str] = None
    role: Optional[str] = None
    password: Optional[str] = None
    company_access: Optional[list[str]] = None


class LinkGoogleSchema(BaseModel):
    id_token: str
