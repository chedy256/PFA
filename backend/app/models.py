from sqlalchemy import Column, String, ForeignKey, DateTime, Text
from sqlalchemy.orm import relationship
from database import Base
import datetime

class User(Base):
    _tablename_ = "users"

    id = Column(String, primary_key=True)
    email = Column(String, unique=True, nullable=False)
    first_name = Column(String, nullable=True)
    last_name = Column(String, nullable=True)
    role = Column(String, default="none")
    status = Column(String, default="pending")
    requested_role = Column(String, nullable=True)
    fcm_token = Column(String, nullable=True)
    department = Column(String, nullable=True)


class Internship(Base):
    _tablename_ = "internships"

    id = Column(String, primary_key=True)
    student_id = Column(String, ForeignKey("users.id"))
    teacher_id = Column(String, ForeignKey("users.id"), nullable=True)
    title = Column(String)
    description = Column(Text)
    status = Column(String, default="pending")

    student = relationship("User", foreign_keys=[student_id])
    teacher = relationship("User", foreign_keys=[teacher_id])


class Message(Base):
    _tablename_ = "messages"

    id = Column(String, primary_key=True)
    sender_id = Column(String, ForeignKey("users.id"), nullable=False)
    receiver_id = Column(String, ForeignKey("users.id"), nullable=False)
    content = Column(Text, nullable=False)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)

    sender = relationship("User", foreign_keys=[sender_id])
    receiver = relationship("User", foreign_keys=[receiver_id])