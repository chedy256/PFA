import enum
from time import timezone
import uuid
import datetime

from sqlalchemy import (
    Column,
    String,
    Text,
    Integer,
    Float,
    Date,
    DateTime,
    ForeignKey,
    Enum,
    CheckConstraint,
)
from sqlalchemy.dialects.postgresql import UUID, ARRAY
from sqlalchemy.orm import relationship

from app.database import Base


#  Enums


class UserRole(str, enum.Enum):
    student = "student"
    teacher = "teacher"
    admin = "admin"


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

    uuid = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
    )
    first_name = Column(String, nullable=False)
    last_name = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=False)
    ws_number = Column(Integer, nullable=True)
    phone_number = Column(Integer, nullable=True)
    role = Column(Enum(UserRole), nullable=False)
    department = Column(String, nullable=True)
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
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
    )
    title = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    requirements = Column(Text, nullable=True)
    tags = Column(ARRAY(String), default=list)
    status = Column(
        Enum(InternshipStatus),
        nullable=False,
        default=InternshipStatus.open,
    )
    start_date = Column(Date, nullable=True)
    end_date = Column(Date, nullable=True)

    student_id = Column(
        UUID(as_uuid=True),
        ForeignKey("users.uuid"),
        nullable=False,         # primary student — required
    )
    student_id_2 = Column(
        UUID(as_uuid=True),
        ForeignKey("users.uuid"),
        nullable=True,          # secondary student — optional
    )

    teacher_id = Column(
        UUID(as_uuid=True),
        ForeignKey("users.uuid"),
        nullable=True,
    )
    department = Column(String, nullable=True)
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
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
    )
    user_id = Column(
        UUID(as_uuid=True),
        ForeignKey("users.uuid"),
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
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
    )
    internship_id = Column(
        UUID(as_uuid=True),
        ForeignKey("internships.id"),
        nullable=False,
    )
    teacher_id = Column(
        UUID(as_uuid=True),
        ForeignKey("users.uuid"),
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