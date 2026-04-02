from sqlalchemy import Column, String, ForeignKey, DateTime, Text
from sqlalchemy.orm import relationship
from database import Base
import datetime


class User(Base):
    __tablename__ = "users"

    id = Column(String, primary_key=True)  # Firebase UID
    email = Column(String, unique=True, nullable=False)
    first_name = Column(String, nullable=True)
    last_name = Column(String, nullable=True)
    role = Column(String, default="none")
    status = Column(String, default="pending")  # ✅ ajouté
    requested_role = Column(String, nullable=True)  # ✅ ajouté
    fcm_token = Column(String, nullable=True)  # ✅ ajouté
    department = Column(String, nullable=True)


class Internship(Base):
    __tablename__ = "internships"

    id = Column(String, primary_key=True)
    student_id = Column(String, ForeignKey("users.id"))
    teacher_id = Column(String, ForeignKey("users.id"), nullable=True)
    title = Column(String)
    description = Column(Text)
    status = Column(String, default="pending")

    student = relationship("User", foreign_keys=[student_id])
    teacher = relationship("User", foreign_keys=[teacher_id])
