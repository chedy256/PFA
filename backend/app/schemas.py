from pydantic import BaseModel
from typing import Optional
import datetime

class UserOut(BaseModel):
    id: str
    email: str
    first_name: str
    last_name: str
    cin_number: Optional[str] = None
    role: str
    status: str

    class Config:
        from_attributes = True


class PaginatedUsersOut(BaseModel):
    users: list[UserOut]
    total_count: int
    total_pages: int
    current_page: int


class BootstrapRequest(BaseModel):
    requested_role: str
    first_name: str
    last_name: str
    fcm_token: Optional[str] = None

class FCMTokenUpdate(BaseModel):
    fcm_token: str

class InternshipCreate(BaseModel):
    title: str
    description: str
    type: Optional[str] = "ete"
    company_name: Optional[str] = None
    company_address: Optional[str] = None
    company_sector: Optional[str] = None
    company_phone: Optional[str] = None
    supervisor_name: Optional[str] = None
    supervisor_email: Optional[str] = None
    supervisor_function: Optional[str] = None

class InternshipOut(BaseModel):
    id: str
    title: str
    description: str
    status: str
    type: Optional[str] = "ete"
    company_name: Optional[str] = None
    company_address: Optional[str] = None
    company_sector: Optional[str] = None
    company_phone: Optional[str] = None
    supervisor_name: Optional[str] = None
    supervisor_email: Optional[str] = None
    supervisor_function: Optional[str] = None

    class Config:
        from_attributes = True

class MessageCreate(BaseModel):
    receiver_id: str
    content: str

class MessageOut(BaseModel):
    id: str
    sender_id: str
    receiver_id: str
    content: str
    created_at: datetime.datetime

    class Config:
        from_attributes = True

class DeviceCreate(BaseModel):
    platform: str
    fcm_token: Optional[str] = None
    web_subscription: Optional[dict] = None

class NotificationOut(BaseModel):
    id: str
    title: str
    body: str
    data: Optional[dict] = None
    status: str
    created_at: datetime.datetime

    class Config:
        from_attributes = True