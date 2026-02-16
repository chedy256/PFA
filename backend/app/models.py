from sqlalchemy import Column, String, ForeignKey, Date, Text
from sqlalchemy.orm import relationship
from database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(String, primary_key=True)  # Firebase UID
    email = Column(String, unique=True, nullable=False)
    first_name = Column(String, nullable=False)
    last_name = Column(String, nullable=False)
    role = Column(String, nullable=False)

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
