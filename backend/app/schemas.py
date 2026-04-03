from pydantic import BaseModel
from typing import Optional
import datetime

class UserOut(BaseModel):
    id: str
    email: str
    first_name: Optional[str]
    last_name: Optional[str]
    role: str
    status: str

    class Config:
        from_attributes = True

class BootstrapRequest(BaseModel):
    requested_role: str
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    fcm_token: Optional[str] = None

class FCMTokenUpdate(BaseModel):
    fcm_token: str

class InternshipCreate(BaseModel):
    title: str
    description: str

class InternshipOut(BaseModel):
    id: str
    title: str
    description: str
    status: str

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