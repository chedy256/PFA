import enum
import uuid
from datetime import datetime, timezone

from sqlalchemy import (
    Column,
    String,
    Text,
    Integer,
    Float,
    Boolean,
    Date,
    DateTime,
    ForeignKey,
    Enum,
)
from sqlalchemy.dialects.postgresql import UUID, ARRAY
from sqlalchemy.orm import relationship

from app.database import Base


#  Enums


class InternshipType(str, enum.Enum):
    ete = "ete"
    pfe = "pfe"


class UserRole(str, enum.Enum):
    student = "student"
    teacher = "teacher"
    admin = "admin"
    pending = "pending"


class InternshipStatus(str, enum.Enum):
    open = "open"
    assigned = "assigned"
    completed = "completed"


class RegistrationStatus(str, enum.Enum):
    pending = "pending"
    approved = "approved"
    rejected = "rejected"



#  User

class User(Base):
    __tablename__ = "users"

    id = Column(
        String,
        primary_key=True,
        default=lambda: str(uuid.uuid4())
    )
    first_name = Column(String, nullable=False)
    last_name = Column(String, nullable=False)
    cin_number = Column(String, nullable=True)
    email = Column(String, unique=True, nullable=False)
    email_enabled = Column(Boolean,default=True, nullable=False)
    ws_number = Column(Integer, nullable=True)
    ws_number_enabled = Column(Boolean,default=False, nullable=False)
    phone_number = Column(Integer, nullable=True)
    phone_number_enabled = Column(Boolean,default=False, nullable=False)
    role = Column(Enum(UserRole), nullable=False)
    department = Column(String, nullable=True)
    status = Column(String, default="active")
    requested_role = Column(String, nullable=True)
    fcm_token = Column(String, nullable=True)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc), nullable=False)

    # Internships where the user is the primary student
    student_internships = relationship(
        "Internship",
        back_populates="student",
        foreign_keys="[Internship.student_id]",
    )
    # Internships where the user is the secondary student
    student_internships_2 = relationship(
        "Internship",
        back_populates="student_2",
        foreign_keys="[Internship.student_id_2]",
    )
    # Internships where the user is the supervising teacher
    teacher_internships = relationship(
        "Internship",
        back_populates="teacher",
        foreign_keys="[Internship.teacher_id]",
    )
    # Registration requests made by the user
    pending_registrations = relationship(
        "PendingRegistration",
        back_populates="user",
    )
    # Evaluations written by the teacher
    evaluations = relationship(
        "Evaluation",
        back_populates="teacher",
    )



#  Internship


class Internship(Base):
    __tablename__ = "internships"

    id = Column(
        String,
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
    )
    title = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    requirements = Column(Text, nullable=True)
    tags = Column(ARRAY(String), default=list)
    type = Column(
        Enum(InternshipType),
        nullable=False,
        default=InternshipType.ete,
    )
    status = Column(
        Enum(InternshipStatus),
        nullable=False,
        default=InternshipStatus.open,
    )

    company_name = Column(String, nullable=True)
    company_address = Column(String, nullable=True)
    company_sector = Column(String, nullable=True)
    company_phone = Column(String, nullable=True)
    supervisor_name = Column(String, nullable=True)
    supervisor_email = Column(String, nullable=True)
    supervisor_function = Column(String, nullable=True)

    start_date = Column(Date, nullable=True)
    end_date = Column(Date, nullable=True)

    student_id = Column(
        String,
        ForeignKey("users.id"),
        nullable=False,         # primary student — required
    )
    student_id_2 = Column(
        String,
        ForeignKey("users.id"),
        nullable=True,          # secondary student — optional
    )

    teacher_id = Column(
        String,
        ForeignKey("users.id"),
        nullable=True,
    )
    department = Column(String, nullable=True)
    status = Column(String, default="active")
    requested_role = Column(String, nullable=True)
    fcm_token = Column(String, nullable=True)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc), nullable=False)
    updated_at = Column(
        DateTime,
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
        nullable=False,
    )

    # ── relationships ──
    student = relationship(
        "User",
        back_populates="student_internships",
        foreign_keys=[student_id],
    )
    student_2 = relationship(
        "User",
        back_populates="student_internships_2",
        foreign_keys=[student_id_2],
    )
    teacher = relationship(
        "User",
        back_populates="teacher_internships",
        foreign_keys=[teacher_id],
    )
    evaluations = relationship(
        "Evaluation",
        back_populates="internship",
    )



#  Pending Registration


class PendingRegistration(Base):
    __tablename__ = "pending_registrations"

    id = Column(
        String,
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
    )
    user_id = Column(
        String,
        ForeignKey("users.id"),
        nullable=False,
    )
    requested_role = Column(Enum(UserRole), nullable=False)
    status = Column(
        Enum(RegistrationStatus),
        nullable=False,
        default=RegistrationStatus.pending,
    )
    reason = Column(String, nullable=True)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc), nullable=False)
    reviewed_at = Column(DateTime, nullable=True)

    # ── relationships ──
    user = relationship(
        "User",
        back_populates="pending_registrations",
    )



#  Evaluation


class Evaluation(Base):
    __tablename__ = "evaluations"

    id = Column(
        String,
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
    )
    internship_id = Column(
        String,
        ForeignKey("internships.id"),
        nullable=False,
    )
    teacher_id = Column(
        String,
        ForeignKey("users.id"),
        nullable=False,
    )
    feedback = Column(Text, nullable=True)
    document_url = Column(String, nullable=True)
    score = Column(Float, nullable=True)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc), nullable=False)
    updated_at = Column(
        DateTime,
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
        nullable=False,
    )

    # ── relationships ──
    internship = relationship(
        "Internship",
        back_populates="evaluations",
    )
    teacher = relationship(
        "User",
        back_populates="evaluations",
    )

class Message(Base):
    __tablename__ = "messages"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    sender_id = Column(String, ForeignKey("users.id"), nullable=False)
    receiver_id = Column(String, ForeignKey("users.id"), nullable=False)
    content = Column(Text, nullable=False)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc), nullable=False)

    sender = relationship("User", foreign_keys=[sender_id])
    receiver = relationship("User", foreign_keys=[receiver_id])